//
//  HRichLabelAttribute.m
//  HRichLabel
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HRichLabelAttribute.h"
#import "HRichLabelText.h"

NSString *const HTextTruncationToken = @"\u2026";
NSString *const HTextAttachmentToken = @"\uFFFC";

NSString *const HTextAttachmentAttributeKey = @"HTextAttachmentAttributeKey";
NSString *const HTextSingleTapAttributeKey = @"HTextSingleTapAttributeKey";
NSString *const HTextLongPressAttributeKey = @"HTextLongPressAttributeKey";

NSString *const HTextHighlightAttributeKey = @"HTextHighlightAttributeKey";
NSString *const HTextBorderAttributeKey = @"HTextBorderAttributeKey";


@implementation HTextInfo
@end


@implementation HTextInfoContainer {
    NSMutableArray<NSAttributedString *> *_mutableTexts;
    NSMutableArray<NSValue *> *_mutableRects;
    NSMutableArray<NSValue *> *_mutableRanges;
    
    NSMutableDictionary<NSString *, HTextAttachment *> *_mutableAttachmentDict;
    NSMutableDictionary<NSString *, HTextBlock> *_mutableSingleTapDict;
    NSMutableDictionary<NSString *, HTextBlock> *_mutableLongPressDict;
    
    NSMutableDictionary<NSString *, HTextHighlight *> *_mutableHighlightDict;
    NSMutableDictionary<NSString *, HTextBorder *> *_mutableBorderDict;
}

#pragma mark - public

+ (instancetype)infoContainer {
    HTextInfoContainer *one = [HTextInfoContainer new];
    one->_mutableTexts = @[].mutableCopy;
    one->_mutableRects = @[].mutableCopy;
    one->_mutableRanges = @[].mutableCopy;
    
    one->_mutableAttachmentDict = @{}.mutableCopy;
    one->_mutableSingleTapDict = @{}.mutableCopy;
    one->_mutableLongPressDict = @{}.mutableCopy;
    
    one->_mutableHighlightDict = @{}.mutableCopy;
    one->_mutableBorderDict = @{}.mutableCopy;
    return one;
}

- (void)addObjectFromInfo:(HTextInfo *)info {
    [_mutableTexts addObject:info.text];
    [_mutableRects addObject:info.rectValue];
    [_mutableRanges addObject:info.rangeValue];
    
    NSString *key = NSStringFromCGRect(_mutableRects.lastObject.CGRectValue);
    if (info.attachment) {
        [_mutableAttachmentDict setValue:info.attachment forKey:key];
    }
    if (info.singleTap) {
        [_mutableSingleTapDict setValue:[info.singleTap copy] forKey:key];
    }
    if (info.longPress) {
        [_mutableLongPressDict setValue:[info.longPress copy] forKey:key];
    }
    if (info.highlight) {
        [_mutableHighlightDict setValue:info.highlight forKey:key];
    }
    if (info.border) {
        [_mutableBorderDict setValue:info.border forKey:key];
    }
}

- (void)addObjectFromInfoContainer:(HTextInfoContainer *)infoContainer {
    [_mutableTexts addObjectsFromArray:infoContainer.texts];
    [_mutableRects addObjectsFromArray:infoContainer.rects];
    [_mutableRanges addObjectsFromArray:infoContainer.ranges];
    
    if (infoContainer.attachmentDict) {
        [_mutableAttachmentDict addEntriesFromDictionary:infoContainer.attachmentDict];
    }
    if (infoContainer.singleTapDict) {
        [_mutableSingleTapDict addEntriesFromDictionary:infoContainer.singleTapDict];
    }
    if (infoContainer.longPressDict) {
        [_mutableLongPressDict addEntriesFromDictionary:infoContainer.longPressDict];
    }
    if (infoContainer.highlightDict) {
        [_mutableHighlightDict addEntriesFromDictionary:infoContainer.highlightDict];
    }
    if (infoContainer.borderDict) {
        [_mutableBorderDict addEntriesFromDictionary:infoContainer.borderDict];
    }
}

- (BOOL)canResponseUserActionAtPoint:(CGPoint)point {
    __block BOOL canResponse = NO;
    if (self.rects.count > 0) {
        [self.rects enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = obj.CGRectValue;
            
            if (CGRectContainsPoint(rect, point)) {
                *stop = YES;
                canResponse = YES;
                
                HTextInfo *info = [HTextInfo new];
                info.text = self.texts[idx];
                info.rectValue = obj;
                info.rangeValue = self.ranges[idx];
                
                NSString *key = NSStringFromCGRect(rect);
                info.attachment = self.attachmentDict[key];
                info.singleTap = self.singleTapDict[key];
                info.longPress = self.longPressDict[key];
                info.highlight = self.highlightDict[key];
                info.border = self.borderDict[key];
                
                self->_responseInfo = info;
            }
        }];
        return canResponse;
    }
    return canResponse;
}

#pragma mark - properties

- (NSArray<NSAttributedString *> *)texts {
    return _mutableTexts;
}

- (NSArray<NSValue *> *)rects {
    return _mutableRects;
}

- (NSArray<NSValue *> *)ranges {
    return _mutableRanges;
}

- (NSDictionary<NSString *,HTextAttachment *> *)attachmentDict {
    return _mutableAttachmentDict;
}

- (NSDictionary<NSString *,HTextBlock> *)singleTapDict {
    return _mutableSingleTapDict;
}

- (NSDictionary<NSString *,HTextBlock> *)longPressDict {
    return _mutableLongPressDict;
}

- (NSDictionary<NSString *,HTextHighlight *> *)highlightDict {
    return _mutableHighlightDict;
}

- (NSDictionary<NSString *,HTextBorder *> *)borderDict {
    return _mutableBorderDict;
}

@end


@implementation HTextBorder
+ (instancetype)defaultBorder {
    HTextBorder *one = [HTextBorder new];
    one->_width = 1.f;
    one->_color = [UIColor blackColor];
    one->_cornerRadius = 5.f;
    one->_insets = UIEdgeInsetsZero;
    return one;
}

+ (instancetype)borderWithWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    HTextBorder *one = [HTextBorder defaultBorder];
    if (width >= 0.f) one->_width = width;
    if (cornerRadius >= 0.f) one->_cornerRadius = cornerRadius;
    one->_color = color;
    return one;
}

@end


@implementation HTextHighlight
@end



@implementation HTextAttachment {
    CGFloat _fontAsent;
    CGFloat _fontDesent;
}


#pragma mark - rundelegate

static void HTextRunDelegateDeallocCallback(void *ref) {
//    NSLog(@"%s", __func__);
}

static CGFloat HTextRunDelegateGetAscentCallback(void *ref) {
    HTextAttachment *attachment = (__bridge HTextAttachment *)ref;
    return attachment.runDelegateAsent;
}

static CGFloat HTextRunDelegateGetDescentCallback(void *ref) {
    HTextAttachment *attachment = (__bridge HTextAttachment *)ref;
    return attachment.runDelegateDesent;
}

static CGFloat HTextRunDelegateGetWidthCallback(void *ref) {
    HTextAttachment *attachment = (__bridge HTextAttachment *)ref;
    return attachment.runDelegateWidth;
}

#pragma mark - public
+ (instancetype)attachmentWithContent:(id)content
                          contentSize:(CGSize)contentSize
                          alignToFont:(nullable UIFont *)font {
    HTextAttachment *attachment = [[self alloc] init];
    attachment->_content = content;
    attachment->_contentSize = contentSize;

    if (!font) font = [UIFont systemFontOfSize:15.f];
    attachment->_fontAsent = font.ascender;
    attachment->_fontDesent = font.descender;

    [attachment _initAttachment];
    return attachment;
}

- (CTRunDelegateRef)runDelegate {
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = HTextRunDelegateDeallocCallback;
    callbacks.getAscent = HTextRunDelegateGetAscentCallback;
    callbacks.getDescent = HTextRunDelegateGetDescentCallback;
    callbacks.getWidth = HTextRunDelegateGetWidthCallback;
    return CTRunDelegateCreate(&callbacks, (__bridge void *)self);
}

#pragma mark - override


#pragma mark - private
- (void)_initAttachment {
    _alignment = HTextAttachmentAlignmentCenter;
    [self _update];
}

- (void)_update {
    switch (_alignment) {
        case HTextAttachmentAlignmentTop: {
            _runDelegateAsent = _fontAsent;
            _runDelegateDesent = _contentSize.height - _fontAsent;

            [self _correct];
        } break;
        case HTextAttachmentAlignmentBottom: {
            _runDelegateAsent = _contentSize.height + _fontDesent;

            _runDelegateDesent = -_fontDesent;
            [self _correct];
        } break;
        default: {
            CGFloat fontHeight = _fontAsent - _fontDesent;
            CGFloat yOffset = _fontAsent - fontHeight * 0.5;
            _runDelegateAsent = _contentSize.height * 0.5 + yOffset;

            _runDelegateDesent = _contentSize.height - _runDelegateAsent;

            [self _correct];
        } break;
    }
    _runDelegateWidth = _contentSize.width;
}

- (void)_correct {
    if (_runDelegateDesent < 0) {
        _runDelegateDesent = 0;
        _runDelegateAsent = _contentSize.height;
    }
}

@end

