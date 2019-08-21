//
//  HKeyboardManager+HToolBar.m
//
//  Created by Guangquan Yu on 2018/4/13.
//  Copyright © 2018年 YUGQ. All rights reserved.
//

#import "HKeyboardManager+HToolBar.h"
#import "NSArray+HSort.h"
#import <objc/runtime.h>
#import "UIView+HResponder.h"
#import "UIView+HKBToolBar.h"

#define DEF_H_TAGSTRING @"HKeyboardManager.ToolBar"
#define KEY_H_KBSORTTYPE @"HKeyboardManager.SortType"

@implementation HKeyboardManager (HToolBar)

- (NSInteger)sortType {
    return ((NSNumber *)objc_getAssociatedObject(self, KEY_H_KBSORTTYPE)).integerValue;

}

- (void)setSortType:(NSInteger)sortType {
    objc_setAssociatedObject(self, KEY_H_KBSORTTYPE, [NSNumber numberWithInteger:sortType], OBJC_ASSOCIATION_RETAIN);
}

- (void)h_addToolbarIfRequired {
    NSArray * responderViews = [self h_getResponderViews];
    if (responderViews.count==1)
    {
        UITextField *textEditView = responderViews[0];
        if ([textEditView respondsToSelector:@selector(setInputAccessoryView:)] && ((![textEditView inputAccessoryView]) || [textEditView.inputAccessoryView.hTagString isEqualToString:DEF_H_TAGSTRING]))
        {
            textEditView.inputAccessoryView.hTagString = DEF_H_TAGSTRING;
            [textEditView h_addDoneOnKeyboardWithTarget:self action:@selector(doneAction:) titleText:textEditView.placeholder];
        }
    }
    else if(responderViews.count > 1)
    {
        for (UITextField *textEditView in responderViews)
        {
            if ([textEditView respondsToSelector:@selector(setInputAccessoryView:)] && ((![textEditView inputAccessoryView]) || [textEditView.inputAccessoryView.hTagString isEqualToString:DEF_H_TAGSTRING]))
            {
                textEditView.inputAccessoryView.hTagString = DEF_H_TAGSTRING;
                [textEditView h_addPreviousNextRightOnKeyboardWithTarget:self previousAction:@selector(previousAction:) nextAction:@selector(nextAction:) rightButtonAction:@selector(doneAction:) titleText:textEditView.placeholder];
            }
            if ([responderViews objectAtIndex:0] == textEditView)
            {
                [textEditView h_setEnablePrevious:NO next:YES];
            }
            else if ([responderViews lastObject] == textEditView) 
            {
                [textEditView h_setEnablePrevious:YES next:NO];
            }
            else
            {
                [textEditView h_setEnablePrevious:YES next:YES];
            }
        }
    }
}

- (void)h_removeToolbarIfRequired {
    NSArray *responderViews = [self h_getResponderViews];
    
    for (UITextField *textEditView in responderViews)
    {
        UIView *toolbar = [textEditView inputAccessoryView];

        if ([textEditView respondsToSelector:@selector(setInputAccessoryView:)] && ([toolbar.hTagString isEqualToString:DEF_H_TAGSTRING]))
        {
            textEditView.inputAccessoryView = nil;
        }
    }
}

- (void)h_reloadInputViews {
    NSArray *responderViews = [self h_getResponderViews];
    
    for (UITextField *textEditView in responderViews)
    {
        if ([responderViews objectAtIndex:0] == textEditView)
        {
            if (responderViews.count == 1)
            {
                [textEditView h_setEnablePrevious:NO next:NO];
            }
            else
            {
                [textEditView h_setEnablePrevious:NO next:YES];
            }
        }
        else if ([responderViews lastObject] == textEditView)
        {
            [textEditView h_setEnablePrevious:YES next:NO];
        }
        else
        {
            [textEditView h_setEnablePrevious:YES next:YES];
        }
    }
}

- (void)previousAction:(id)segmentedControl {
    if ([self h_canGoPrevious]) {
        [self h_goPrevious];
    }
}

- (void)nextAction:(id)segmentedControl {
    if ([self h_canGoNext]) {
        [self h_goNext];
    }
}

- (void)doneAction:(id)barButton {
    [self.textEditView resignFirstResponder];
}

- (NSArray*)h_getResponderViews {
    return [self h_getResponderViewsWithDeep:YES sortType:self.sortType];
}

- (NSArray*)h_getResponderViewsWithDeep:(BOOL)isDeep sortType:(NSInteger)sortType {
    NSArray * editViews = nil;
    if (isDeep) {
        UIScrollView * scrollView = (UIScrollView *)[self.textEditView h_findFatherViewByClass:[UIScrollView class] isMember:NO];
        UIViewController * vc = [self.textEditView hh_viewController];
        if (scrollView && [scrollView isKindOfClass:[UIScrollView class]]) {
            editViews = [scrollView h_responderChildViews];
        } else if (vc && [vc isKindOfClass:[UIViewController class]]) {
            editViews = [vc.view h_responderChildViews];
        } else {
            editViews = [self.textEditView h_responderChildViews];
        }
    } else {
        editViews = [self.textEditView h_responderSiblings];
    }
    return [editViews h_sortedUIViewArrayByPositionForWindow];;
}

- (BOOL)h_canGoPrevious {
    NSArray *textFields = [self h_getResponderViews];
    NSUInteger index = [textFields indexOfObject:self.textEditView];
    if (index != NSNotFound && index > 0)
        return YES;
    else
        return NO;
}

- (BOOL)h_canGoNext {
    NSArray *textFields = [self h_getResponderViews];
    NSUInteger index = [textFields indexOfObject:self.textEditView];
    if (index != NSNotFound && index < textFields.count-1)
        return YES;
    else
        return NO;
}

- (BOOL)h_goPrevious {
    NSArray *textFields = [self h_getResponderViews];
    NSUInteger index = [textFields indexOfObject:self.textEditView];
    if (index != NSNotFound && index > 0)
    {
        UITextField *nextTextField = [textFields objectAtIndex:index-1];
        UIView *textFieldRetain = self.textEditView;
        BOOL isAcceptAsFirstResponder = [nextTextField becomeFirstResponder];
        if (isAcceptAsFirstResponder == NO)
        {
            [textFieldRetain becomeFirstResponder];
            return NO;
        }
        return YES;
    }
    return NO;
}

- (BOOL)h_goNext {
    NSArray *textFields = [self h_getResponderViews];
    NSUInteger index = [textFields indexOfObject:self.textEditView];
    if (index != NSNotFound && index < textFields.count-1)
    {
        UITextField *nextTextField = [textFields objectAtIndex:index+1];
        UIView *textFieldRetain = self.textEditView;
        BOOL isAcceptAsFirstResponder = [nextTextField becomeFirstResponder];
        if (isAcceptAsFirstResponder == NO)
        {
            [textFieldRetain becomeFirstResponder];
            return NO;
        }
        return YES;
    }
    return NO;
}

@end
