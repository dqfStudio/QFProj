//
//  HTextView.m
//
//  Created by ibireme on 15/2/25.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "HTextView.h"
#import "HTextInput.h"
#import "HTextContainerView.h"
#import "HTextSelectionView.h"
#import "HTextMagnifier.h"
#import "HTextEffectWindow.h"
#import "HTextKeyboardManager.h"
#import "HTextUtilities.h"
#import "HTextTransaction.h"
#import "HTextWeakProxy.h"
#import "NSAttributedString+HText.h"
#import "UIPasteboard+HText.h"
#import "UIView+HText.h"


static double _HDeviceSystemVersion() {
    static double version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion.doubleValue;
    });
    return version;
}

#ifndef kSystemVersion
#define kSystemVersion _HDeviceSystemVersion()
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif



#define kDefaultUndoLevelMax 20 // Default maximum undo level

#define kAutoScrollMinimumDuration 0.1 // Time in seconds to tick auto-scroll.
#define kLongPressMinimumDuration 0.5 // Time in seconds the fingers must be held down for long press gesture.
#define kLongPressAllowableMovement 10.0 // Maximum movement in points allowed before the long press fails.

#define kMagnifierRangedTrackFix -6.0 // Magnifier ranged offset fix.
#define kMagnifierRangedPopoverOffset 4.0 // Magnifier ranged popover offset.
#define kMagnifierRangedCaptureOffset -6.0 // Magnifier ranged capture center offset.

#define kHighlightFadeDuration 0.15 // Time in seconds for highlight fadeout animation.

#define kDefaultInset UIEdgeInsetsMake(6, 4, 6, 4)
#define kDefaultVerticalInset UIEdgeInsetsMake(4, 6, 4, 6)


NSString *const HTextViewTextDidBeginEditingNotification = @"HTextViewTextDidBeginEditing";
NSString *const HTextViewTextDidChangeNotification = @"HTextViewTextDidChange";
NSString *const HTextViewTextDidEndEditingNotification = @"HTextViewTextDidEndEditing";


typedef NS_ENUM (NSUInteger, HTextGrabberDirection) {
    kStart = 1,
    kEnd   = 2,
};

typedef NS_ENUM(NSUInteger, HTextMoveDirection) {
    kLeft   = 1,
    kTop    = 2,
    kRight  = 3,
    kBottom = 4,
};


/// An object that captures the state of the text view. Used for undo and redo.
@interface _HTextViewUndoObject : NSObject
@property (nonatomic, strong) NSAttributedString *text;
@property (nonatomic, assign) NSRange selectedRange;
@end
@implementation _HTextViewUndoObject
+ (instancetype)objectWithText:(NSAttributedString *)text range:(NSRange)range {
    _HTextViewUndoObject *obj = [self new];
    obj.text = text ? text : [NSAttributedString new];
    obj.selectedRange = range;
    return obj;
}
@end


@interface HTextView () <UIScrollViewDelegate, UIAlertViewDelegate, HTextDebugTarget, HTextKeyboardObserver> {
    
    HTextRange *_selectedTextRange; /// nonnull
    HTextRange *_markedTextRange;
    
    __weak id<HTextViewDelegate> _outerDelegate;
    
    UIImageView *_placeHolderView;
    
    NSMutableAttributedString *_innerText; ///< nonnull, inner attributed text
    NSMutableAttributedString *_delectedText; ///< detected text for display
    HTextContainer *_innerContainer; ///< nonnull, inner text container
    HTextLayout *_innerLayout; ///< inner text layout, the text in this layout is longer than `_innerText` by appending '\n'
    
    HTextContainerView *_containerView; ///< nonnull
    HTextSelectionView *_selectionView; ///< nonnull
    HTextMagnifier *_magnifierCaret; ///< nonnull
    HTextMagnifier *_magnifierRanged; ///< nonnull
    
    NSMutableAttributedString *_typingAttributesHolder; ///< nonnull, typing attributes
    NSDataDetector *_dataDetector;
    CGFloat _magnifierRangedOffset;
    
    NSRange _highlightRange; ///< current highlight range
    HTextHighlight *_highlight; ///< highlight attribute in `_highlightRange`
    HTextLayout *_highlightLayout; ///< when _state.showingHighlight=YES, this layout should be displayed
    HTextRange *_trackingRange; ///< the range in _innerLayout, may out of _innerText.
    
    BOOL _insetModifiedByKeyboard; ///< text is covered by keyboard, and the contentInset is modified
    UIEdgeInsets _originalContentInset; ///< the original contentInset before modified
    UIEdgeInsets _originalScrollIndicatorInsets; ///< the original scrollIndicatorInsets before modified
    
    NSTimer *_longPressTimer;
    NSTimer *_autoScrollTimer;
    CGFloat _autoScrollOffset; ///< current auto scroll offset which shoud add to scroll view
    NSInteger _autoScrollAcceleration; ///< an acceleration coefficient for auto scroll
    NSTimer *_selectionDotFixTimer; ///< fix the selection dot in window if the view is moved by parents
    CGPoint _previousOriginInWindow;
    
    CGPoint _touchBeganPoint;
    CGPoint _trackingPoint;
    NSTimeInterval _touchBeganTime;
    NSTimeInterval _trackingTime;
    
    NSMutableArray *_undoStack;
    NSMutableArray *_redoStack;
    NSRange _lastTypeRange;
    
    struct {
        unsigned int trackingGrabber : 2;       ///< HTextGrabberDirection, current tracking grabber
        unsigned int trackingCaret : 1;         ///< track the caret
        unsigned int trackingPreSelect : 1;     ///< track pre-select
        unsigned int trackingTouch : 1;         ///< is in touch phase
        unsigned int swallowTouch : 1;          ///< don't forward event to next responder
        unsigned int touchMoved : 3;            ///< HTextMoveDirection, move direction after touch began
        unsigned int selectedWithoutEdit : 1;   ///< show selected range but not first responder
        unsigned int deleteConfirm : 1;         ///< delete a binding text range
        unsigned int ignoreFirstResponder : 1;  ///< ignore become first responder temporary
        unsigned int ignoreTouchBegan : 1;      ///< ignore begin tracking touch temporary
        
        unsigned int showingMagnifierCaret : 1;
        unsigned int showingMagnifierRanged : 1;
        unsigned int showingMenu : 1;
        unsigned int showingHighlight : 1;
        
        unsigned int typingAttributesOnce : 1;  ///< apply the typing attributes once
        unsigned int clearsOnInsertionOnce : 1; ///< select all once when become first responder
        unsigned int autoScrollTicked : 1;      ///< auto scroll did tick scroll at this timer period
        unsigned int firstShowDot : 1;          ///< the selection grabber dot has displayed at least once
        unsigned int needUpdate : 1;            ///< the layout or selection view is 'dirty' and need update
        unsigned int placeholderNeedUpdate : 1; ///< the placeholder need update it's contents
        
        unsigned int insideUndoBlock : 1;
        unsigned int firstResponderBeforeUndoAlert : 1;
    } _state;
}

@end


@implementation HTextView

#pragma mark - @protocol UITextInputTraits
@synthesize autocapitalizationType = _autocapitalizationType;
@synthesize autocorrectionType = _autocorrectionType;
@synthesize spellCheckingType = _spellCheckingType;
@synthesize keyboardType = _keyboardType;
@synthesize keyboardAppearance = _keyboardAppearance;
@synthesize returnKeyType = _returnKeyType;
@synthesize enablesReturnKeyAutomatically = _enablesReturnKeyAutomatically;
@synthesize secureTextEntry = _secureTextEntry;

#pragma mark - @protocol UITextInput
@synthesize selectedTextRange = _selectedTextRange;  //copy nonnull (HTextRange*)
@synthesize markedTextRange = _markedTextRange;      //readonly     (HTextRange*)
@synthesize markedTextStyle = _markedTextStyle;      //copy
@synthesize inputDelegate = _inputDelegate;         //assign
@synthesize tokenizer = _tokenizer;                 //readonly

#pragma mark - @protocol UITextInput optional
@synthesize selectionAffinity = _selectionAffinity;


#pragma mark - Private

/// Update layout and selection before runloop sleep/end.
- (void)_commitUpdate {
#if !TARGET_INTERFACE_BUILDER
    _state.needUpdate = YES;
    [[HTextTransaction transactionWithTarget:self selector:@selector(_updateIfNeeded)] commit];
#else
    [self _update];
#endif
}

/// Update layout and selection view if needed.
- (void)_updateIfNeeded {
    if (_state.needUpdate) {
        [self _update];
    }
}

/// Update layout and selection view immediately.
- (void)_update {
    _state.needUpdate = NO;
    [self _updateLayout];
    [self _updateSelectionView];
}

/// Update layout immediately.
- (void)_updateLayout {
    NSMutableAttributedString *text = _innerText.mutableCopy;
    _placeHolderView.hidden = text.length > 0;
    if ([self _detectText:text]) {
        _delectedText = text;
    } else {
        _delectedText = nil;
    }
    [text replaceCharactersInRange:NSMakeRange(text.length, 0) withString:@"\r"]; // add for nextline caret
    [text h_removeDiscontinuousAttributesInRange:NSMakeRange(_innerText.length, 1)];
    [text removeAttribute:HTextBorderAttributeName range:NSMakeRange(_innerText.length, 1)];
    [text removeAttribute:HTextBackgroundBorderAttributeName range:NSMakeRange(_innerText.length, 1)];
    if (_innerText.length == 0) {
        [text h_setAttributes:_typingAttributesHolder.h_attributes]; // add for empty text caret
    }
    if (_selectedTextRange.end.offset == _innerText.length) {
        [_typingAttributesHolder.h_attributes enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
            [text h_setAttribute:key value:value range:NSMakeRange(self->_innerText.length, 1)];
        }];
    }
    [self willChangeValueForKey:@"textLayout"];
    _innerLayout = [HTextLayout layoutWithContainer:_innerContainer text:text];
    [self didChangeValueForKey:@"textLayout"];
    CGSize size = [_innerLayout textBoundingSize];
    CGSize visibleSize = [self _getVisibleSize];
    if (_innerContainer.isVerticalForm) {
        size.height = visibleSize.height;
        if (size.width < visibleSize.width) size.width = visibleSize.width;
    } else {
        size.width = visibleSize.width;
    }
    
    [_containerView setLayout:_innerLayout withFadeDuration:0];
    _containerView.frame = (CGRect){.size = size};
    _state.showingHighlight = NO;
    self.contentSize = size;
}

/// Update selection view immediately.
/// This method should be called after "layout update" finished.
- (void)_updateSelectionView {
    _selectionView.frame = _containerView.frame;
    _selectionView.caretBlinks = NO;
    _selectionView.caretVisible = NO;
    _selectionView.selectionRects = nil;
    [[HTextEffectWindow sharedWindow] hideSelectionDot:_selectionView];
    if (!_innerLayout) return;
    
    NSMutableArray *allRects = [NSMutableArray new];
    BOOL containsDot = NO;
    
    HTextRange *selectedRange = _selectedTextRange;
    if (_state.trackingTouch && _trackingRange) {
        selectedRange = _trackingRange;
    }
    
    if (_markedTextRange) {
        NSArray *rects = [_innerLayout selectionRectsWithoutStartAndEndForRange:_markedTextRange];
        if (rects) [allRects addObjectsFromArray:rects];
        if (selectedRange.asRange.length > 0) {
            rects = [_innerLayout selectionRectsWithOnlyStartAndEndForRange:selectedRange];
            if (rects) [allRects addObjectsFromArray:rects];
            containsDot = rects.count > 0;
        } else {
            CGRect rect = [_innerLayout caretRectForPosition:selectedRange.end];
            _selectionView.caretRect = [self _convertRectFromLayout:rect];
            _selectionView.caretVisible = YES;
            _selectionView.caretBlinks = YES;
        }
    } else {
        if (selectedRange.asRange.length == 0) { // only caret
            if (self.isFirstResponder || _state.trackingPreSelect) {
                CGRect rect = [_innerLayout caretRectForPosition:selectedRange.end];
                _selectionView.caretRect = [self _convertRectFromLayout:rect];
                _selectionView.caretVisible = YES;
                if (!_state.trackingCaret && !_state.trackingPreSelect) {
                    _selectionView.caretBlinks = YES;
                }
            }
        } else { // range selected
            if ((self.isFirstResponder && !_state.deleteConfirm) ||
                (!self.isFirstResponder && _state.selectedWithoutEdit)) {
                NSArray *rects = [_innerLayout selectionRectsForRange:selectedRange];
                if (rects) [allRects addObjectsFromArray:rects];
                containsDot = rects.count > 0;
            } else if ((!self.isFirstResponder && _state.trackingPreSelect) ||
                       (self.isFirstResponder && _state.deleteConfirm)){
                NSArray *rects = [_innerLayout selectionRectsWithoutStartAndEndForRange:selectedRange];
                if (rects) [allRects addObjectsFromArray:rects];
            }
        }
    }
    [allRects enumerateObjectsUsingBlock:^(HTextSelectionRect *rect, NSUInteger idx, BOOL *stop) {
        rect.rect = [self _convertRectFromLayout:rect.rect];
    }];
    _selectionView.selectionRects = allRects;
    if (!_state.firstShowDot && containsDot) {
        _state.firstShowDot = YES;
        /*
         The dot position may be wrong at the first time displayed.
         I can't find the reason. Here's a workaround.
         */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[HTextEffectWindow sharedWindow] showSelectionDot:self->_selectionView];
        });
    }
    [[HTextEffectWindow sharedWindow] showSelectionDot:_selectionView];
    
    if (containsDot) {
        [self _startSelectionDotFixTimer];
    } else {
        [self _endSelectionDotFixTimer];
    }
}

/// Update inner contains's size.
- (void)_updateInnerContainerSize {
    CGSize size = [self _getVisibleSize];
    if (_innerContainer.isVerticalForm) size.width = CGFLOAT_MAX;
    else size.height = CGFLOAT_MAX;
    _innerContainer.size = size;
}

/// Update placeholder before runloop sleep/end.
- (void)_commitPlaceholderUpdate {
#if !TARGET_INTERFACE_BUILDER
    _state.placeholderNeedUpdate = YES;
    [[HTextTransaction transactionWithTarget:self selector:@selector(_updatePlaceholderIfNeeded)] commit];
#else
    [self _updatePlaceholder];
#endif
}

/// Update placeholder if needed.
- (void)_updatePlaceholderIfNeeded {
    if (_state.placeholderNeedUpdate) {
        _state.placeholderNeedUpdate = NO;
        [self _updatePlaceholder];
    }
}

/// Update placeholder immediately.
- (void)_updatePlaceholder {
    CGRect frame = CGRectZero;
    _placeHolderView.image = nil;
    _placeHolderView.frame = frame;
    if (_placeholderAttributedText.length > 0) {
        HTextContainer *container = _innerContainer.copy;
        container.size = self.bounds.size;
        container.truncationType = HTextTruncationTypeEnd;
        container.truncationToken = nil;
        HTextLayout *layout = [HTextLayout layoutWithContainer:container text:_placeholderAttributedText];
        CGSize size = [layout textBoundingSize];
        BOOL needDraw = size.width > 1 && size.height > 1;
        if (needDraw) {
            UIGraphicsBeginImageContextWithOptions(size, NO, 0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [layout drawInContext:context size:size debug:self.debugOption];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            _placeHolderView.image = image;
            frame.size = image.size;
            if (container.isVerticalForm) {
                frame.origin.x = self.bounds.size.width - image.size.width;
            } else {
                frame.origin = CGPointZero;
            }
            _placeHolderView.frame = frame;
        }
    }
}

/// Update the `_selectedTextRange` to a single position by `_trackingPoint`.
- (void)_updateTextRangeByTrackingCaret {
    if (!_state.trackingTouch) return;
    
    CGPoint trackingPoint = [self _convertPointToLayout:_trackingPoint];
    HTextPosition *newPos = [_innerLayout closestPositionToPoint:trackingPoint];
    if (newPos) {
        newPos = [self _correctedTextPosition:newPos];
        if (_markedTextRange) {
            if ([newPos compare:_markedTextRange.start] == NSOrderedAscending) {
                newPos = _markedTextRange.start;
            } else if ([newPos compare:_markedTextRange.end] == NSOrderedDescending) {
                newPos = _markedTextRange.end;
            }
        }
        HTextRange *newRange = [HTextRange rangeWithRange:NSMakeRange(newPos.offset, 0) affinity:newPos.affinity];
        _trackingRange = newRange;
    }
}

/// Update the `_selectedTextRange` to a new range by `_trackingPoint` and `_state.trackingGrabber`.
- (void)_updateTextRangeByTrackingGrabber {
    if (!_state.trackingTouch || !_state.trackingGrabber) return;
    
    BOOL isStart = _state.trackingGrabber == kStart;
    CGPoint magPoint = _trackingPoint;
    magPoint.y += kMagnifierRangedTrackFix;
    magPoint = [self _convertPointToLayout:magPoint];
    HTextPosition *position = [_innerLayout positionForPoint:magPoint
                                                  oldPosition:(isStart ? _selectedTextRange.start : _selectedTextRange.end)
                                                otherPosition:(isStart ? _selectedTextRange.end : _selectedTextRange.start)];
    if (position) {
        position = [self _correctedTextPosition:position];
        if ((NSUInteger)position.offset > _innerText.length) {
            position = [HTextPosition positionWithOffset:_innerText.length];
        }
        HTextRange *newRange = [HTextRange rangeWithStart:(isStart ? position : _selectedTextRange.start)
                                                        end:(isStart ? _selectedTextRange.end : position)];
        _trackingRange = newRange;
    }
}

/// Update the `_selectedTextRange` to a new range/position by `_trackingPoint`.
- (void)_updateTextRangeByTrackingPreSelect {
    if (!_state.trackingTouch) return;
    HTextRange *newRange = [self _getClosestTokenRangeAtPoint:_trackingPoint];
    _trackingRange = newRange;
}

/// Show or update `_magnifierCaret` based on `_trackingPoint`, and hide `_magnifierRange`.
- (void)_showMagnifierCaret {
    if (HTextIsAppExtension()) return;
    
    if (_state.showingMagnifierRanged) {
        _state.showingMagnifierRanged = NO;
        [[HTextEffectWindow sharedWindow] hideMagnifier:_magnifierRanged];
    }
    
    _magnifierCaret.hostPopoverCenter = _trackingPoint;
    _magnifierCaret.hostCaptureCenter = _trackingPoint;
    if (!_state.showingMagnifierCaret) {
        _state.showingMagnifierCaret = YES;
        [[HTextEffectWindow sharedWindow] showMagnifier:_magnifierCaret];
    } else {
        [[HTextEffectWindow sharedWindow] moveMagnifier:_magnifierCaret];
    }
}

/// Show or update `_magnifierRanged` based on `_trackingPoint`, and hide `_magnifierCaret`.
- (void)_showMagnifierRanged {
    if (HTextIsAppExtension()) return;
    
    if (_verticalForm) { // hack for vertical form...
        [self _showMagnifierCaret];
        return;
    }
    
    if (_state.showingMagnifierCaret) {
        _state.showingMagnifierCaret = NO;
        [[HTextEffectWindow sharedWindow] hideMagnifier:_magnifierCaret];
    }
    
    CGPoint magPoint = _trackingPoint;
    if (_verticalForm) {
        magPoint.x += kMagnifierRangedTrackFix;
    } else {
        magPoint.y += kMagnifierRangedTrackFix;
    }
    
    HTextRange *selectedRange = _selectedTextRange;
    if (_state.trackingTouch && _trackingRange) {
        selectedRange = _trackingRange;
    }
    
    HTextPosition *position;
    if (_markedTextRange) {
        position = selectedRange.end;
    } else {
        position = [_innerLayout positionForPoint:[self _convertPointToLayout:magPoint]
                                      oldPosition:(_state.trackingGrabber == kStart ? selectedRange.start : selectedRange.end)
                                    otherPosition:(_state.trackingGrabber == kStart ? selectedRange.end : selectedRange.start)];
    }
    
    NSUInteger lineIndex = [_innerLayout lineIndexForPosition:position];
    if (lineIndex < _innerLayout.lines.count) {
        HTextLine *line = _innerLayout.lines[lineIndex];
        CGRect lineRect = [self _convertRectFromLayout:line.bounds];
        if (_verticalForm) {
            magPoint.x = HTEXT_CLAMP(magPoint.x, CGRectGetMinX(lineRect), CGRectGetMaxX(lineRect));
        } else {
            magPoint.y = HTEXT_CLAMP(magPoint.y, CGRectGetMinY(lineRect), CGRectGetMaxY(lineRect));
        }
        CGPoint linePoint = [_innerLayout linePositionForPosition:position];
        linePoint = [self _convertPointFromLayout:linePoint];
        
        CGPoint popoverPoint = linePoint;
        if (_verticalForm) {
            popoverPoint.x = linePoint.x + _magnifierRangedOffset;
        } else {
            popoverPoint.y = linePoint.y + _magnifierRangedOffset;
        }
        
        CGPoint capturePoint;
        if (_verticalForm) {
            capturePoint.x = linePoint.x + kMagnifierRangedCaptureOffset;
            capturePoint.y = linePoint.y;
        } else {
            capturePoint.x = linePoint.x;
            capturePoint.y = linePoint.y + kMagnifierRangedCaptureOffset;
        }
        
        _magnifierRanged.hostPopoverCenter = popoverPoint;
        _magnifierRanged.hostCaptureCenter = capturePoint;
        if (!_state.showingMagnifierRanged) {
            _state.showingMagnifierRanged = YES;
            [[HTextEffectWindow sharedWindow] showMagnifier:_magnifierRanged];
        } else {
            [[HTextEffectWindow sharedWindow] moveMagnifier:_magnifierRanged];
        }
    }
}

/// Update the showing magnifier.
- (void)_updateMagnifier {
    if (HTextIsAppExtension()) return;
    
    if (_state.showingMagnifierCaret) {
        [[HTextEffectWindow sharedWindow] moveMagnifier:_magnifierCaret];
    }
    if (_state.showingMagnifierRanged) {
        [[HTextEffectWindow sharedWindow] moveMagnifier:_magnifierRanged];
    }
}

/// Hide the `_magnifierCaret` and `_magnifierRanged`.
- (void)_hideMagnifier {
    if (HTextIsAppExtension()) return;
    
    if (_state.showingMagnifierCaret || _state.showingMagnifierRanged) {
        // disable touch began temporary to ignore caret animation overlap
        _state.ignoreTouchBegan = YES;
        __weak typeof(self) _self = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(_self) self = _self;
            if (self) self->_state.ignoreTouchBegan = NO;
        });
    }
    
    if (_state.showingMagnifierCaret) {
        _state.showingMagnifierCaret = NO;
        [[HTextEffectWindow sharedWindow] hideMagnifier:_magnifierCaret];
    }
    if (_state.showingMagnifierRanged) {
        _state.showingMagnifierRanged = NO;
        [[HTextEffectWindow sharedWindow] hideMagnifier:_magnifierRanged];
    }
}

/// Show and update the UIMenuController.
- (void)_showMenu {
    CGRect rect;
    if (_selectionView.caretVisible) {
        rect = _selectionView.caretView.frame;
    } else if (_selectionView.selectionRects.count > 0) {
        HTextSelectionRect *sRect = _selectionView.selectionRects.firstObject;
        rect = sRect.rect;
        for (NSUInteger i = 1; i < _selectionView.selectionRects.count; i++) {
            sRect = _selectionView.selectionRects[i];
            rect = CGRectUnion(rect, sRect.rect);
        }
        
        CGRect inter = CGRectIntersection(rect, self.bounds);
        if (!CGRectIsNull(inter) && inter.size.height > 1) {
            rect = inter; //clip to bounds
        } else {
            if (CGRectGetMinY(rect) < CGRectGetMinY(self.bounds)) {
                rect.size.height = 1;
                rect.origin.y = CGRectGetMinY(self.bounds);
            } else {
                rect.size.height = 1;
                rect.origin.y = CGRectGetMaxY(self.bounds);
            }
        }
        
        HTextKeyboardManager *mgr = [HTextKeyboardManager defaultManager];
        if (mgr.keyboardVisible) {
            CGRect kbRect = [mgr convertRect:mgr.keyboardFrame toView:self];
            CGRect kbInter = CGRectIntersection(rect, kbRect);
            if (!CGRectIsNull(kbInter) && kbInter.size.height > 1 && kbInter.size.width > 1) {
                // self is covered by keyboard
                if (CGRectGetMinY(kbInter) > CGRectGetMinY(rect)) { // keyboard at bottom
                    rect.size.height -= kbInter.size.height;
                } else if (CGRectGetMaxY(kbInter) < CGRectGetMaxY(rect)) { // keyboard at top
                    rect.origin.y += kbInter.size.height;
                    rect.size.height -= kbInter.size.height;
                }
            }
        }
    } else {
        rect = _selectionView.bounds;
    }
    
    if (!self.isFirstResponder) {
        if (!_containerView.isFirstResponder) {
            [_containerView becomeFirstResponder];
        }
    }
    
    if (self.isFirstResponder || _containerView.isFirstResponder) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIMenuController *menu = [UIMenuController sharedMenuController];
            [menu setTargetRect:CGRectStandardize(rect) inView:self->_selectionView];
            [menu update];
            if (!self->_state.showingMenu || !menu.menuVisible) {
                self->_state.showingMenu = YES;
                [menu setMenuVisible:YES animated:YES];
            }
        });
    }
}

/// Hide the UIMenuController.
- (void)_hideMenu {
    if (_state.showingMenu) {
        _state.showingMenu = NO;
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuVisible:NO animated:YES];
    }
    if (_containerView.isFirstResponder) {
        _state.ignoreFirstResponder = YES;
        [_containerView resignFirstResponder]; // it will call [self becomeFirstResponder], ignore it temporary.
        _state.ignoreFirstResponder = NO;
    }
}

/// Show highlight layout based on `_highlight` and `_highlightRange`
/// If the `_highlightLayout` is nil, try to create.
- (void)_showHighlightAnimated:(BOOL)animated {
    NSTimeInterval fadeDuration = animated ? kHighlightFadeDuration : 0;
    if (!_highlight) return;
    if (!_highlightLayout) {
        NSMutableAttributedString *hiText = (_delectedText ? _delectedText : _innerText).mutableCopy;
        NSDictionary *newAttrs = _highlight.attributes;
        [newAttrs enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
            [hiText h_setAttribute:key value:value range:self->_highlightRange];
        }];
        _highlightLayout = [HTextLayout layoutWithContainer:_innerContainer text:hiText];
        if (!_highlightLayout) _highlight = nil;
    }
    
    if (_highlightLayout && !_state.showingHighlight) {
        _state.showingHighlight = YES;
        [_containerView setLayout:_highlightLayout withFadeDuration:fadeDuration];
    }
}

/// Show `_innerLayout` instead of `_highlightLayout`.
/// It does not destory the `_highlightLayout`.
- (void)_hideHighlightAnimated:(BOOL)animated {
    NSTimeInterval fadeDuration = animated ? kHighlightFadeDuration : 0;
    if (_state.showingHighlight) {
        _state.showingHighlight = NO;
        [_containerView setLayout:_innerLayout withFadeDuration:fadeDuration];
    }
}

/// Show `_innerLayout` and destory the `_highlight` and `_highlightLayout`.
- (void)_removeHighlightAnimated:(BOOL)animated {
    [self _hideHighlightAnimated:animated];
    _highlight = nil;
    _highlightLayout = nil;
}

/// Scroll current selected range to visible.
- (void)_scrollSelectedRangeToVisible {
    [self _scrollRangeToVisible:_selectedTextRange];
}

/// Scroll range to visible, take account into keyboard and insets.
- (void)_scrollRangeToVisible:(HTextRange *)range {
    if (!range) return;
    CGRect rect = [_innerLayout rectForRange:range];
    if (CGRectIsNull(rect)) return;
    rect = [self _convertRectFromLayout:rect];
    rect = [_containerView convertRect:rect toView:self];
    
    if (rect.size.width < 1) rect.size.width = 1;
    if (rect.size.height < 1) rect.size.height = 1;
    CGFloat extend = 3;
    
    BOOL insetModified = NO;
    HTextKeyboardManager *mgr = [HTextKeyboardManager defaultManager];
    
    if (mgr.keyboardVisible && self.window && self.superview && self.isFirstResponder && !_verticalForm) {
        CGRect bounds = self.bounds;
        bounds.origin = CGPointZero;
        CGRect kbRect = [mgr convertRect:mgr.keyboardFrame toView:self];
        kbRect.origin.y -= _extraAccessoryViewHeight;
        kbRect.size.height += _extraAccessoryViewHeight;
        
        kbRect.origin.x -= self.contentOffset.x;
        kbRect.origin.y -= self.contentOffset.y;
        CGRect inter = CGRectIntersection(bounds, kbRect);
        if (!CGRectIsNull(inter) && inter.size.height > 1 && inter.size.width > extend) { // self is covered by keyboard
            if (CGRectGetMinY(inter) > CGRectGetMinY(bounds)) { // keyboard below self.top
                
                UIEdgeInsets originalContentInset = self.contentInset;
                UIEdgeInsets originalScrollIndicatorInsets = self.scrollIndicatorInsets;
                if (_insetModifiedByKeyboard) {
                    originalContentInset = _originalContentInset;
                    originalScrollIndicatorInsets = _originalScrollIndicatorInsets;
                }
                
                if (originalContentInset.bottom < inter.size.height + extend) {
                    insetModified = YES;
                    if (!_insetModifiedByKeyboard) {
                        _insetModifiedByKeyboard = YES;
                        _originalContentInset = self.contentInset;
                        _originalScrollIndicatorInsets = self.scrollIndicatorInsets;
                    }
                    UIEdgeInsets newInset = originalContentInset;
                    UIEdgeInsets newIndicatorInsets = originalScrollIndicatorInsets;
                    newInset.bottom = inter.size.height + extend;
                    newIndicatorInsets.bottom = newInset.bottom;
                    UIViewAnimationOptions curve;
                    if (kiOS7Later) {
                        curve = 7 << 16;
                    } else {
                        curve = UIViewAnimationOptionCurveEaseInOut;
                    }
                    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | curve animations:^{
                        [super setContentInset:newInset];
                        [super setScrollIndicatorInsets:newIndicatorInsets];
                        [self scrollRectToVisible:CGRectInset(rect, -extend, -extend) animated:NO];
                    } completion:NULL];
                }
            }
        }
    }
    if (!insetModified) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut animations:^{
            [self _restoreInsetsAnimated:NO];
            [self scrollRectToVisible:CGRectInset(rect, -extend, -extend) animated:NO];
        } completion:NULL];
    }
}

/// Restore contents insets if modified by keyboard.
- (void)_restoreInsetsAnimated:(BOOL)animated {
    if (_insetModifiedByKeyboard) {
        _insetModifiedByKeyboard = NO;
        if (animated) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut  animations:^{
                [super setContentInset:self->_originalContentInset];
                [super setScrollIndicatorInsets:self->_originalScrollIndicatorInsets];
            } completion:NULL];
        } else {
            [super setContentInset:_originalContentInset];
            [super setScrollIndicatorInsets:_originalScrollIndicatorInsets];
        }
    }
}

/// Keyboard frame changed, scroll the caret to visible range, or modify the content insets.
- (void)_keyboardChanged {
    if (!self.isFirstResponder) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([HTextKeyboardManager defaultManager].keyboardVisible) {
            [self _scrollRangeToVisible:self->_selectedTextRange];
        } else {
            [self _restoreInsetsAnimated:YES];
        }
        [self _updateMagnifier];
        if (self->_state.showingMenu) {
            [self _showMenu];
        }
    });
}

/// Start long press timer, used for 'highlight' range text action.
- (void)_startLongPressTimer {
    [_longPressTimer invalidate];
    _longPressTimer = [NSTimer timerWithTimeInterval:kLongPressMinimumDuration
                                              target:[HTextWeakProxy proxyWithTarget:self]
                                            selector:@selector(_trackDidLongPress)
                                            userInfo:nil
                                             repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_longPressTimer forMode:NSRunLoopCommonModes];
}

/// Invalidate the long press timer.
- (void)_endLongPressTimer {
    [_longPressTimer invalidate];
    _longPressTimer = nil;
}

/// Long press detected.
- (void)_trackDidLongPress {
    [self _endLongPressTimer];
    
    BOOL dealLongPressAction = NO;
    if (_state.showingHighlight) {
        [self _hideMenu];
        
        if (_highlight.longPressAction) {
            dealLongPressAction = YES;
            CGRect rect = [_innerLayout rectForRange:[HTextRange rangeWithRange:_highlightRange]];
            rect = [self _convertRectFromLayout:rect];
            _highlight.longPressAction(self, _innerText, _highlightRange, rect);
            [self _endTouchTracking];
        } else {
            BOOL shouldHighlight = YES;
            if ([self.delegate respondsToSelector:@selector(textView:shouldLongPressHighlight:inRange:)]) {
                shouldHighlight = [self.delegate textView:self shouldLongPressHighlight:_highlight inRange:_highlightRange];
            }
            if (shouldHighlight && [self.delegate respondsToSelector:@selector(textView:didLongPressHighlight:inRange:rect:)]) {
                dealLongPressAction = YES;
                CGRect rect = [_innerLayout rectForRange:[HTextRange rangeWithRange:_highlightRange]];
                rect = [self _convertRectFromLayout:rect];
                [self.delegate textView:self didLongPressHighlight:_highlight inRange:_highlightRange rect:rect];
                [self _endTouchTracking];
            }
        }
    }
    
    if (!dealLongPressAction){
        [self _removeHighlightAnimated:NO];
        if (_state.trackingTouch) {
            if (_state.trackingGrabber) {
                self.panGestureRecognizer.enabled = NO;
                [self _hideMenu];
                [self _showMagnifierRanged];
            } else if (self.isFirstResponder){
                self.panGestureRecognizer.enabled = NO;
                _selectionView.caretBlinks = NO;
                _state.trackingCaret = YES;
                CGPoint trackingPoint = [self _convertPointToLayout:_trackingPoint];
                HTextPosition *newPos = [_innerLayout closestPositionToPoint:trackingPoint];
                newPos = [self _correctedTextPosition:newPos];
                if (newPos) {
                    if (_markedTextRange) {
                        if ([newPos compare:_markedTextRange.start] != NSOrderedDescending) {
                            newPos = _markedTextRange.start;
                        } else if ([newPos compare:_markedTextRange.end] != NSOrderedAscending) {
                            newPos = _markedTextRange.end;
                        }
                    }
                    _trackingRange = [HTextRange rangeWithRange:NSMakeRange(newPos.offset, 0) affinity:newPos.affinity];
                    [self _updateSelectionView];
                }
                [self _hideMenu];
                
                if (_markedTextRange) {
                    [self _showMagnifierRanged];
                } else {
                    [self _showMagnifierCaret];
                }
            } else if (self.selectable) {
                self.panGestureRecognizer.enabled = NO;
                _state.trackingPreSelect = YES;
                _state.selectedWithoutEdit = NO;
                [self _updateTextRangeByTrackingPreSelect];
                [self _updateSelectionView];
                [self _showMagnifierCaret];
            }
        }
    }
}

/// Start auto scroll timer, used for auto scroll tick.
- (void)_startAutoScrollTimer {
    if (!_autoScrollTimer) {
        [_autoScrollTimer invalidate];
        _autoScrollTimer = [NSTimer timerWithTimeInterval:kAutoScrollMinimumDuration
                                                   target:[HTextWeakProxy proxyWithTarget:self]
                                                 selector:@selector(_trackDidTickAutoScroll)
                                                 userInfo:nil
                                                  repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_autoScrollTimer forMode:NSRunLoopCommonModes];
    }
}

/// Invalidate the auto scroll, and restore the text view state.
- (void)_endAutoScrollTimer {
    if (_state.autoScrollTicked) [self flashScrollIndicators];
    [_autoScrollTimer invalidate];
    _autoScrollTimer = nil;
    _autoScrollOffset = 0;
    _autoScrollAcceleration = 0;
    _state.autoScrollTicked = NO;
    
    if (_magnifierCaret.captureDisabled) {
        _magnifierCaret.captureDisabled = NO;
        if (_state.showingMagnifierCaret) {
            [self _showMagnifierCaret];
        }
    }
    if (_magnifierRanged.captureDisabled) {
        _magnifierRanged.captureDisabled = NO;
        if (_state.showingMagnifierRanged) {
            [self _showMagnifierRanged];
        }
    }
}

/// Auto scroll ticked by timer.
- (void)_trackDidTickAutoScroll {
    if (_autoScrollOffset != 0) {
        _magnifierCaret.captureDisabled = YES;
        _magnifierRanged.captureDisabled = YES;
        
        CGPoint offset = self.contentOffset;
        if (_verticalForm) {
            offset.x += _autoScrollOffset;
            
            if (_autoScrollAcceleration > 0) {
                offset.x += ((_autoScrollOffset > 0 ? 1 : -1) * _autoScrollAcceleration * _autoScrollAcceleration * 0.5);
            }
            _autoScrollAcceleration++;
            offset.x = round(offset.x);
            if (_autoScrollOffset < 0) {
                if (offset.x < -self.contentInset.left) offset.x = -self.contentInset.left;
            } else {
                CGFloat maxOffsetX = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
                if (offset.x > maxOffsetX) offset.x = maxOffsetX;
            }
            if (offset.x < -self.contentInset.left) offset.x = -self.contentInset.left;
        } else {
            offset.y += _autoScrollOffset;
            if (_autoScrollAcceleration > 0) {
                offset.y += ((_autoScrollOffset > 0 ? 1 : -1) * _autoScrollAcceleration * _autoScrollAcceleration * 0.5);
            }
            _autoScrollAcceleration++;
            offset.y = round(offset.y);
            if (_autoScrollOffset < 0) {
                if (offset.y < -self.contentInset.top) offset.y = -self.contentInset.top;
            } else {
                CGFloat maxOffsetY = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
                if (offset.y > maxOffsetY) offset.y = maxOffsetY;
            }
            if (offset.y < -self.contentInset.top) offset.y = -self.contentInset.top;
        }
        
        BOOL shouldScroll;
        if (_verticalForm) {
            shouldScroll = fabs(offset.x -self.contentOffset.x) > 0.5;
        } else {
            shouldScroll = fabs(offset.y -self.contentOffset.y) > 0.5;
        }
        
        if (shouldScroll) {
            _state.autoScrollTicked = YES;
            _trackingPoint.x += offset.x - self.contentOffset.x;
            _trackingPoint.y += offset.y - self.contentOffset.y;
            [UIView animateWithDuration:kAutoScrollMinimumDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                [self setContentOffset:offset];
            } completion:^(BOOL finished) {
                if (self->_state.trackingTouch) {
                    if (self->_state.trackingGrabber) {
                        [self _showMagnifierRanged];
                        [self _updateTextRangeByTrackingGrabber];
                    } else if (self->_state.trackingPreSelect) {
                        [self _showMagnifierCaret];
                        [self _updateTextRangeByTrackingPreSelect];
                    } else if (self->_state.trackingCaret) {
                        if (self->_markedTextRange) {
                            [self _showMagnifierRanged];
                        } else {
                            [self _showMagnifierCaret];
                        }
                        [self _updateTextRangeByTrackingCaret];
                    }
                    [self _updateSelectionView];
                }
            }];
        } else {
            [self _endAutoScrollTimer];
        }
    } else {
        [self _endAutoScrollTimer];
    }
}

/// End current touch tracking (if is tracking now), and update the state.
- (void)_endTouchTracking {
    if (!_state.trackingTouch) return;
    
    _state.trackingTouch = NO;
    _state.trackingGrabber = NO;
    _state.trackingCaret = NO;
    _state.trackingPreSelect = NO;
    _state.touchMoved = NO;
    _state.deleteConfirm = NO;
    _state.clearsOnInsertionOnce = NO;
    _trackingRange = nil;
    _selectionView.caretBlinks = YES;
    
    [self _removeHighlightAnimated:YES];
    [self _hideMagnifier];
    [self _endLongPressTimer];
    [self _endAutoScrollTimer];
    [self _updateSelectionView];
    
    self.panGestureRecognizer.enabled = self.scrollEnabled;
}

/// Start a timer to fix the selection dot.
- (void)_startSelectionDotFixTimer {
    [_selectionDotFixTimer invalidate];
    _longPressTimer = [NSTimer timerWithTimeInterval:1/15.0
                                              target:[HTextWeakProxy proxyWithTarget:self]
                                            selector:@selector(_fixSelectionDot)
                                            userInfo:nil
                                             repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_longPressTimer forMode:NSRunLoopCommonModes];
}

/// End the timer.
- (void)_endSelectionDotFixTimer {
    [_selectionDotFixTimer invalidate];
    _selectionDotFixTimer = nil;
}

/// If it shows selection grabber and this view was moved by super view,
/// update the selection dot in window.
- (void)_fixSelectionDot {
    if (HTextIsAppExtension()) return;
    CGPoint origin = [self h_convertPoint:CGPointZero toViewOrWindow:[HTextEffectWindow sharedWindow]];
    if (!CGPointEqualToPoint(origin, _previousOriginInWindow)) {
        _previousOriginInWindow = origin;
        [[HTextEffectWindow sharedWindow] hideSelectionDot:_selectionView];
        [[HTextEffectWindow sharedWindow] showSelectionDot:_selectionView];
    }
}

/// Try to get the character range/position with word granularity from the tokenizer.
- (HTextRange *)_getClosestTokenRangeAtPosition:(HTextPosition *)position {
    position = [self _correctedTextPosition:position];
    if (!position) return nil;
    HTextRange *range = nil;
    if (_tokenizer) {
        range = (id)[_tokenizer rangeEnclosingPosition:position withGranularity:UITextGranularityWord inDirection:UITextStorageDirectionForward];
        if (range.asRange.length == 0) {
            range = (id)[_tokenizer rangeEnclosingPosition:position withGranularity:UITextGranularityWord inDirection:UITextStorageDirectionBackward];
        }
    }
    
    if (!range || range.asRange.length == 0) {
        range = [_innerLayout textRangeByExtendingPosition:position inDirection:UITextLayoutDirectionRight offset:1];
        range = [self _correctedTextRange:range];
        if (range.asRange.length == 0) {
            range = [_innerLayout textRangeByExtendingPosition:position inDirection:UITextLayoutDirectionLeft offset:1];
            range = [self _correctedTextRange:range];
        }
    } else {
        HTextRange *extStart = [_innerLayout textRangeByExtendingPosition:range.start];
        HTextRange *extEnd = [_innerLayout textRangeByExtendingPosition:range.end];
        if (extStart && extEnd) {
            NSArray *arr = [@[extStart.start, extStart.end, extEnd.start, extEnd.end] sortedArrayUsingSelector:@selector(compare:)];
            range = [HTextRange rangeWithStart:arr.firstObject end:arr.lastObject];
        }
    }
    
    range = [self _correctedTextRange:range];
    if (range.asRange.length == 0) {
        range = [HTextRange rangeWithRange:NSMakeRange(0, _innerText.length)];
    }
    
    return [self _correctedTextRange:range];
}

/// Try to get the character range/position with word granularity from the tokenizer.
- (HTextRange *)_getClosestTokenRangeAtPoint:(CGPoint)point {
    point = [self _convertPointToLayout:point];
    HTextRange *touchRange = [_innerLayout closestTextRangeAtPoint:point];
    touchRange = [self _correctedTextRange:touchRange];
    
    if (_tokenizer && touchRange) {
        HTextRange *encEnd = (id)[_tokenizer rangeEnclosingPosition:touchRange.end withGranularity:UITextGranularityWord inDirection:UITextStorageDirectionBackward];
        HTextRange *encStart = (id)[_tokenizer rangeEnclosingPosition:touchRange.start withGranularity:UITextGranularityWord inDirection:UITextStorageDirectionForward];
        if (encEnd && encStart) {
            NSArray *arr = [@[encEnd.start, encEnd.end, encStart.start, encStart.end] sortedArrayUsingSelector:@selector(compare:)];
            touchRange = [HTextRange rangeWithStart:arr.firstObject end:arr.lastObject];
        }
    }
    
    if (touchRange) {
        HTextRange *extStart = [_innerLayout textRangeByExtendingPosition:touchRange.start];
        HTextRange *extEnd = [_innerLayout textRangeByExtendingPosition:touchRange.end];
        if (extStart && extEnd) {
            NSArray *arr = [@[extStart.start, extStart.end, extEnd.start, extEnd.end] sortedArrayUsingSelector:@selector(compare:)];
            touchRange = [HTextRange rangeWithStart:arr.firstObject end:arr.lastObject];
        }
    }
    
    if (!touchRange) touchRange = [HTextRange defaultRange];
    
    if (_innerText.length && touchRange.asRange.length == 0) {
        touchRange = [HTextRange rangeWithRange:NSMakeRange(0, _innerText.length)];
    }
    
    return touchRange;
}

/// Try to get the highlight property. If exist, the range will be returnd by the range pointer.
/// If the delegate ignore the highlight, returns nil.
- (HTextHighlight *)_getHighlightAtPoint:(CGPoint)point range:(NSRangePointer)range {
    if (!_highlightable || !_innerLayout.containsHighlight) return nil;
    point = [self _convertPointToLayout:point];
    HTextRange *textRange = [_innerLayout textRangeAtPoint:point];
    textRange = [self _correctedTextRange:textRange];
    if (!textRange) return nil;
    NSUInteger startIndex = textRange.start.offset;
    if (startIndex == _innerText.length) {
        if (startIndex == 0) return nil;
        else startIndex--;
    }
    NSRange highlightRange = {0};
    NSAttributedString *text = _delectedText ? _delectedText : _innerText;
    HTextHighlight *highlight = [text attribute:HTextHighlightAttributeName
                                         atIndex:startIndex
                           longestEffectiveRange:&highlightRange
                                         inRange:NSMakeRange(0, _innerText.length)];
    
    if (!highlight) return nil;
    
    BOOL shouldTap = YES, shouldLongPress = YES;
    if (!highlight.tapAction && !highlight.longPressAction) {
        if ([self.delegate respondsToSelector:@selector(textView:shouldTapHighlight:inRange:)]) {
            shouldTap = [self.delegate textView:self shouldTapHighlight:highlight inRange:highlightRange];
        }
        if ([self.delegate respondsToSelector:@selector(textView:shouldLongPressHighlight:inRange:)]) {
            shouldLongPress = [self.delegate textView:self shouldLongPressHighlight:highlight inRange:highlightRange];
        }
    }
    if (!shouldTap && !shouldLongPress) return nil;
    if (range) *range = highlightRange;
    return highlight;
}

/// Return the ranged magnifier popover offset from the baseline, base on `_trackingPoint`.
- (CGFloat)_getMagnifierRangedOffset {
    CGPoint magPoint = _trackingPoint;
    magPoint = [self _convertPointToLayout:magPoint];
    if (_verticalForm) {
        magPoint.x += kMagnifierRangedTrackFix;
    } else {
        magPoint.y += kMagnifierRangedTrackFix;
    }
    HTextPosition *position = [_innerLayout closestPositionToPoint:magPoint];
    NSUInteger lineIndex = [_innerLayout lineIndexForPosition:position];
    if (lineIndex < _innerLayout.lines.count) {
        HTextLine *line = _innerLayout.lines[lineIndex];
        if (_verticalForm) {
            magPoint.x = HTEXT_CLAMP(magPoint.x, line.left, line.right);
            return magPoint.x - line.position.x + kMagnifierRangedPopoverOffset;
        } else {
            magPoint.y = HTEXT_CLAMP(magPoint.y, line.top, line.bottom);
            return magPoint.y - line.position.y + kMagnifierRangedPopoverOffset;
        }
    } else {
        return 0;
    }
}

/// Return a HTextMoveDirection from `_touchBeganPoint` to `_trackingPoint`.
- (unsigned int)_getMoveDirection {
    CGFloat moveH = _trackingPoint.x - _touchBeganPoint.x;
    CGFloat moveV = _trackingPoint.y - _touchBeganPoint.y;
    if (fabs(moveH) > fabs(moveV)) {
        if (fabs(moveH) > kLongPressAllowableMovement) {
            return moveH > 0 ? kRight : kLeft;
        }
    } else {
        if (fabs(moveV) > kLongPressAllowableMovement) {
            return moveV > 0 ? kBottom : kTop;
        }
    }
    return 0;
}

/// Get the auto scroll offset in one tick time.
- (CGFloat)_getAutoscrollOffset {
    if (!_state.trackingTouch) return 0;
    
    CGRect bounds = self.bounds;
    bounds.origin = CGPointZero;
    HTextKeyboardManager *mgr = [HTextKeyboardManager defaultManager];
    if (mgr.keyboardVisible && self.window && self.superview && self.isFirstResponder && !_verticalForm) {
        CGRect kbRect = [mgr convertRect:mgr.keyboardFrame toView:self];
        kbRect.origin.y -= _extraAccessoryViewHeight;
        kbRect.size.height += _extraAccessoryViewHeight;
        
        kbRect.origin.x -= self.contentOffset.x;
        kbRect.origin.y -= self.contentOffset.y;
        CGRect inter = CGRectIntersection(bounds, kbRect);
        if (!CGRectIsNull(inter) && inter.size.height > 1 && inter.size.width > 1) {
            if (CGRectGetMinY(inter) > CGRectGetMinY(bounds)) {
                bounds.size.height -= inter.size.height;
            }
        }
    }
    
    CGPoint point = _trackingPoint;
    point.x -= self.contentOffset.x;
    point.y -= self.contentOffset.y;
    
    CGFloat maxOfs = 32; // a good value ~
    CGFloat ofs = 0;
    if (_verticalForm) {
        if (point.x < self.contentInset.left) {
            ofs = (point.x - self.contentInset.left - 5) * 0.5;
            if (ofs < -maxOfs) ofs = -maxOfs;
        } else if (point.x > bounds.size.width) {
            ofs = ((point.x - bounds.size.width) + 5) * 0.5;
            if (ofs > maxOfs) ofs = maxOfs;
        }
    } else {
        if (point.y < self.contentInset.top) {
            ofs = (point.y - self.contentInset.top - 5) * 0.5;
            if (ofs < -maxOfs) ofs = -maxOfs;
        } else if (point.y > bounds.size.height) {
            ofs = ((point.y - bounds.size.height) + 5) * 0.5;
            if (ofs > maxOfs) ofs = maxOfs;
        }
    }
    return ofs;
}

/// Visible size based on bounds and insets
- (CGSize)_getVisibleSize {
    CGSize visibleSize = self.bounds.size;
    visibleSize.width -= self.contentInset.left - self.contentInset.right;
    visibleSize.height -= self.contentInset.top - self.contentInset.bottom;
    if (visibleSize.width < 0) visibleSize.width = 0;
    if (visibleSize.height < 0) visibleSize.height = 0;
    return visibleSize;
}

/// Returns whether the text view can paste data from pastboard.
- (BOOL)_isPasteboardContainsValidValue {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (pasteboard.string.length > 0) {
        return YES;
    }
    if (pasteboard.h_AttributedString.length > 0) {
        if (_allowsPasteAttributedString) {
            return YES;
        }
    }
    if (pasteboard.image || pasteboard.h_ImageData.length > 0) {
        if (_allowsPasteImage) {
            return YES;
        }
    }
    return NO;
}

/// Save current selected attributed text to pasteboard.
- (void)_copySelectedTextToPasteboard {
    if (_allowsCopyAttributedString) {
        NSAttributedString *text = [_innerText attributedSubstringFromRange:_selectedTextRange.asRange];
        if (text.length) {
            [UIPasteboard generalPasteboard].h_AttributedString = text;
        }
    } else {
        NSString *string = [_innerText h_plainTextForRange:_selectedTextRange.asRange];
        if (string.length) {
            [UIPasteboard generalPasteboard].string = string;
        }
    }
}

/// Update the text view state when pasteboard changed.
- (void)_pasteboardChanged {
    if (_state.showingMenu) {
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu update];
    }
}

/// Whether the position is valid (not out of bounds).
- (BOOL)_isTextPositionValid:(HTextPosition *)position {
    if (!position) return NO;
    if (position.offset < 0) return NO;
    if (position.offset > _innerText.length) return NO;
    if (position.offset == 0 && position.affinity == HTextAffinityBackward) return NO;
    if (position.offset == _innerText.length && position.affinity == HTextAffinityBackward) return NO;
    return YES;
}

/// Whether the range is valid (not out of bounds).
- (BOOL)_isTextRangeValid:(HTextRange *)range {
    if (![self _isTextPositionValid:range.start]) return NO;
    if (![self _isTextPositionValid:range.end]) return NO;
    return YES;
}

/// Correct the position if it out of bounds.
- (HTextPosition *)_correctedTextPosition:(HTextPosition *)position {
    if (!position) return nil;
    if ([self _isTextPositionValid:position]) return position;
    if (position.offset < 0) {
        return [HTextPosition positionWithOffset:0];
    }
    if (position.offset > _innerText.length) {
        return [HTextPosition positionWithOffset:_innerText.length];
    }
    if (position.offset == 0 && position.affinity == HTextAffinityBackward) {
        return [HTextPosition positionWithOffset:position.offset];
    }
    if (position.offset == _innerText.length && position.affinity == HTextAffinityBackward) {
        return [HTextPosition positionWithOffset:position.offset];
    }
    return position;
}

/// Correct the range if it out of bounds.
- (HTextRange *)_correctedTextRange:(HTextRange *)range {
    if (!range) return nil;
    if ([self _isTextRangeValid:range]) return range;
    HTextPosition *start = [self _correctedTextPosition:range.start];
    HTextPosition *end = [self _correctedTextPosition:range.end];
    return [HTextRange rangeWithStart:start end:end];
}

/// Convert the point from this view to text layout.
- (CGPoint)_convertPointToLayout:(CGPoint)point {
    CGSize boundingSize = _innerLayout.textBoundingSize;
    if (_innerLayout.container.isVerticalForm) {
        CGFloat w = _innerLayout.textBoundingSize.width;
        if (w < self.bounds.size.width) w = self.bounds.size.width;
        point.x += _innerLayout.container.size.width - w;
        if (boundingSize.width < self.bounds.size.width) {
            if (_textVerticalAlignment == HTextVerticalAlignmentCenter) {
                point.x += (self.bounds.size.width - boundingSize.width) * 0.5;
            } else if (_textVerticalAlignment == HTextVerticalAlignmentBottom) {
                point.x += (self.bounds.size.width - boundingSize.width);
            }
        }
        return point;
    } else {
        if (boundingSize.height < self.bounds.size.height) {
            if (_textVerticalAlignment == HTextVerticalAlignmentCenter) {
                point.y -= (self.bounds.size.height - boundingSize.height) * 0.5;
            } else if (_textVerticalAlignment == HTextVerticalAlignmentBottom) {
                point.y -= (self.bounds.size.height - boundingSize.height);
            }
        }
        return point;
    }
}

/// Convert the point from text layout to this view.
- (CGPoint)_convertPointFromLayout:(CGPoint)point {
    CGSize boundingSize = _innerLayout.textBoundingSize;
    if (_innerLayout.container.isVerticalForm) {
        CGFloat w = _innerLayout.textBoundingSize.width;
        if (w < self.bounds.size.width) w = self.bounds.size.width;
        point.x -= _innerLayout.container.size.width - w;
        if (boundingSize.width < self.bounds.size.width) {
            if (_textVerticalAlignment == HTextVerticalAlignmentCenter) {
                point.x -= (self.bounds.size.width - boundingSize.width) * 0.5;
            } else if (_textVerticalAlignment == HTextVerticalAlignmentBottom) {
                point.x -= (self.bounds.size.width - boundingSize.width);
            }
        }
        return point;
    } else {
        if (boundingSize.height < self.bounds.size.height) {
            if (_textVerticalAlignment == HTextVerticalAlignmentCenter) {
                point.y += (self.bounds.size.height - boundingSize.height) * 0.5;
            } else if (_textVerticalAlignment == HTextVerticalAlignmentBottom) {
                point.y += (self.bounds.size.height - boundingSize.height);
            }
        }
        return point;
    }
}

/// Convert the rect from this view to text layout.
- (CGRect)_convertRectToLayout:(CGRect)rect {
    rect.origin = [self _convertPointToLayout:rect.origin];
    return rect;
}

/// Convert the rect from text layout to this view.
- (CGRect)_convertRectFromLayout:(CGRect)rect {
    rect.origin = [self _convertPointFromLayout:rect.origin];
    return rect;
}

/// Replace the range with the text, and change the `_selectTextRange`.
/// The caller should make sure the `range` and `text` are valid before call this method.
- (void)_replaceRange:(HTextRange *)range withText:(NSString *)text notifyToDelegate:(BOOL)notify{
    if (NSEqualRanges(range.asRange, _selectedTextRange.asRange)) {
        if (notify) [_inputDelegate selectionWillChange:self];
        NSRange newRange = NSMakeRange(0, 0);
        newRange.location = _selectedTextRange.start.offset + text.length;
        _selectedTextRange = [HTextRange rangeWithRange:newRange];
        if (notify) [_inputDelegate selectionDidChange:self];
    } else {
        if (range.asRange.length != text.length) {
            if (notify) [_inputDelegate selectionWillChange:self];
            NSRange unionRange = NSIntersectionRange(_selectedTextRange.asRange, range.asRange);
            if (unionRange.length == 0) {
                // no intersection
                if (range.end.offset <= _selectedTextRange.start.offset) {
                    NSInteger ofs = (NSInteger)text.length - (NSInteger)range.asRange.length;
                    NSRange newRange = _selectedTextRange.asRange;
                    newRange.location += ofs;
                    _selectedTextRange = [HTextRange rangeWithRange:newRange];
                }
            } else if (unionRange.length == _selectedTextRange.asRange.length) {
                // target range contains selected range
                _selectedTextRange = [HTextRange rangeWithRange:NSMakeRange(range.start.offset + text.length, 0)];
            } else if (range.start.offset >= _selectedTextRange.start.offset &&
                       range.end.offset <= _selectedTextRange.end.offset) {
                // target range inside selected range
                NSInteger ofs = (NSInteger)text.length - (NSInteger)range.asRange.length;
                NSRange newRange = _selectedTextRange.asRange;
                newRange.length += ofs;
                _selectedTextRange = [HTextRange rangeWithRange:newRange];
            } else {
                // interleaving
                if (range.start.offset < _selectedTextRange.start.offset) {
                    NSRange newRange = _selectedTextRange.asRange;
                    newRange.location = range.start.offset + text.length;
                    newRange.length -= unionRange.length;
                    _selectedTextRange = [HTextRange rangeWithRange:newRange];
                } else {
                    NSRange newRange = _selectedTextRange.asRange;
                    newRange.length -= unionRange.length;
                    _selectedTextRange = [HTextRange rangeWithRange:newRange];
                }
            }
            _selectedTextRange = [self _correctedTextRange:_selectedTextRange];
            if (notify) [_inputDelegate selectionDidChange:self];
        }
    }
    if (notify) [_inputDelegate textWillChange:self];
    NSRange newRange = NSMakeRange(range.asRange.location, text.length);
    [_innerText replaceCharactersInRange:range.asRange withString:text];
    [_innerText h_removeDiscontinuousAttributesInRange:newRange];
    if (notify) [_inputDelegate textDidChange:self];
}

/// Save current typing attributes to the attributes holder.
- (void)_updateAttributesHolder {
    if (_innerText.length > 0) {
        NSUInteger index = _selectedTextRange.end.offset == 0 ? 0 : _selectedTextRange.end.offset - 1;
        NSDictionary *attributes = [_innerText h_attributesAtIndex:index];
        if (!attributes) attributes = @{};
        _typingAttributesHolder.h_attributes = attributes;
        [_typingAttributesHolder h_removeDiscontinuousAttributesInRange:NSMakeRange(0, _typingAttributesHolder.length)];
        [_typingAttributesHolder removeAttribute:HTextBorderAttributeName range:NSMakeRange(0, _typingAttributesHolder.length)];
        [_typingAttributesHolder removeAttribute:HTextBackgroundBorderAttributeName range:NSMakeRange(0, _typingAttributesHolder.length)];
    }
}

/// Update outer properties from current inner data.
- (void)_updateOuterProperties {
    [self _updateAttributesHolder];
    NSParagraphStyle *style = _innerText.h_paragraphStyle;
    if (!style) style = _typingAttributesHolder.h_paragraphStyle;
    if (!style) style = [NSParagraphStyle defaultParagraphStyle];
    
    UIFont *font = _innerText.h_font;
    if (!font) font = _typingAttributesHolder.h_font;
    if (!font) font = [self _defaultFont];
    
    UIColor *color = _innerText.h_color;
    if (!color) color = _typingAttributesHolder.h_color;
    if (!color) color = [UIColor blackColor];
    
    [self _setText:[_innerText h_plainTextForRange:NSMakeRange(0, _innerText.length)]];
    [self _setFont:font];
    [self _setTextColor:color];
    [self _setTextAlignment:style.alignment];
    [self _setSelectedRange:_selectedTextRange.asRange];
    [self _setTypingAttributes:_typingAttributesHolder.h_attributes];
    [self _setAttributedText:_innerText];
}

/// Parse text with `textParser` and update the _selectedTextRange.
/// @return Whether changed (text or selection)
- (BOOL)_parseText {
    if (self.textParser) {
        HTextRange *oldTextRange = _selectedTextRange;
        NSRange newRange = _selectedTextRange.asRange;
        
        [_inputDelegate textWillChange:self];
        BOOL textChanged = [self.textParser parseText:_innerText selectedRange:&newRange];
        [_inputDelegate textDidChange:self];
        
        HTextRange *newTextRange = [HTextRange rangeWithRange:newRange];
        newTextRange = [self _correctedTextRange:newTextRange];
        
        if (![oldTextRange isEqual:newTextRange]) {
            [_inputDelegate selectionWillChange:self];
            _selectedTextRange = newTextRange;
            [_inputDelegate selectionDidChange:self];
        }
        return textChanged;
    }
    return NO;
}

/// Returns whether the text should be detected by the data detector.
- (BOOL)_shouldDetectText {
    if (!_dataDetector) return NO;
    if (!_highlightable) return NO;
    if (_linkTextAttributes.count == 0 && _highlightTextAttributes.count == 0) return NO;
    if (self.isFirstResponder || _containerView.isFirstResponder) return NO;
    return YES;
}

/// Detect the data in text and add highlight to the data range.
/// @return Whether detected.
- (BOOL)_detectText:(NSMutableAttributedString *)text {
    if (![self _shouldDetectText]) return NO;
    if (text.length == 0) return NO;
    __block BOOL detected = NO;
    [_dataDetector enumerateMatchesInString:text.string options:kNilOptions range:NSMakeRange(0, text.length) usingBlock: ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        switch (result.resultType) {
            case NSTextCheckingTypeDate:
            case NSTextCheckingTypeAddress:
            case NSTextCheckingTypeLink:
            case NSTextCheckingTypePhoneNumber: {
                detected = YES;
                if (self->_highlightTextAttributes.count) {
                    HTextHighlight *highlight = [HTextHighlight highlightWithAttributes:self->_highlightTextAttributes];
                    [text h_setTextHighlight:highlight range:result.range];
                }
                if (self->_linkTextAttributes.count) {
                    [self->_linkTextAttributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                        [text h_setAttribute:key value:obj range:result.range];
                    }];
                }
            } break;
            default:
                break;
        }
    }];
    return detected;
}

/// Returns the `root` view controller (returns nil if not found).
- (UIViewController *)_getRootViewController {
    UIViewController *ctrl = nil;
    UIApplication *app = HTextSharedApplication();
    if (!ctrl) ctrl = app.keyWindow.rootViewController;
    if (!ctrl) ctrl = [app.windows.firstObject rootViewController];
    if (!ctrl) ctrl = self.h_viewController;
    if (!ctrl) return nil;
    
    while (!ctrl.view.window && ctrl.presentedViewController) {
        ctrl = ctrl.presentedViewController;
    }
    if (!ctrl.view.window) return nil;
    return ctrl;
}

/// Clear the undo and redo stack, and capture current state to undo stack.
- (void)_resetUndoAndRedoStack {
    [_undoStack removeAllObjects];
    [_redoStack removeAllObjects];
    _HTextViewUndoObject *object = [_HTextViewUndoObject objectWithText:_innerText.copy range:_selectedTextRange.asRange];
    _lastTypeRange = _selectedTextRange.asRange;
    [_undoStack addObject:object];
}

/// Clear the redo stack.
- (void)_resetRedoStack {
    [_redoStack removeAllObjects];
}

/// Capture current state to undo stack.
- (void)_saveToUndoStack {
    if (!_allowsUndoAndRedo) return;
    _HTextViewUndoObject *lastObject = _undoStack.lastObject;
    if ([lastObject.text isEqualToAttributedString:self.attributedText]) return;
    
    _HTextViewUndoObject *object = [_HTextViewUndoObject objectWithText:_innerText.copy range:_selectedTextRange.asRange];
    _lastTypeRange = _selectedTextRange.asRange;
    [_undoStack addObject:object];
    while (_undoStack.count > _maximumUndoLevel) {
        [_undoStack removeObjectAtIndex:0];
    }
}

/// Capture current state to redo stack.
- (void)_saveToRedoStack {
    if (!_allowsUndoAndRedo) return;
    _HTextViewUndoObject *lastObject = _redoStack.lastObject;
    if ([lastObject.text isEqualToAttributedString:self.attributedText]) return;
    
    _HTextViewUndoObject *object = [_HTextViewUndoObject objectWithText:_innerText.copy range:_selectedTextRange.asRange];
    [_redoStack addObject:object];
    while (_redoStack.count > _maximumUndoLevel) {
        [_redoStack removeObjectAtIndex:0];
    }
}

- (BOOL)_canUndo {
    if (_undoStack.count == 0) return NO;
    _HTextViewUndoObject *object = _undoStack.lastObject;
    if ([object.text isEqualToAttributedString:_innerText]) return NO;
    return YES;
}

- (BOOL)_canRedo {
    if (_redoStack.count == 0) return NO;
    _HTextViewUndoObject *object = _undoStack.lastObject;
    if ([object.text isEqualToAttributedString:_innerText]) return NO;
    return YES;
}

- (void)_undo {
    if (![self _canUndo]) return;
    [self _saveToRedoStack];
    _HTextViewUndoObject *object = _undoStack.lastObject;
    [_undoStack removeLastObject];
    
    _state.insideUndoBlock = YES;
    self.attributedText = object.text;
    self.selectedRange = object.selectedRange;
    _state.insideUndoBlock = NO;
}

- (void)_redo {
    if (![self _canRedo]) return;
    [self _saveToUndoStack];
    _HTextViewUndoObject *object = _redoStack.lastObject;
    [_redoStack removeLastObject];
    
    _state.insideUndoBlock = YES;
    self.attributedText = object.text;
    self.selectedRange = object.selectedRange;
    _state.insideUndoBlock = NO;
}

- (void)_restoreFirstResponderAfterUndoAlert {
    if (_state.firstResponderBeforeUndoAlert) {
        [self performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
    }
}

/// Show undo alert if it can undo or redo.
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
- (void)_showUndoRedoAlert NS_EXTENSION_UNAVAILABLE_IOS(""){
    _state.firstResponderBeforeUndoAlert = self.isFirstResponder;
    __weak typeof(self) _self = self;
    NSArray *strings = [self _localizedUndoStrings];
    BOOL canUndo = [self _canUndo];
    BOOL canRedo = [self _canRedo];
    
    UIViewController *ctrl = [self _getRootViewController];
    
    if (canUndo && canRedo) {
        if (kiOS8Later) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:strings[4] message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:strings[3] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [_self _undo];
                [_self _restoreFirstResponderAfterUndoAlert];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:strings[2] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [_self _redo];
                [_self _restoreFirstResponderAfterUndoAlert];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:strings[0] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [_self _restoreFirstResponderAfterUndoAlert];
            }]];
            [ctrl presentViewController:alert animated:YES completion:nil];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strings[4] message:@"" delegate:self cancelButtonTitle:strings[0] otherButtonTitles:strings[3], strings[2], nil];
            [alert show];
#pragma clang diagnostic pop
        }
    } else if (canUndo) {
        if (kiOS8Later) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:strings[4] message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:strings[3] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [_self _undo];
                [_self _restoreFirstResponderAfterUndoAlert];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:strings[0] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [_self _restoreFirstResponderAfterUndoAlert];
            }]];
            [ctrl presentViewController:alert animated:YES completion:nil];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strings[4] message:@"" delegate:self cancelButtonTitle:strings[0] otherButtonTitles:strings[3], nil];
            [alert show];
#pragma clang diagnostic pop
        }
    } else if (canRedo) {
        if (kiOS8Later) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:strings[2] message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:strings[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [_self _redo];
                [_self _restoreFirstResponderAfterUndoAlert];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:strings[0] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [_self _restoreFirstResponderAfterUndoAlert];
            }]];
            [ctrl presentViewController:alert animated:YES completion:nil];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strings[2] message:@"" delegate:self cancelButtonTitle:strings[0] otherButtonTitles:strings[1], nil];
            [alert show];
#pragma clang diagnostic pop
        }
    }
}
#endif

/// Get the localized undo alert strings based on app's main bundle.
- (NSArray *)_localizedUndoStrings {
    static NSArray *strings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *dic = @{
            @"ar" : @[ @"إلغاء", @"إعادة", @"إعادة الكتابة", @"تراجع", @"تراجع عن الكتابة" ],
            @"ca" : @[ @"Cancel·lar", @"Refer", @"Refer l’escriptura", @"Desfer", @"Desfer l’escriptura" ],
            @"cs" : @[ @"Zrušit", @"Opakovat akci", @"Opakovat akci Psát", @"Odvolat akci", @"Odvolat akci Psát" ],
            @"da" : @[ @"Annuller", @"Gentag", @"Gentag Indtastning", @"Fortryd", @"Fortryd Indtastning" ],
            @"de" : @[ @"Abbrechen", @"Wiederholen", @"Eingabe wiederholen", @"Widerrufen", @"Eingabe widerrufen" ],
            @"el" : @[ @"Ακύρωση", @"Επανάληψη", @"Επανάληψη πληκτρολόγησης", @"Αναίρεση", @"Αναίρεση πληκτρολόγησης" ],
            @"en" : @[ @"Cancel", @"Redo", @"Redo Typing", @"Undo", @"Undo Typing" ],
            @"es" : @[ @"Cancelar", @"Rehacer", @"Rehacer escritura", @"Deshacer", @"Deshacer escritura" ],
            @"es_MX" : @[ @"Cancelar", @"Rehacer", @"Rehacer escritura", @"Deshacer", @"Deshacer escritura" ],
            @"fi" : @[ @"Kumoa", @"Tee sittenkin", @"Kirjoita sittenkin", @"Peru", @"Peru kirjoitus" ],
            @"fr" : @[ @"Annuler", @"Rétablir", @"Rétablir la saisie", @"Annuler", @"Annuler la saisie" ],
            @"he" : @[ @"ביטול", @"חזור על הפעולה האחרונה", @"חזור על הקלדה", @"בטל", @"בטל הקלדה" ],
            @"hr" : @[ @"Odustani", @"Ponovi", @"Ponovno upiši", @"Poništi", @"Poništi upisivanje" ],
            @"hu" : @[ @"Mégsem", @"Ismétlés", @"Gépelés ismétlése", @"Visszavonás", @"Gépelés visszavonása" ],
            @"id" : @[ @"Batalkan", @"Ulang", @"Ulang Pengetikan", @"Kembalikan", @"Batalkan Pengetikan" ],
            @"it" : @[ @"Annulla", @"Ripristina originale", @"Ripristina Inserimento", @"Annulla", @"Annulla Inserimento" ],
            @"ja" : @[ @"キャンセル", @"やり直す", @"やり直す - 入力", @"取り消す", @"取り消す - 入力" ],
            @"ko" : @[ @"취소", @"실행 복귀", @"입력 복귀", @"실행 취소", @"입력 실행 취소" ],
            @"ms" : @[ @"Batal", @"Buat semula", @"Ulang Penaipan", @"Buat asal", @"Buat asal Penaipan" ],
            @"nb" : @[ @"Avbryt", @"Utfør likevel", @"Utfør skriving likevel", @"Angre", @"Angre skriving" ],
            @"nl" : @[ @"Annuleer", @"Opnieuw", @"Opnieuw typen", @"Herstel", @"Herstel typen" ],
            @"pl" : @[ @"Anuluj", @"Przywróć", @"Przywróć Wpisz", @"Cofnij", @"Cofnij Wpisz" ],
            @"pt" : @[ @"Cancelar", @"Refazer", @"Refazer Digitação", @"Desfazer", @"Desfazer Digitação" ],
            @"pt_PT" : @[ @"Cancelar", @"Refazer", @"Refazer digitar", @"Desfazer", @"Desfazer digitar" ],
            @"ro" : @[ @"Renunță", @"Refă", @"Refă tastare", @"Anulează", @"Anulează tastare" ],
            @"ru" : @[ @"Отменить", @"Повторить", @"Повторить набор на клавиатуре", @"Отменить", @"Отменить набор на клавиатуре" ],
            @"sk" : @[ @"Zrušiť", @"Obnoviť", @"Obnoviť písanie", @"Odvolať", @"Odvolať písanie" ],
            @"sv" : @[ @"Avbryt", @"Gör om", @"Gör om skriven text", @"Ångra", @"Ångra skriven text" ],
            @"th" : @[ @"ยกเลิก", @"ทำกลับมาใหม่", @"ป้อนกลับมาใหม่", @"เลิกทำ", @"เลิกป้อน" ],
            @"tr" : @[ @"Vazgeç", @"Yinele", @"Yazmayı Yinele", @"Geri Al", @"Yazmayı Geri Al" ],
            @"uk" : @[ @"Скасувати", @"Повторити", @"Повторити введення", @"Відмінити", @"Відмінити введення" ],
            @"vi" : @[ @"Hủy", @"Làm lại", @"Làm lại thao tác Nhập", @"Hoàn tác", @"Hoàn tác thao tác Nhập" ],
            @"zh" : @[ @"取消", @"重做", @"重做键入", @"撤销", @"撤销键入" ],
            @"zh_CN" : @[ @"取消", @"重做", @"重做键入", @"撤销", @"撤销键入" ],
            @"zh_HK" : @[ @"取消", @"重做", @"重做輸入", @"還原", @"還原輸入" ],
            @"zh_TW" : @[ @"取消", @"重做", @"重做輸入", @"還原", @"還原輸入" ]
        };
        NSString *preferred = [[NSBundle mainBundle] preferredLocalizations].firstObject;
        if (preferred.length == 0) preferred = @"English";
        NSString *canonical = [NSLocale canonicalLocaleIdentifierFromString:preferred];
        if (canonical.length == 0) canonical = @"en";
        strings = dic[canonical];
        if (!strings  && ([canonical rangeOfString:@"_"].location != NSNotFound)) {
            NSString *prefix = [canonical componentsSeparatedByString:@"_"].firstObject;
            if (prefix.length) strings = dic[prefix];
        }
        if (!strings) strings = dic[@"en"];
    });
    return strings;
}

/// Returns the default font for text view (same as CoreText).
- (UIFont *)_defaultFont {
    return [UIFont systemFontOfSize:12];
}

/// Returns the default tint color for text view (used for caret and select range background).
- (UIColor *)_defaultTintColor {
    return [UIColor colorWithRed:69/255.0 green:111/255.0 blue:238/255.0 alpha:1];
}

/// Returns the default placeholder color for text view (same as UITextField).
- (UIColor *)_defaultPlaceholderColor {
    return [UIColor colorWithRed:0 green:0 blue:25/255.0 alpha:44/255.0];
}

#pragma mark - Private Setter

- (void)_setText:(NSString *)text {
    if (_text == text || [_text isEqualToString:text]) return;
    [self willChangeValueForKey:@"text"];
    _text = text.copy;
    if (!_text) _text = @"";
    [self didChangeValueForKey:@"text"];
    self.accessibilityLabel = _text;
}

- (void)_setFont:(UIFont *)font {
    if (_font == font || [_font isEqual:font]) return;
    [self willChangeValueForKey:@"font"];
    _font = font;
    [self didChangeValueForKey:@"font"];
}

- (void)_setTextColor:(UIColor *)textColor {
    if (_textColor == textColor) return;
    if (_textColor && textColor) {
        if (CFGetTypeID(_textColor.CGColor) == CFGetTypeID(textColor.CGColor) &&
            CFGetTypeID(_textColor.CGColor) == CGColorGetTypeID()) {
            if ([_textColor isEqual:textColor]) {
                return;
            }
        }
    }
    [self willChangeValueForKey:@"textColor"];
    _textColor = textColor;
    [self didChangeValueForKey:@"textColor"];
}

- (void)_setTextAlignment:(NSTextAlignment)textAlignment {
    if (_textAlignment == textAlignment) return;
    [self willChangeValueForKey:@"textAlignment"];
    _textAlignment = textAlignment;
    [self didChangeValueForKey:@"textAlignment"];
}

- (void)_setDataDetectorTypes:(UIDataDetectorTypes)dataDetectorTypes {
    if (_dataDetectorTypes == dataDetectorTypes) return;
    [self willChangeValueForKey:@"dataDetectorTypes"];
    _dataDetectorTypes = dataDetectorTypes;
    [self didChangeValueForKey:@"dataDetectorTypes"];
}

- (void)_setLinkTextAttributes:(NSDictionary *)linkTextAttributes {
    if (_linkTextAttributes == linkTextAttributes || [_linkTextAttributes isEqual:linkTextAttributes]) return;
    [self willChangeValueForKey:@"linkTextAttributes"];
    _linkTextAttributes = linkTextAttributes.copy;
    [self didChangeValueForKey:@"linkTextAttributes"];
}

- (void)_setHighlightTextAttributes:(NSDictionary *)highlightTextAttributes {
    if (_highlightTextAttributes == highlightTextAttributes || [_highlightTextAttributes isEqual:highlightTextAttributes]) return;
    [self willChangeValueForKey:@"highlightTextAttributes"];
    _highlightTextAttributes = highlightTextAttributes.copy;
    [self didChangeValueForKey:@"highlightTextAttributes"];
}
- (void)_setTextParser:(id<HTextParser>)textParser {
    if (_textParser == textParser || [_textParser isEqual:textParser]) return;
    [self willChangeValueForKey:@"textParser"];
    _textParser = textParser;
    [self didChangeValueForKey:@"textParser"];
}

- (void)_setAttributedText:(NSAttributedString *)attributedText {
    if (_attributedText == attributedText || [_attributedText isEqual:attributedText]) return;
    [self willChangeValueForKey:@"attributedText"];
    _attributedText = attributedText.copy;
    if (!_attributedText) _attributedText = [NSAttributedString new];
    [self didChangeValueForKey:@"attributedText"];
}

- (void)_setTextContainerInset:(UIEdgeInsets)textContainerInset {
    if (UIEdgeInsetsEqualToEdgeInsets(_textContainerInset, textContainerInset)) return;
    [self willChangeValueForKey:@"textContainerInset"];
    _textContainerInset = textContainerInset;
    [self didChangeValueForKey:@"textContainerInset"];
}

- (void)_setExclusionPaths:(NSArray *)exclusionPaths {
    if (_exclusionPaths == exclusionPaths || [_exclusionPaths isEqual:exclusionPaths]) return;
    [self willChangeValueForKey:@"exclusionPaths"];
    _exclusionPaths = exclusionPaths.copy;
    [self didChangeValueForKey:@"exclusionPaths"];
}

- (void)_setVerticalForm:(BOOL)verticalForm {
    if (_verticalForm == verticalForm) return;
    [self willChangeValueForKey:@"verticalForm"];
    _verticalForm = verticalForm;
    [self didChangeValueForKey:@"verticalForm"];
}

- (void)_setLinePositionModifier:(id<HTextLinePositionModifier>)linePositionModifier {
    if (_linePositionModifier == linePositionModifier) return;
    [self willChangeValueForKey:@"linePositionModifier"];
    _linePositionModifier = [(NSObject *)linePositionModifier copy];
    [self didChangeValueForKey:@"linePositionModifier"];
}

- (void)_setSelectedRange:(NSRange)selectedRange {
    if (NSEqualRanges(_selectedRange, selectedRange)) return;
    [self willChangeValueForKey:@"selectedRange"];
    _selectedRange = selectedRange;
    [self didChangeValueForKey:@"selectedRange"];
    if ([self.delegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.delegate textViewDidChangeSelection:self];
    }
}

- (void)_setTypingAttributes:(NSDictionary *)typingAttributes {
    if (_typingAttributes == typingAttributes || [_typingAttributes isEqual:typingAttributes]) return;
    [self willChangeValueForKey:@"typingAttributes"];
    _typingAttributes = typingAttributes.copy;
    [self didChangeValueForKey:@"typingAttributes"];
}

#pragma mark - Private Init

- (void)_initTextView {
    self.delaysContentTouches = NO;
    self.canCancelContentTouches = YES;
    self.multipleTouchEnabled = NO;
    self.clipsToBounds = YES;
    [super setDelegate:self];
    
    _text = @"";
    _attributedText = [NSAttributedString new];
    
    // UITextInputTraits
    _autocapitalizationType = UITextAutocapitalizationTypeSentences;
    _autocorrectionType = UITextAutocorrectionTypeDefault;
    _spellCheckingType = UITextSpellCheckingTypeDefault;
    _keyboardType = UIKeyboardTypeDefault;
    _keyboardAppearance = UIKeyboardAppearanceDefault;
    _returnKeyType = UIReturnKeyDefault;
    _enablesReturnKeyAutomatically = NO;
    _secureTextEntry = NO;
    
    // UITextInput
    _selectedTextRange = [HTextRange defaultRange];
    _markedTextRange = nil;
    _markedTextStyle = nil;
    _tokenizer = [[UITextInputStringTokenizer alloc] initWithTextInput:self];
    
    _editable = YES;
    _selectable = YES;
    _highlightable = YES;
    _allowsCopyAttributedString = YES;
    _textAlignment = NSTextAlignmentNatural;
    
    _innerText = [NSMutableAttributedString new];
    _innerContainer = [HTextContainer new];
    _innerContainer.insets = kDefaultInset;
    _textContainerInset = kDefaultInset;
    _typingAttributesHolder = [[NSMutableAttributedString alloc] initWithString:@" "];
    _linkTextAttributes = @{NSForegroundColorAttributeName : [self _defaultTintColor],
                            (id)kCTForegroundColorAttributeName : (id)[self _defaultTintColor].CGColor};
    
    HTextHighlight *highlight = [HTextHighlight new];
    HTextBorder * border = [HTextBorder new];
    border.insets = UIEdgeInsetsMake(-2, -2, -2, -2);
    border.fillColor = [UIColor colorWithWhite:0.1 alpha:0.2];
    border.cornerRadius = 3;
    [highlight setBorder:border];
    _highlightTextAttributes = highlight.attributes.copy;
    
    _placeHolderView = [UIImageView new];
    _placeHolderView.userInteractionEnabled = NO;
    _placeHolderView.hidden = YES;
    
    _containerView = [HTextContainerView new];
    _containerView.hostView = self;
    
    _selectionView = [HTextSelectionView new];
    _selectionView.userInteractionEnabled = NO;
    _selectionView.hostView = self;
    _selectionView.color = [self _defaultTintColor];
    
    _magnifierCaret = [HTextMagnifier magnifierWithType:HTextMagnifierTypeCaret];
    _magnifierCaret.hostView = _containerView;
    _magnifierRanged = [HTextMagnifier magnifierWithType:HTextMagnifierTypeRanged];
    _magnifierRanged.hostView = _containerView;
    
    [self addSubview:_placeHolderView];
    [self addSubview:_containerView];
    [self addSubview:_selectionView];
    
    _undoStack = [NSMutableArray new];
    _redoStack = [NSMutableArray new];
    _allowsUndoAndRedo = YES;
    _maximumUndoLevel = kDefaultUndoLevelMax;
    
    self.debugOption = [HTextDebugOption sharedDebugOption];
    [HTextDebugOption addDebugTarget:self];
    
    [self _updateInnerContainerSize];
    [self _update];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_pasteboardChanged) name:UIPasteboardChangedNotification object:nil];
    [[HTextKeyboardManager defaultManager] addObserver:self];
    
    self.isAccessibilityElement = YES;
}

#pragma mark - Public

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self _initTextView];
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIPasteboardChangedNotification object:nil];
    [[HTextKeyboardManager defaultManager] removeObserver:self];
    
    [[HTextEffectWindow sharedWindow] hideSelectionDot:_selectionView];
    [[HTextEffectWindow sharedWindow] hideMagnifier:_magnifierCaret];
    [[HTextEffectWindow sharedWindow] hideMagnifier:_magnifierRanged];
    
    [HTextDebugOption removeDebugTarget:self];
    
    [_longPressTimer invalidate];
    [_autoScrollTimer invalidate];
    [_selectionDotFixTimer invalidate];
}

- (void)scrollRangeToVisible:(NSRange)range {
    HTextRange *textRange = [HTextRange rangeWithRange:range];
    textRange = [self _correctedTextRange:textRange];
    [self _scrollRangeToVisible:textRange];
}

#pragma mark - Property

- (void)setText:(NSString *)text {
    if (_text == text || [_text isEqualToString:text]) return;
    [self _setText:text];
    
    _state.selectedWithoutEdit = NO;
    _state.deleteConfirm = NO;
    [self _endTouchTracking];
    [self _hideMenu];
    [self _resetUndoAndRedoStack];
    [self replaceRange:[HTextRange rangeWithRange:NSMakeRange(0, _innerText.length)] withText:text];
}

- (void)setFont:(UIFont *)font {
    if (_font == font || [_font isEqual:font]) return;
    [self _setFont:font];
    
    _state.typingAttributesOnce = NO;
    _typingAttributesHolder.h_font = font;
    _innerText.h_font = font;
    [self _resetUndoAndRedoStack];
    [self _commitUpdate];
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor == textColor || [_textColor isEqual:textColor]) return;
    [self _setTextColor:textColor];
    
    _state.typingAttributesOnce = NO;
    _typingAttributesHolder.h_color = textColor;
    _innerText.h_color = textColor;
    [self _resetUndoAndRedoStack];
    [self _commitUpdate];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    if (_textAlignment == textAlignment) return;
    [self _setTextAlignment:textAlignment];
    
    _typingAttributesHolder.h_alignment = textAlignment;
    _innerText.h_alignment = textAlignment;
    [self _resetUndoAndRedoStack];
    [self _commitUpdate];
}

- (void)setDataDetectorTypes:(UIDataDetectorTypes)dataDetectorTypes {
    if (_dataDetectorTypes == dataDetectorTypes) return;
    [self _setDataDetectorTypes:dataDetectorTypes];
    NSTextCheckingType type = HTextNSTextCheckingTypeFromUIDataDetectorType(dataDetectorTypes);
    _dataDetector = type ? [NSDataDetector dataDetectorWithTypes:type error:NULL] : nil;
    [self _resetUndoAndRedoStack];
    [self _commitUpdate];
}

- (void)setLinkTextAttributes:(NSDictionary *)linkTextAttributes {
    if (_linkTextAttributes == linkTextAttributes || [_linkTextAttributes isEqual:linkTextAttributes]) return;
    [self _setLinkTextAttributes:linkTextAttributes];
    if (_dataDetector) {
        [self _commitUpdate];
    }
}

- (void)setHighlightTextAttributes:(NSDictionary *)highlightTextAttributes {
    if (_highlightTextAttributes == highlightTextAttributes || [_highlightTextAttributes isEqual:highlightTextAttributes]) return;
    [self _setHighlightTextAttributes:highlightTextAttributes];
    if (_dataDetector) {
        [self _commitUpdate];
    }
}

- (void)setTextParser:(id<HTextParser>)textParser {
    if (_textParser == textParser || [_textParser isEqual:textParser]) return;
    [self _setTextParser:textParser];
    if (textParser && _text.length) {
        [self replaceRange:[HTextRange rangeWithRange:NSMakeRange(0, _text.length)] withText:_text];
    }
    [self _resetUndoAndRedoStack];
    [self _commitUpdate];
}

- (void)setTypingAttributes:(NSDictionary *)typingAttributes {
    [self _setTypingAttributes:typingAttributes];
    _state.typingAttributesOnce = YES;
    [typingAttributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self->_typingAttributesHolder h_setAttribute:key value:obj];
    }];
    [self _commitUpdate];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    if (_attributedText == attributedText) return;
    [self _setAttributedText:attributedText];
    _state.typingAttributesOnce = NO;
    
    NSMutableAttributedString *text = attributedText.mutableCopy;
    if (text.length == 0) {
        [self replaceRange:[HTextRange rangeWithRange:NSMakeRange(0, _innerText.length)] withText:@""];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        BOOL should = [self.delegate textView:self shouldChangeTextInRange:NSMakeRange(0, _innerText.length) replacementText:text.string];
        if (!should) return;
    }
    
    _state.selectedWithoutEdit = NO;
    _state.deleteConfirm = NO;
    [self _endTouchTracking];
    [self _hideMenu];
    
    [_inputDelegate selectionWillChange:self];
    [_inputDelegate textWillChange:self];
     _innerText = text;
    [self _parseText];
    _selectedTextRange = [HTextRange rangeWithRange:NSMakeRange(0, _innerText.length)];
    [_inputDelegate textDidChange:self];
    [_inputDelegate selectionDidChange:self];
    
    [self _setAttributedText:text];
    if (_innerText.length > 0) {
        _typingAttributesHolder.h_attributes = [_innerText h_attributesAtIndex:_innerText.length - 1];
    }
    
    [self _updateOuterProperties];
    [self _updateLayout];
    [self _updateSelectionView];
    
    if (self.isFirstResponder) {
        [self _scrollRangeToVisible:_selectedTextRange];
    }
    
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:HTextViewTextDidChangeNotification object:self];
    
    if (!_state.insideUndoBlock) {
        [self _resetUndoAndRedoStack];
    }
}

- (void)setTextVerticalAlignment:(HTextVerticalAlignment)textVerticalAlignment {
    if (_textVerticalAlignment == textVerticalAlignment) return;
    [self willChangeValueForKey:@"textVerticalAlignment"];
    _textVerticalAlignment = textVerticalAlignment;
    [self didChangeValueForKey:@"textVerticalAlignment"];
    _containerView.textVerticalAlignment = textVerticalAlignment;
    [self _commitUpdate];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    if (UIEdgeInsetsEqualToEdgeInsets(_textContainerInset, textContainerInset)) return;
    [self _setTextContainerInset:textContainerInset];
    _innerContainer.insets = textContainerInset;
    [self _commitUpdate];
}

- (void)setExclusionPaths:(NSArray *)exclusionPaths {
    if (_exclusionPaths == exclusionPaths || [_exclusionPaths isEqual:exclusionPaths]) return;
    [self _setExclusionPaths:exclusionPaths];
    _innerContainer.exclusionPaths = exclusionPaths;
    if (_innerContainer.isVerticalForm) {
        CGAffineTransform trans = CGAffineTransformMakeTranslation(_innerContainer.size.width - self.bounds.size.width, 0);
        [_innerContainer.exclusionPaths enumerateObjectsUsingBlock:^(UIBezierPath *path, NSUInteger idx, BOOL *stop) {
            [path applyTransform:trans];
        }];
    }
    [self _commitUpdate];
}

- (void)setVerticalForm:(BOOL)verticalForm {
    if (_verticalForm == verticalForm) return;
    [self _setVerticalForm:verticalForm];
    _innerContainer.verticalForm = verticalForm;
    _selectionView.verticalForm = verticalForm;
    
    [self _updateInnerContainerSize];
    
    if (verticalForm) {
        if (UIEdgeInsetsEqualToEdgeInsets(_innerContainer.insets, kDefaultInset)) {
            _innerContainer.insets = kDefaultVerticalInset;
            [self _setTextContainerInset:kDefaultVerticalInset];
        }
    } else {
        if (UIEdgeInsetsEqualToEdgeInsets(_innerContainer.insets, kDefaultVerticalInset)) {
            _innerContainer.insets = kDefaultInset;
            [self _setTextContainerInset:kDefaultInset];
        }
    }
    
    _innerContainer.exclusionPaths = _exclusionPaths;
    if (verticalForm) {
        CGAffineTransform trans = CGAffineTransformMakeTranslation(_innerContainer.size.width - self.bounds.size.width, 0);
        [_innerContainer.exclusionPaths enumerateObjectsUsingBlock:^(UIBezierPath *path, NSUInteger idx, BOOL *stop) {
            [path applyTransform:trans];
        }];
    }
    
    [self _keyboardChanged];
    [self _commitUpdate];
}

- (void)setLinePositionModifier:(id<HTextLinePositionModifier>)linePositionModifier {
    if (_linePositionModifier == linePositionModifier) return;
    [self _setLinePositionModifier:linePositionModifier];
    _innerContainer.linePositionModifier = linePositionModifier;
    [self _commitUpdate];
}

- (void)setSelectedRange:(NSRange)selectedRange {
    if (NSEqualRanges(_selectedRange, selectedRange)) return;
    if (_markedTextRange) return;
    _state.typingAttributesOnce = NO;
    
    HTextRange *range = [HTextRange rangeWithRange:selectedRange];
    range = [self _correctedTextRange:range];
    [self _endTouchTracking];
    _selectedTextRange = range;
    [self _updateSelectionView];
    
    [self _setSelectedRange:range.asRange];
    
    if (!_state.insideUndoBlock) {
        [self _resetUndoAndRedoStack];
    }
}

- (void)setHighlightable:(BOOL)highlightable {
    if (_highlightable == highlightable) return;
    [self willChangeValueForKey:@"highlightable"];
    _highlightable = highlightable;
    [self didChangeValueForKey:@"highlightable"];
    [self _commitUpdate];
}

- (void)setEditable:(BOOL)editable {
    if (_editable == editable) return;
    [self willChangeValueForKey:@"editable"];
    _editable = editable;
    [self didChangeValueForKey:@"editable"];
    if (!editable) {
        [self resignFirstResponder];
    }
}

- (void)setSelectable:(BOOL)selectable {
    if (_selectable == selectable) return;
    [self willChangeValueForKey:@"selectable"];
    _selectable = selectable;
    [self didChangeValueForKey:@"selectable"];
    if (!selectable) {
        if (self.isFirstResponder) {
            [self resignFirstResponder];
        } else {
            _state.selectedWithoutEdit = NO;
            [self _endTouchTracking];
            [self _hideMenu];
            [self _updateSelectionView];
        }
    }
}

- (void)setClearsOnInsertion:(BOOL)clearsOnInsertion {
    if (_clearsOnInsertion == clearsOnInsertion) return;
    _clearsOnInsertion = clearsOnInsertion;
    if (clearsOnInsertion) {
        if (self.isFirstResponder) {
            self.selectedRange = NSMakeRange(0, _attributedText.length);
        } else {
            _state.clearsOnInsertionOnce = YES;
        }
    }
}

- (void)setDebugOption:(HTextDebugOption *)debugOption {
    _containerView.debugOption = debugOption;
}

- (HTextDebugOption *)debugOption {
    return _containerView.debugOption;
}

- (HTextLayout *)textLayout {
    [self _updateIfNeeded];
    return _innerLayout;
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    if (_placeholderAttributedText.length > 0) {
        if (placeholderText.length > 0) {
            [((NSMutableAttributedString *)_placeholderAttributedText) replaceCharactersInRange:NSMakeRange(0, _placeholderAttributedText.length) withString:placeholderText];
        } else {
            [((NSMutableAttributedString *)_placeholderAttributedText) replaceCharactersInRange:NSMakeRange(0, _placeholderAttributedText.length) withString:@""];
        }
        ((NSMutableAttributedString *)_placeholderAttributedText).h_font = _placeholderFont;
        ((NSMutableAttributedString *)_placeholderAttributedText).h_color = _placeholderTextColor;
    } else {
        if (placeholderText.length > 0) {
            NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderText];
            if (!_placeholderFont) _placeholderFont = _font;
            if (!_placeholderFont) _placeholderFont = [self _defaultFont];
            if (!_placeholderTextColor) _placeholderTextColor = [self _defaultPlaceholderColor];
            atr.h_font = _placeholderFont;
            atr.h_color = _placeholderTextColor;
            _placeholderAttributedText = atr;
        }
    }
    _placeholderText = [_placeholderAttributedText h_plainTextForRange:NSMakeRange(0, _placeholderAttributedText.length)];
    [self _commitPlaceholderUpdate];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    ((NSMutableAttributedString *)_placeholderAttributedText).h_font = _placeholderFont;
    [self _commitPlaceholderUpdate];
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
    _placeholderTextColor = placeholderTextColor;
    ((NSMutableAttributedString *)_placeholderAttributedText).h_color = _placeholderTextColor;
    [self _commitPlaceholderUpdate];
}

- (void)setPlaceholderAttributedText:(NSAttributedString *)placeholderAttributedText {
    _placeholderAttributedText = placeholderAttributedText.mutableCopy;
    _placeholderText = [_placeholderAttributedText h_plainTextForRange:NSMakeRange(0, _placeholderAttributedText.length)];
    _placeholderFont = _placeholderAttributedText.h_font;
    _placeholderTextColor = _placeholderAttributedText.h_color;
    [self _commitPlaceholderUpdate];
}

#pragma mark - Override For Protect

- (void)setMultipleTouchEnabled:(BOOL)multipleTouchEnabled {
    [super setMultipleTouchEnabled:NO]; // must not enabled
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    UIEdgeInsets oldInsets = self.contentInset;
    if (_insetModifiedByKeyboard) {
        _originalContentInset = contentInset;
    } else {
        [super setContentInset:contentInset];
        BOOL changed = !UIEdgeInsetsEqualToEdgeInsets(oldInsets, contentInset);
        if (changed) {
            [self _updateInnerContainerSize];
            [self _commitUpdate];
            [self _commitPlaceholderUpdate];
        }
    }
}

- (void)setScrollIndicatorInsets:(UIEdgeInsets)scrollIndicatorInsets {
    if (_insetModifiedByKeyboard) {
        _originalScrollIndicatorInsets = scrollIndicatorInsets;
    } else {
        [super setScrollIndicatorInsets:scrollIndicatorInsets];
    }
}

- (void)setFrame:(CGRect)frame {
    CGSize oldSize = self.bounds.size;
    [super setFrame:frame];
    CGSize newSize = self.bounds.size;
    BOOL changed = _innerContainer.isVerticalForm ? (oldSize.height != newSize.height) : (oldSize.width != newSize.width);
    if (changed) {
        [self _updateInnerContainerSize];
        [self _commitUpdate];
    }
    if (!CGSizeEqualToSize(oldSize, newSize)) {
        [self _commitPlaceholderUpdate];
    }
}

- (void)setBounds:(CGRect)bounds {
    CGSize oldSize = self.bounds.size;
    [super setBounds:bounds];
    CGSize newSize = self.bounds.size;
    BOOL changed = _innerContainer.isVerticalForm ? (oldSize.height != newSize.height) : (oldSize.width != newSize.width);
    if (changed) {
        [self _updateInnerContainerSize];
        [self _commitUpdate];
    }
    if (!CGSizeEqualToSize(oldSize, newSize)) {
        [self _commitPlaceholderUpdate];
    }
}

- (void)tintColorDidChange {
    if ([self respondsToSelector:@selector(tintColor)]) {
        UIColor *color = self.tintColor;
        NSMutableDictionary *attrs = _highlightTextAttributes.mutableCopy;
        NSMutableDictionary *linkAttrs = _linkTextAttributes.mutableCopy;
        if (!linkAttrs) linkAttrs = @{}.mutableCopy;
        if (!color) {
            [attrs removeObjectForKey:NSForegroundColorAttributeName];
            [attrs removeObjectForKey:(id)kCTForegroundColorAttributeName];
            [linkAttrs setObject:[self _defaultTintColor] forKey:NSForegroundColorAttributeName];
            [linkAttrs setObject:(id)[self _defaultTintColor].CGColor forKey:(id)kCTForegroundColorAttributeName];
        } else {
            [attrs setObject:color forKey:NSForegroundColorAttributeName];
            [attrs setObject:(id)color.CGColor forKey:(id)kCTForegroundColorAttributeName];
            [linkAttrs setObject:color forKey:NSForegroundColorAttributeName];
            [linkAttrs setObject:(id)color.CGColor forKey:(id)kCTForegroundColorAttributeName];
        }
        self.highlightTextAttributes = attrs;
        _selectionView.color = color ? color : [self _defaultTintColor];
        _linkTextAttributes = linkAttrs;
        [self _commitUpdate];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (!_verticalForm && size.width <= 0) size.width = HTextContainerMaxSize.width;
    if (_verticalForm && size.height <= 0) size.height = HTextContainerMaxSize.height;
    
    if ((!_verticalForm && size.width == self.bounds.size.width) ||
        (_verticalForm && size.height == self.bounds.size.height)) {
        [self _updateIfNeeded];
        if (!_verticalForm) {
            if (_containerView.bounds.size.height <= size.height) {
                return _containerView.bounds.size;
            }
        } else {
            if (_containerView.bounds.size.width <= size.width) {
                return _containerView.bounds.size;
            }
        }
    }
    
    if (!_verticalForm) {
        size.height = HTextContainerMaxSize.height;
    } else {
        size.width = HTextContainerMaxSize.width;
    }
    
    HTextContainer *container = [_innerContainer copy];
    container.size = size;
    
    HTextLayout *layout = [HTextLayout layoutWithContainer:container text:_innerText];
    return layout.textBoundingSize;
}

#pragma mark - Override UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self _updateIfNeeded];
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:_containerView];
    
    _touchBeganTime = _trackingTime = touch.timestamp;
    _touchBeganPoint = _trackingPoint = point;
    _trackingRange = _selectedTextRange;
    
    _state.trackingGrabber = NO;
    _state.trackingCaret = NO;
    _state.trackingPreSelect = NO;
    _state.trackingTouch = YES;
    _state.swallowTouch = YES;
    _state.touchMoved = NO;
    
    if (!self.isFirstResponder && !_state.selectedWithoutEdit && self.highlightable) {
        _highlight = [self _getHighlightAtPoint:point range:&_highlightRange];
        _highlightLayout = nil;
    }
    
    if ((!self.selectable && !_highlight) || _state.ignoreTouchBegan) {
        _state.swallowTouch = NO;
        _state.trackingTouch = NO;
    }
    
    if (_state.trackingTouch) {
        [self _startLongPressTimer];
        if (_highlight) {
            [self _showHighlightAnimated:NO];
        } else {
            if ([_selectionView isGrabberContainsPoint:point]) { // track grabber
                self.panGestureRecognizer.enabled = NO; // disable scroll view
                [self _hideMenu];
                _state.trackingGrabber = [_selectionView isStartGrabberContainsPoint:point] ? kStart : kEnd;
                _magnifierRangedOffset = [self _getMagnifierRangedOffset];
            } else {
                if (_selectedTextRange.asRange.length == 0 && self.isFirstResponder) {
                    if ([_selectionView isCaretContainsPoint:point]) { // track caret
                        _state.trackingCaret = YES;
                        self.panGestureRecognizer.enabled = NO; // disable scroll view
                    }
                }
            }
        }
        [self _updateSelectionView];
    }
    
    if (!_state.swallowTouch) [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self _updateIfNeeded];
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:_containerView];
    
    _trackingTime = touch.timestamp;
    _trackingPoint = point;
    
    if (!_state.touchMoved) {
        _state.touchMoved = [self _getMoveDirection];
        if (_state.touchMoved) [self _endLongPressTimer];
    }
    _state.clearsOnInsertionOnce = NO;
    
    if (_state.trackingTouch) {
        BOOL showMagnifierCaret = NO;
        BOOL showMagnifierRanged = NO;
        
        if (_highlight) {
            
            HTextHighlight *highlight = [self _getHighlightAtPoint:_trackingPoint range:NULL];
            if (highlight == _highlight) {
                [self _showHighlightAnimated:YES];
            } else {
                [self _hideHighlightAnimated:YES];
            }
            
        } else {
            _trackingRange = _selectedTextRange;
            if (_state.trackingGrabber) {
                self.panGestureRecognizer.enabled = NO;
                [self _hideMenu];
                [self _updateTextRangeByTrackingGrabber];
                showMagnifierRanged = YES;
            } else if (_state.trackingPreSelect) {
                [self _updateTextRangeByTrackingPreSelect];
                showMagnifierCaret = YES;
            } else if (_state.trackingCaret || _markedTextRange || self.isFirstResponder) {
                if (_state.trackingCaret || _state.touchMoved) {
                    _state.trackingCaret = YES;
                    [self _hideMenu];
                    if (_verticalForm) {
                        if (_state.touchMoved == kTop || _state.touchMoved == kBottom) {
                            self.panGestureRecognizer.enabled = NO;
                        }
                    } else {
                        if (_state.touchMoved == kLeft || _state.touchMoved == kRight) {
                            self.panGestureRecognizer.enabled = NO;
                        }
                    }
                    [self _updateTextRangeByTrackingCaret];
                    if (_markedTextRange) {
                        showMagnifierRanged = YES;
                    } else {
                        showMagnifierCaret = YES;
                    }
                }
            }
        }
        [self _updateSelectionView];
        if (showMagnifierCaret) [self _showMagnifierCaret];
        if (showMagnifierRanged) [self _showMagnifierRanged];
    }
    
    CGFloat autoScrollOffset = [self _getAutoscrollOffset];
    if (_autoScrollOffset != autoScrollOffset) {
        if (fabs(autoScrollOffset) < fabs(_autoScrollOffset)) {
            _autoScrollAcceleration *= 0.5;
        }
        _autoScrollOffset = autoScrollOffset;
        if (_autoScrollOffset != 0 && _state.touchMoved) {
            [self _startAutoScrollTimer];
        }
    }
    
    if (!_state.swallowTouch) [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self _updateIfNeeded];
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:_containerView];
    
    _trackingTime = touch.timestamp;
    _trackingPoint = point;
    
    if (!_state.touchMoved) {
        _state.touchMoved = [self _getMoveDirection];
    }
    if (_state.trackingTouch) {
        [self _hideMagnifier];
        
        if (_highlight) {
            if (_state.showingHighlight) {
                if (_highlight.tapAction) {
                    CGRect rect = [_innerLayout rectForRange:[HTextRange rangeWithRange:_highlightRange]];
                    rect = [self _convertRectFromLayout:rect];
                    _highlight.tapAction(self, _innerText, _highlightRange, rect);
                } else {
                    BOOL shouldTap = YES;
                    if ([self.delegate respondsToSelector:@selector(textView:shouldTapHighlight:inRange:)]) {
                        shouldTap = [self.delegate textView:self shouldTapHighlight:_highlight inRange:_highlightRange];
                    }
                    if (shouldTap && [self.delegate respondsToSelector:@selector(textView:didTapHighlight:inRange:rect:)]) {
                        CGRect rect = [_innerLayout rectForRange:[HTextRange rangeWithRange:_highlightRange]];
                        rect = [self _convertRectFromLayout:rect];
                        [self.delegate textView:self didTapHighlight:_highlight inRange:_highlightRange rect:rect];
                    }
                }
                [self _removeHighlightAnimated:YES];
            }
        } else {
            if (_state.trackingCaret) {
                if (_state.touchMoved) {
                    [self _updateTextRangeByTrackingCaret];
                    [self _showMenu];
                } else {
                    if (_state.showingMenu) [self _hideMenu];
                    else [self _showMenu];
                }
            } else if (_state.trackingGrabber) {
                [self _updateTextRangeByTrackingGrabber];
                [self _showMenu];
            } else if (_state.trackingPreSelect) {
                [self _updateTextRangeByTrackingPreSelect];
                if (_trackingRange.asRange.length > 0) {
                    _state.selectedWithoutEdit = YES;
                    [self _showMenu];
                } else {
                    [self performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
                }
            } else if (_state.deleteConfirm || _markedTextRange) {
                [self _updateTextRangeByTrackingCaret];
                [self _hideMenu];
            } else {
                if (!_state.touchMoved) {
                    if (_state.selectedWithoutEdit) {
                        _state.selectedWithoutEdit = NO;
                        [self _hideMenu];
                    } else {
                        if (self.isFirstResponder) {
                            HTextRange *_oldRange = _trackingRange;
                            [self _updateTextRangeByTrackingCaret];
                            if ([_oldRange isEqual:_trackingRange]) {
                                if (_state.showingMenu) [self _hideMenu];
                                else [self _showMenu];
                            } else {
                                [self _hideMenu];
                            }
                        } else {
                            [self _hideMenu];
                            if (_state.clearsOnInsertionOnce) {
                                _state.clearsOnInsertionOnce = NO;
                                _selectedTextRange = [HTextRange rangeWithRange:NSMakeRange(0, _innerText.length)];
                                [self _setSelectedRange:_selectedTextRange.asRange];
                            } else {
                                [self _updateTextRangeByTrackingCaret];
                            }
                            [self performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
                        }
                    }
                }
            }
        }
        
        if (_trackingRange && (![_trackingRange isEqual:_selectedTextRange] || _state.trackingPreSelect)) {
            if (![_trackingRange isEqual:_selectedTextRange]) {
                [_inputDelegate selectionWillChange:self];
                _selectedTextRange = _trackingRange;
                [_inputDelegate selectionDidChange:self];
                [self _updateAttributesHolder];
                [self _updateOuterProperties];
            }
            if (!_state.trackingGrabber && !_state.trackingPreSelect) {
                [self _scrollRangeToVisible:_selectedTextRange];
            }
        }
        
        [self _endTouchTracking];
    }
    
    if (!_state.swallowTouch) [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self _endTouchTracking];
    [self _hideMenu];

    if (!_state.swallowTouch) [super touchesCancelled:touches withEvent:event];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake && _allowsUndoAndRedo) {
        if (!HTextIsAppExtension()) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [self performSelector:@selector(_showUndoRedoAlert)];
#pragma clang diagnostic pop
        }
    } else {
        [super motionEnded:motion withEvent:event];
    }
}

- (BOOL)canBecomeFirstResponder {
    if (!self.isSelectable) return NO;
    if (!self.isEditable) return NO;
    if (_state.ignoreFirstResponder) return NO;
    if ([self.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        if (![self.delegate textViewShouldBeginEditing:self]) return NO;
    }
    return YES;
}

- (BOOL)becomeFirstResponder {
    BOOL isFirstResponder = self.isFirstResponder;
    if (isFirstResponder) return YES;
    BOOL shouldDetectData = [self _shouldDetectText];
    BOOL become = [super becomeFirstResponder];
    if (!isFirstResponder && become) {
        [self _endTouchTracking];
        [self _hideMenu];
        
        _state.selectedWithoutEdit = NO;
        if (shouldDetectData != [self _shouldDetectText]) {
            [self _update];
        }
        [self _updateIfNeeded];
        [self _updateSelectionView];
        [self performSelector:@selector(_scrollSelectedRangeToVisible) withObject:nil afterDelay:0];
        if ([self.delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
            [self.delegate textViewDidBeginEditing:self];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:HTextViewTextDidBeginEditingNotification object:self];
    }
    return become;
}

- (BOOL)canResignFirstResponder {
    if (!self.isFirstResponder) return YES;
    if ([self.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        if (![self.delegate textViewShouldEndEditing:self]) return NO;
    }
    return YES;
}

- (BOOL)resignFirstResponder {
    BOOL isFirstResponder = self.isFirstResponder;
    if (!isFirstResponder) return YES;
    BOOL resign = [super resignFirstResponder];
    if (resign) {
        if (_markedTextRange) {
            _markedTextRange = nil;
            [self _parseText];
            [self _setText:[_innerText h_plainTextForRange:NSMakeRange(0, _innerText.length)]];
        }
        _state.selectedWithoutEdit = NO;
        if ([self _shouldDetectText]) {
            [self _update];
        }
        [self _endTouchTracking];
        [self _hideMenu];
        [self _updateIfNeeded];
        [self _updateSelectionView];
        [self _restoreInsetsAnimated:YES];
        if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
            [self.delegate textViewDidEndEditing:self];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:HTextViewTextDidEndEditingNotification object:self];
    }
    return resign;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    /*
     ------------------------------------------------------
     Default menu actions list:
     cut:                                   Cut
     copy:                                  Copy
     select:                                Select
     selectAll:                             Select All
     paste:                                 Paste
     delete:                                Delete
     _promptForReplace:                     Replace...
     _transliterateChinese:                 简⇄繁
     _showTextStyleOptions:                 𝐁𝐼𝐔
     _define:                               Define
     _addShortcut:                          Add...
     _accessibilitySpeak:                   Speak
     _accessibilitySpeakLanguageSelection:  Speak...
     _accessibilityPauseSpeaking:           Pause Speak
     makeTextWritingDirectionRightToLeft:   ⇋
     makeTextWritingDirectionLeftToRight:   ⇌
     
     ------------------------------------------------------
     Default attribute modifier list:
     toggleBoldface:
     toggleItalics:
     toggleUnderline:
     increaseSize:
     decreaseSize:
     */
    
    if (_selectedTextRange.asRange.length == 0) {
        if (action == @selector(select:) ||
            action == @selector(selectAll:)) {
            return _innerText.length > 0;
        }
        if (action == @selector(paste:)) {
            return [self _isPasteboardContainsValidValue];
        }
    } else {
        if (action == @selector(cut:)) {
            return self.isFirstResponder && self.editable;
        }
        if (action == @selector(copy:)) {
            return YES;
        }
        if (action == @selector(selectAll:)) {
            return _selectedTextRange.asRange.length < _innerText.length;
        }
        if (action == @selector(paste:)) {
            return self.isFirstResponder && self.editable && [self _isPasteboardContainsValidValue];
        }
        NSString *selString = NSStringFromSelector(action);
        if ([selString hasSuffix:@"define:"] && [selString hasPrefix:@"_"]) {
            return [self _getRootViewController] != nil;
        }
    }
    return NO;
}

- (void)reloadInputViews {
    [super reloadInputViews];
    if (_markedTextRange) {
        [self unmarkText];
    }
}

#pragma mark - Override NSObject(UIResponderStandardEditActions)

- (void)cut:(id)sender {
    [self _endTouchTracking];
    if (_selectedTextRange.asRange.length == 0) return;
    
    [self _copySelectedTextToPasteboard];
    [self _saveToUndoStack];
    [self _resetRedoStack];
    [self replaceRange:_selectedTextRange withText:@""];
}

- (void)copy:(id)sender {
    [self _endTouchTracking];
    [self _copySelectedTextToPasteboard];
}

- (void)paste:(id)sender {
    [self _endTouchTracking];
    UIPasteboard *p = [UIPasteboard generalPasteboard];
    NSAttributedString *atr = nil;
    
    if (_allowsPasteAttributedString) {
        atr = p.h_AttributedString;
        if (atr.length == 0) atr = nil;
    }
    if (!atr && _allowsPasteImage) {
        UIImage *img = nil;
        
        Class cls = NSClassFromString(@"HImage");
        if (cls) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            if (p.h_GIFData) {
                img = [(id)cls performSelector:@selector(imageWithData:scale:) withObject:p.h_GIFData withObject:nil];
            }
            if (!img && p.h_PNGData) {
                img = [(id)cls performSelector:@selector(imageWithData:scale:) withObject:p.h_PNGData withObject:nil];
            }
            if (!img && p.h_WEBPData) {
                img = [(id)cls performSelector:@selector(imageWithData:scale:) withObject:p.h_WEBPData withObject:nil];
            }
#pragma clang diagnostic pop
        }
        
        if (!img) {
            img = p.image;
        }
        if (!img && p.h_ImageData) {
            img = [UIImage imageWithData:p.h_ImageData scale:HTextScreenScale()];
        }
        if (img && img.size.width > 1 && img.size.height > 1) {
            id content = img;
            
            if (cls) {
                if ([img conformsToProtocol:NSProtocolFromString(@"HAnimatedImage")]) {
                    NSNumber *frameCount = [img valueForKey:@"animatedImageFrameCount"];
                    if (frameCount.integerValue > 1) {
                        Class viewCls = NSClassFromString(@"HAnimatedImageView");
                        UIImageView *imgView = [(id)viewCls new];
                        imgView.image = img;
                        imgView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
                        if (imgView) {
                            content = imgView;
                        }
                    }
                }
            }
            
            if ([content isKindOfClass:[UIImage class]] && img.images.count > 1) {
                UIImageView *imgView = [UIImageView new];
                imgView.image = img;
                imgView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
                if (imgView) {
                    content = imgView;
                }
            }
            
            NSMutableAttributedString *attText = [NSAttributedString h_attachmentStringWithContent:content contentMode:UIViewContentModeScaleToFill width:img.size.width ascent:img.size.height descent:0];
            NSDictionary *attrs = _typingAttributesHolder.h_attributes;
            if (attrs) [attText addAttributes:attrs range:NSMakeRange(0, attText.length)];
            atr = attText;
        }
    }
    
    if (atr) {
        NSUInteger endPosition = _selectedTextRange.start.offset + atr.length;
        NSMutableAttributedString *text = _innerText.mutableCopy;
        [text replaceCharactersInRange:_selectedTextRange.asRange withAttributedString:atr];
        self.attributedText = text;
        HTextPosition *pos = [self _correctedTextPosition:[HTextPosition positionWithOffset:endPosition]];
        HTextRange *range = [_innerLayout textRangeByExtendingPosition:pos];
        range = [self _correctedTextRange:range];
        if (range) {
            self.selectedRange = NSMakeRange(range.end.offset, 0);
        }
    } else {
        NSString *string = p.string;
        if (string.length > 0) {
            [self _saveToUndoStack];
            [self _resetRedoStack];
            [self replaceRange:_selectedTextRange withText:string];
        }
    }
}

- (void)select:(id)sender {
    [self _endTouchTracking];
    
    if (_selectedTextRange.asRange.length > 0 || _innerText.length == 0) return;
    HTextRange *newRange = [self _getClosestTokenRangeAtPosition:_selectedTextRange.start];
    if (newRange.asRange.length > 0) {
        [_inputDelegate selectionWillChange:self];
        _selectedTextRange = newRange;
        [_inputDelegate selectionDidChange:self];
    }
    
    [self _updateIfNeeded];
    [self _updateOuterProperties];
    [self _updateSelectionView];
    [self _hideMenu];
    [self _showMenu];
}

- (void)selectAll:(id)sender {
    _trackingRange = nil;
    [_inputDelegate selectionWillChange:self];
    _selectedTextRange = [HTextRange rangeWithRange:NSMakeRange(0, _innerText.length)];
    [_inputDelegate selectionDidChange:self];
    
    [self _updateIfNeeded];
    [self _updateOuterProperties];
    [self _updateSelectionView];
    [self _hideMenu];
    [self _showMenu];
}

- (void)_define:(id)sender {
    [self _hideMenu];
    
    NSString *string = [_innerText h_plainTextForRange:_selectedTextRange.asRange];
    if (string.length == 0) return;
    BOOL resign = [self resignFirstResponder];
    if (!resign) return;
    
    UIReferenceLibraryViewController* ref = [[UIReferenceLibraryViewController alloc] initWithTerm:string];
    ref.view.backgroundColor = [UIColor whiteColor];
    [[self _getRootViewController] presentViewController:ref animated:YES completion:^{}];
}


#pragma mark - Overrice NSObject(NSKeyValueObservingCustomization)

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    static NSSet *keys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keys = [NSSet setWithArray:@[
            @"text",
            @"font",
            @"textColor",
            @"textAlignment",
            @"dataDetectorTypes",
            @"linkTextAttributes",
            @"highlightTextAttributes",
            @"textParser",
            @"attributedText",
            @"textVerticalAlignment",
            @"textContainerInset",
            @"exclusionPaths",
            @"verticalForm",
            @"linePositionModifier",
            @"selectedRange",
            @"typingAttributes"
        ]];
    });
    if ([keys containsObject:key]) {
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

#pragma mark - @protocol NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self _initTextView];
    self.attributedText = [aDecoder decodeObjectForKey:@"attributedText"];
    self.selectedRange = ((NSValue *)[aDecoder decodeObjectForKey:@"selectedRange"]).rangeValue;
    self.textVerticalAlignment = [aDecoder decodeIntegerForKey:@"textVerticalAlignment"];
    self.dataDetectorTypes = [aDecoder decodeIntegerForKey:@"dataDetectorTypes"];
    self.textContainerInset = ((NSValue *)[aDecoder decodeObjectForKey:@"textContainerInset"]).UIEdgeInsetsValue;
    self.exclusionPaths = [aDecoder decodeObjectForKey:@"exclusionPaths"];
    self.verticalForm = [aDecoder decodeBoolForKey:@"verticalForm"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.attributedText forKey:@"attributedText"];
    [aCoder encodeObject:[NSValue valueWithRange:self.selectedRange] forKey:@"selectedRange"];
    [aCoder encodeInteger:self.textVerticalAlignment forKey:@"textVerticalAlignment"];
    [aCoder encodeInteger:self.dataDetectorTypes forKey:@"dataDetectorTypes"];
    [aCoder encodeUIEdgeInsets:self.textContainerInset forKey:@"textContainerInset"];
    [aCoder encodeObject:self.exclusionPaths forKey:@"exclusionPaths"];
    [aCoder encodeBool:self.verticalForm forKey:@"verticalForm"];
}

#pragma mark - @protocol UIScrollViewDelegate

- (id<HTextViewDelegate>)delegate {
    return _outerDelegate;
}

- (void)setDelegate:(id<HTextViewDelegate>)delegate {
    _outerDelegate = delegate;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[HTextEffectWindow sharedWindow] hideSelectionDot:_selectionView];
    
    if ([_outerDelegate respondsToSelector:_cmd]) {
        [_outerDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([_outerDelegate respondsToSelector:_cmd]) {
        [_outerDelegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([_outerDelegate respondsToSelector:_cmd]) {
        [_outerDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([_outerDelegate respondsToSelector:_cmd]) {
        [_outerDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [[HTextEffectWindow sharedWindow] showSelectionDot:_selectionView];
    }
    
    if ([_outerDelegate respondsToSelector:_cmd]) {
        [_outerDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([_outerDelegate respondsToSelector:_cmd]) {
        [_outerDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [[HTextEffectWindow sharedWindow] showSelectionDot:_selectionView];
    
    if ([_outerDelegate respondsToSelector:_cmd]) {
        [_outerDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([_outerDelegate respondsToSelector:_cmd]) {
        [_outerDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if ([_outerDelegate respondsToSelector:_cmd]) {
        return [_outerDelegate viewForZoomingInScrollView:scrollView];
    } else {
        return nil;
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    if ([_outerDelegate respondsToSelector:_cmd]) {
        [_outerDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if ([_outerDelegate respondsToSelector:_cmd]) {
        [_outerDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if ([_outerDelegate respondsToSelector:_cmd]) {
        return [_outerDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([_outerDelegate respondsToSelector:_cmd]) {
        [_outerDelegate scrollViewDidScrollToTop:scrollView];
    }
}

#pragma mark - @protocol HTextKeyboardObserver

- (void)keyboardChangedWithTransition:(HTextKeyboardTransition)transition {
    [self _keyboardChanged];
}

#pragma mark - @protocol UIALertViewDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if (title.length == 0) return;
    NSArray *strings = [self _localizedUndoStrings];
    if ([title isEqualToString:strings[1]] || [title isEqualToString:strings[2]]) {
        [self _redo];
    } else if ([title isEqualToString:strings[3]] || [title isEqualToString:strings[4]]) {
        [self _undo];
    }
    [self _restoreFirstResponderAfterUndoAlert];
}
#pragma clang diagnostic pop

#pragma mark - @protocol UIKeyInput

- (BOOL)hasText {
    return _innerText.length > 0;
}

- (void)insertText:(NSString *)text {
    if (text.length == 0) return;
    if (!NSEqualRanges(_lastTypeRange, _selectedTextRange.asRange)) {
        [self _saveToUndoStack];
        [self _resetRedoStack];
    }
    [self replaceRange:_selectedTextRange withText:text];
}

- (void)deleteBackward {
    [self _updateIfNeeded];
    NSRange range = _selectedTextRange.asRange;
    if (range.location == 0 && range.length == 0) return;
    _state.typingAttributesOnce = NO;
    
    // test if there's 'TextBinding' before the caret
    if (!_state.deleteConfirm && range.length == 0 && range.location > 0) {
        NSRange effectiveRange;
        HTextBinding *binding = [_innerText attribute:HTextBindingAttributeName atIndex:range.location - 1 longestEffectiveRange:&effectiveRange inRange:NSMakeRange(0, _innerText.length)];
        if (binding && binding.deleteConfirm) {
            _state.deleteConfirm = YES;
            [_inputDelegate selectionWillChange:self];
            _selectedTextRange = [HTextRange rangeWithRange:effectiveRange];
            _selectedTextRange = [self _correctedTextRange:_selectedTextRange];
            [_inputDelegate selectionDidChange:self];
            
            [self _updateOuterProperties];
            [self _updateSelectionView];
            return;
        }
    }
    
    _state.deleteConfirm = NO;
    if (range.length == 0) {
        HTextRange *extendRange = [_innerLayout textRangeByExtendingPosition:_selectedTextRange.end inDirection:UITextLayoutDirectionLeft offset:1];
        if ([self _isTextRangeValid:extendRange]) {
            range = extendRange.asRange;
        }
    }
    if (!NSEqualRanges(_lastTypeRange, _selectedTextRange.asRange)) {
        [self _saveToUndoStack];
        [self _resetRedoStack];
    }
    [self replaceRange:[HTextRange rangeWithRange:range] withText:@""];
}

#pragma mark - @protocol UITextInput

- (void)setInputDelegate:(id<UITextInputDelegate>)inputDelegate {
    _inputDelegate = inputDelegate;
}

- (void)setSelectedTextRange:(HTextRange *)selectedTextRange {
    if (!selectedTextRange) return;
    selectedTextRange = [self _correctedTextRange:selectedTextRange];
    if ([selectedTextRange isEqual:_selectedTextRange]) return;
    [self _updateIfNeeded];
    [self _endTouchTracking];
    [self _hideMenu];
    _state.deleteConfirm = NO;
    _state.typingAttributesOnce = NO;
    
    [_inputDelegate selectionWillChange:self];
    _selectedTextRange = selectedTextRange;
    _lastTypeRange = _selectedTextRange.asRange;
    [_inputDelegate selectionDidChange:self];
    
    [self _updateOuterProperties];
    [self _updateSelectionView];
    
    if (self.isFirstResponder) {
        [self _scrollRangeToVisible:_selectedTextRange];
    }
}

- (void)setMarkedTextStyle:(NSDictionary *)markedTextStyle {
    _markedTextStyle = markedTextStyle.copy;
}

/*
 Replace current markedText with the new markedText
 @param markedText     New marked text.
 @param selectedRange  The range from the '_markedTextRange'
 */
- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange {
    [self _updateIfNeeded];
    [self _endTouchTracking];
    [self _hideMenu];
    
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        NSRange range = _markedTextRange ? _markedTextRange.asRange : NSMakeRange(_selectedTextRange.end.offset, 0);
        BOOL should = [self.delegate textView:self shouldChangeTextInRange:range replacementText:markedText];
        if (!should) return;
    }
    
    
    if (!NSEqualRanges(_lastTypeRange, _selectedTextRange.asRange)) {
        [self _saveToUndoStack];
        [self _resetRedoStack];
    }
    
    BOOL needApplyHolderAttribute = NO;
    if (_innerText.length > 0 && _markedTextRange) {
        [self _updateAttributesHolder];
    } else {
        needApplyHolderAttribute = YES;
    }
    
    if (_selectedTextRange.asRange.length > 0) {
        [self replaceRange:_selectedTextRange withText:@""];
    }
    
    [_inputDelegate textWillChange:self];
    [_inputDelegate selectionWillChange:self];
    
    if (!markedText) markedText = @"";
    if (_markedTextRange == nil) {
        _markedTextRange = [HTextRange rangeWithRange:NSMakeRange(_selectedTextRange.end.offset, markedText.length)];
        [_innerText replaceCharactersInRange:NSMakeRange(_selectedTextRange.end.offset, 0) withString:markedText];
        _selectedTextRange = [HTextRange rangeWithRange:NSMakeRange(_selectedTextRange.start.offset + selectedRange.location, selectedRange.length)];
    } else {
        _markedTextRange = [self _correctedTextRange:_markedTextRange];
        [_innerText replaceCharactersInRange:_markedTextRange.asRange withString:markedText];
        _markedTextRange = [HTextRange rangeWithRange:NSMakeRange(_markedTextRange.start.offset, markedText.length)];
        _selectedTextRange = [HTextRange rangeWithRange:NSMakeRange(_markedTextRange.start.offset + selectedRange.location, selectedRange.length)];
    }
    
    _selectedTextRange = [self _correctedTextRange:_selectedTextRange];
    _markedTextRange = [self _correctedTextRange:_markedTextRange];
    if (_markedTextRange.asRange.length == 0) {
        _markedTextRange = nil;
    } else {
        if (needApplyHolderAttribute) {
            [_innerText setAttributes:_typingAttributesHolder.h_attributes range:_markedTextRange.asRange];
        }
        [_innerText h_removeDiscontinuousAttributesInRange:_markedTextRange.asRange];
    }
    
    [_inputDelegate selectionDidChange:self];
    [_inputDelegate textDidChange:self];
    
    [self _updateOuterProperties];
    [self _updateLayout];
    [self _updateSelectionView];
    [self _scrollRangeToVisible:_selectedTextRange];
    
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:HTextViewTextDidChangeNotification object:self];
    
    _lastTypeRange = _selectedTextRange.asRange;
}

- (void)unmarkText {
    _markedTextRange = nil;
    [self _endTouchTracking];
    [self _hideMenu];
    if ([self _parseText]) _state.needUpdate = YES;
    
    [self _updateIfNeeded];
    [self _updateOuterProperties];
    [self _updateSelectionView];
    [self _scrollRangeToVisible:_selectedTextRange];
}

- (void)replaceRange:(HTextRange *)range withText:(NSString *)text {
    if (!range) return;
    if (!text) text = @"";
    if (range.asRange.length == 0 && text.length == 0) return;
    range = [self _correctedTextRange:range];
    
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        BOOL should = [self.delegate textView:self shouldChangeTextInRange:range.asRange replacementText:text];
        if (!should) return;
    }
    
    BOOL useInnerAttributes = NO;
    if (_innerText.length > 0) {
        if (range.start.offset == 0 && range.end.offset == _innerText.length) {
            if (text.length == 0) {
                NSMutableDictionary *attrs = [_innerText h_attributesAtIndex:0].mutableCopy;
                [attrs removeObjectsForKeys:[NSMutableAttributedString h_allDiscontinuousAttributeKeys]];
                _typingAttributesHolder.h_attributes = attrs;
            }
        }
    } else { // no text
        useInnerAttributes = YES;
    }
    BOOL applyTypingAttributes = NO;
    if (_state.typingAttributesOnce) {
        _state.typingAttributesOnce = NO;
        if (!useInnerAttributes) {
            if (range.asRange.length == 0 && text.length > 0) {
                applyTypingAttributes = YES;
            }
        }
    }
    
    _state.selectedWithoutEdit = NO;
    _state.deleteConfirm = NO;
    [self _endTouchTracking];
    [self _hideMenu];
    
    [self _replaceRange:range withText:text notifyToDelegate:YES];
    if (useInnerAttributes) {
        [_innerText h_setAttributes:_typingAttributesHolder.h_attributes];
    } else if (applyTypingAttributes) {
        NSRange newRange = NSMakeRange(range.asRange.location, text.length);
        [_typingAttributesHolder.h_attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self->_innerText h_setAttribute:key value:obj range:newRange];
        }];
    }
    [self _parseText];
    [self _updateOuterProperties];
    [self _update];
    
    if (self.isFirstResponder) {
        [self _scrollRangeToVisible:_selectedTextRange];
    }
    
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:HTextViewTextDidChangeNotification object:self];
    
    _lastTypeRange = _selectedTextRange.asRange;
}

- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(HTextRange *)range {
    if (!range) return;
    range = [self _correctedTextRange:range];
    [_innerText h_setBaseWritingDirection:(NSWritingDirection)writingDirection range:range.asRange];
    [self _commitUpdate];
}

- (NSString *)textInRange:(HTextRange *)range {
    range = [self _correctedTextRange:range];
    if (!range) return @"";
    return [_innerText.string substringWithRange:range.asRange];
}

- (UITextWritingDirection)baseWritingDirectionForPosition:(HTextPosition *)position inDirection:(UITextStorageDirection)direction {
    [self _updateIfNeeded];
    position = [self _correctedTextPosition:position];
    if (!position) return UITextWritingDirectionNatural;
    if (_innerText.length == 0) return UITextWritingDirectionNatural;
    NSUInteger idx = position.offset;
    if (idx == _innerText.length) idx--;
    
    NSDictionary *attrs = [_innerText h_attributesAtIndex:idx];
    CTParagraphStyleRef paraStyle = (__bridge CFTypeRef)(attrs[NSParagraphStyleAttributeName]);
    if (paraStyle) {
        CTWritingDirection baseWritingDirection;
        if (CTParagraphStyleGetValueForSpecifier(paraStyle, kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(CTWritingDirection), &baseWritingDirection)) {
            return (UITextWritingDirection)baseWritingDirection;
        }
    }
    
    return UITextWritingDirectionNatural;
}

- (HTextPosition *)beginningOfDocument {
    return [HTextPosition positionWithOffset:0];
}

- (HTextPosition *)endOfDocument {
    return [HTextPosition positionWithOffset:_innerText.length];
}

- (HTextPosition *)positionFromPosition:(HTextPosition *)position offset:(NSInteger)offset {
    if (offset == 0) return position;
    
    NSUInteger location = position.offset;
    NSInteger newLocation = (NSInteger)location + offset;
    if (newLocation < 0 || newLocation > _innerText.length) return nil;
    
    if (newLocation != 0 && newLocation != _innerText.length) {
        // fix emoji
        [self _updateIfNeeded];
        HTextRange *extendRange = [_innerLayout textRangeByExtendingPosition:[HTextPosition positionWithOffset:newLocation]];
        if (extendRange.asRange.length > 0) {
            if (offset < 0) {
                newLocation = extendRange.start.offset;
            } else {
                newLocation = extendRange.end.offset;
            }
        }
    }
    
    HTextPosition *p = [HTextPosition positionWithOffset:newLocation];
    return [self _correctedTextPosition:p];
}

- (HTextPosition *)positionFromPosition:(HTextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset {
    [self _updateIfNeeded];
    HTextRange *range = [_innerLayout textRangeByExtendingPosition:position inDirection:direction offset:offset];
    
    BOOL forward;
    if (_innerContainer.isVerticalForm) {
        forward = direction == UITextLayoutDirectionLeft || direction == UITextLayoutDirectionDown;
    } else {
        forward = direction == UITextLayoutDirectionDown || direction == UITextLayoutDirectionRight;
    }
    if (!forward && offset < 0) {
        forward = -forward;
    }
    
    HTextPosition *newPosition = forward ? range.end : range.start;
    if (newPosition.offset > _innerText.length) {
        newPosition = [HTextPosition positionWithOffset:_innerText.length affinity:HTextAffinityBackward];
    }
    
    return [self _correctedTextPosition:newPosition];
}

- (HTextRange *)textRangeFromPosition:(HTextPosition *)fromPosition toPosition:(HTextPosition *)toPosition {
    return [HTextRange rangeWithStart:fromPosition end:toPosition];
}

- (NSComparisonResult)comparePosition:(HTextPosition *)position toPosition:(HTextPosition *)other {
    return [position compare:other];
}

- (NSInteger)offsetFromPosition:(HTextPosition *)from toPosition:(HTextPosition *)toPosition {
    return toPosition.offset - from.offset;
}

- (HTextPosition *)positionWithinRange:(HTextRange *)range farthestInDirection:(UITextLayoutDirection)direction {
    NSRange nsRange = range.asRange;
    if (direction == UITextLayoutDirectionLeft | direction == UITextLayoutDirectionUp) {
        return [HTextPosition positionWithOffset:nsRange.location];
    } else {
        return [HTextPosition positionWithOffset:nsRange.location + nsRange.length affinity:HTextAffinityBackward];
    }
}

- (HTextRange *)characterRangeByExtendingPosition:(HTextPosition *)position inDirection:(UITextLayoutDirection)direction {
    [self _updateIfNeeded];
    HTextRange *range = [_innerLayout textRangeByExtendingPosition:position inDirection:direction offset:1];
    return [self _correctedTextRange:range];
}

- (HTextPosition *)closestPositionToPoint:(CGPoint)point {
    [self _updateIfNeeded];
    point = [self _convertPointToLayout:point];
    HTextPosition *position = [_innerLayout closestPositionToPoint:point];
    return [self _correctedTextPosition:position];
}

- (HTextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(HTextRange *)range {
    HTextPosition *pos = (id)[self closestPositionToPoint:point];
    if (!pos) return nil;
    
    range = [self _correctedTextRange:range];
    if ([pos compare:range.start] == NSOrderedAscending) {
        pos = range.start;
    } else if ([pos compare:range.end] == NSOrderedDescending) {
        pos = range.end;
    }
    return pos;
}

- (HTextRange *)characterRangeAtPoint:(CGPoint)point {
    [self _updateIfNeeded];
    point = [self _convertPointToLayout:point];
    HTextRange *r = [_innerLayout closestTextRangeAtPoint:point];
    return [self _correctedTextRange:r];
}

- (CGRect)firstRectForRange:(HTextRange *)range {
    [self _updateIfNeeded];
    CGRect rect = [_innerLayout firstRectForRange:range];
    if (CGRectIsNull(rect)) rect = CGRectZero;
    return [self _convertRectFromLayout:rect];
}

- (CGRect)caretRectForPosition:(HTextPosition *)position {
    [self _updateIfNeeded];
    CGRect caretRect = [_innerLayout caretRectForPosition:position];
    if (!CGRectIsNull(caretRect)) {
        caretRect = [self _convertRectFromLayout:caretRect];
        caretRect = CGRectStandardize(caretRect);
        if (_verticalForm) {
            if (caretRect.size.height == 0) {
                caretRect.size.height = 2;
                caretRect.origin.y -= 2 * 0.5;
            }
            if (caretRect.origin.y < 0) {
                caretRect.origin.y = 0;
            } else if (caretRect.origin.y + caretRect.size.height > self.bounds.size.height) {
                caretRect.origin.y = self.bounds.size.height - caretRect.size.height;
            }
        } else {
            if (caretRect.size.width == 0) {
                caretRect.size.width = 2;
                caretRect.origin.x -= 2 * 0.5;
            }
            if (caretRect.origin.x < 0) {
                caretRect.origin.x = 0;
            } else if (caretRect.origin.x + caretRect.size.width > self.bounds.size.width) {
                caretRect.origin.x = self.bounds.size.width - caretRect.size.width;
            }
        }
        return HTextCGRectPixelRound(caretRect);
    }
    return CGRectZero;
}

- (NSArray *)selectionRectsForRange:(HTextRange *)range {
    [self _updateIfNeeded];
    NSArray *rects = [_innerLayout selectionRectsForRange:range];
    [rects enumerateObjectsUsingBlock:^(HTextSelectionRect *rect, NSUInteger idx, BOOL *stop) {
        rect.rect = [self _convertRectFromLayout:rect.rect];
    }];
    return rects;
}

#pragma mark - @protocol UITextInput optional

- (UITextStorageDirection)selectionAffinity {
    if (_selectedTextRange.end.affinity == HTextAffinityForward) {
        return UITextStorageDirectionForward;
    } else {
        return UITextStorageDirectionBackward;
    }
}

- (void)setSelectionAffinity:(UITextStorageDirection)selectionAffinity {
    _selectedTextRange = [HTextRange rangeWithRange:_selectedTextRange.asRange affinity:selectionAffinity == UITextStorageDirectionForward ? HTextAffinityForward : HTextAffinityBackward];
    [self _updateSelectionView];
}

- (NSDictionary *)textStylingAtPosition:(HTextPosition *)position inDirection:(UITextStorageDirection)direction {
    if (!position) return nil;
    if (_innerText.length == 0) return _typingAttributesHolder.h_attributes;
    NSDictionary *attrs = nil;
    if (0 <= position.offset  && position.offset <= _innerText.length) {
        NSUInteger ofs = position.offset;
        if (position.offset == _innerText.length ||
            direction == UITextStorageDirectionBackward) {
             ofs--;
        }
        attrs = [_innerText attributesAtIndex:ofs effectiveRange:NULL];
    }
    return attrs;
}

- (HTextPosition *)positionWithinRange:(HTextRange *)range atCharacterOffset:(NSInteger)offset {
    if (!range) return nil;
    if (offset < range.start.offset || offset > range.end.offset) return nil;
    if (offset == range.start.offset) return range.start;
    else if (offset == range.end.offset) return range.end;
    else return [HTextPosition positionWithOffset:offset];
}

- (NSInteger)characterOffsetOfPosition:(HTextPosition *)position withinRange:(HTextRange *)range {
    return position ? position.offset : NSNotFound;
}

@end



@interface HTextView(IBInspectableProperties)
@end

@implementation HTextView(IBInspectableProperties)

- (BOOL)fontIsBold_:(UIFont *)font {
    if (![font respondsToSelector:@selector(fontDescriptor)]) return NO;
    return (font.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold) > 0;
}

- (UIFont *)boldFont_:(UIFont *)font {
    if (![font respondsToSelector:@selector(fontDescriptor)]) return font;
    return [UIFont fontWithDescriptor:[font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:font.pointSize];
}

- (UIFont *)normalFont_:(UIFont *)font {
    if (![font respondsToSelector:@selector(fontDescriptor)]) return font;
    return [UIFont fontWithDescriptor:[font.fontDescriptor fontDescriptorWithSymbolicTraits:0] size:font.pointSize];
}

- (void)setFontName_:(NSString *)fontName {
    if (!fontName) return;
    UIFont *font = self.font;
    if (!font) font = [self _defaultFont];
    if ((fontName.length == 0 || [fontName.lowercaseString isEqualToString:@"system"]) && ![self fontIsBold_:font]) {
        font = [UIFont systemFontOfSize:font.pointSize];
    } else if ([fontName.lowercaseString isEqualToString:@"system bold"]) {
        font = [UIFont boldSystemFontOfSize:font.pointSize];
    } else {
        if ([self fontIsBold_:font] && ([fontName.lowercaseString rangeOfString:@"bold"].location == NSNotFound)) {
            font = [UIFont fontWithName:fontName size:font.pointSize];
            font = [self boldFont_:font];
        } else {
            font = [UIFont fontWithName:fontName size:font.pointSize];
        }
    }
    if (font) self.font = font;
}

- (void)setFontSize_:(CGFloat)fontSize {
    if (fontSize <= 0) return;
    UIFont *font = self.font;
    if (!font) font = [self _defaultFont];
    if (!font) font = [self _defaultFont];
    font = [font fontWithSize:fontSize];
    if (font) self.font = font;
}

- (void)setFontIsBold_:(BOOL)fontBold {
    UIFont *font = self.font;
    if (!font) font = [self _defaultFont];
    if ([self fontIsBold_:font] == fontBold) return;
    if (fontBold) {
        font = [self boldFont_:font];
    } else {
        font = [self normalFont_:font];
    }
    if (font) self.font = font;
}

- (void)setPlaceholderFontName_:(NSString *)fontName {
    if (!fontName) return;
    UIFont *font = self.placeholderFont;
    if (!font) font = [self _defaultFont];
    if ((fontName.length == 0 || [fontName.lowercaseString isEqualToString:@"system"]) && ![self fontIsBold_:font]) {
        font = [UIFont systemFontOfSize:font.pointSize];
    } else if ([fontName.lowercaseString isEqualToString:@"system bold"]) {
        font = [UIFont boldSystemFontOfSize:font.pointSize];
    } else {
        if ([self fontIsBold_:font] && ([fontName.lowercaseString rangeOfString:@"bold"].location == NSNotFound)) {
            font = [UIFont fontWithName:fontName size:font.pointSize];
            font = [self boldFont_:font];
        } else {
            font = [UIFont fontWithName:fontName size:font.pointSize];
        }
    }
    if (font) self.placeholderFont = font;
}

- (void)setPlaceholderFontSize_:(CGFloat)fontSize {
    if (fontSize <= 0) return;
    UIFont *font = self.placeholderFont;
    if (!font) font = [self _defaultFont];
    font = [font fontWithSize:fontSize];
    if (font) self.placeholderFont = font;
}

- (void)setPlaceholderFontIsBold_:(BOOL)fontBold {
    UIFont *font = self.placeholderFont;
    if (!font) font = [self _defaultFont];
    if ([self fontIsBold_:font] == fontBold) return;
    if (fontBold) {
        font = [self boldFont_:font];
    } else {
        font = [self normalFont_:font];
    }
    if (font) self.placeholderFont = font;
}

- (void)setInsetTop_:(CGFloat)textInsetTop {
    UIEdgeInsets insets = self.textContainerInset;
    insets.top = textInsetTop;
    self.textContainerInset = insets;
}

- (void)setInsetBottom_:(CGFloat)textInsetBottom {
    UIEdgeInsets insets = self.textContainerInset;
    insets.bottom = textInsetBottom;
    self.textContainerInset = insets;
}

- (void)setInsetLeft_:(CGFloat)textInsetLeft {
    UIEdgeInsets insets = self.textContainerInset;
    insets.left = textInsetLeft;
    self.textContainerInset = insets;
    
}

- (void)setInsetRight_:(CGFloat)textInsetRight {
    UIEdgeInsets insets = self.textContainerInset;
    insets.right = textInsetRight;
    self.textContainerInset = insets;
}

- (void)setDebugEnabled_:(BOOL)enabled {
    if (!enabled) {
        self.debugOption = nil;
    } else {
        HTextDebugOption *debugOption = [HTextDebugOption new];
        debugOption.baselineColor = [UIColor redColor];
        debugOption.CTFrameBorderColor = [UIColor redColor];
        debugOption.CTLineFillColor = [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:0.180];
        debugOption.CGGlyphBorderColor = [UIColor colorWithRed:1.000 green:0.524 blue:0.000 alpha:0.200];
        self.debugOption = debugOption;
    }
}

@end
