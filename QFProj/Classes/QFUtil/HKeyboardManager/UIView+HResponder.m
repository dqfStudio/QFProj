//
//  UIView+HResponder.m
//  HResponseChain
//
//  Created by GuangquanYu on 10/4/18.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "UIView+HResponder.h"
#import <objc/runtime.h>

#define KEY_H_SYSTEMVIEWTYPEARRAY @"HUIView.SystemTypeArray"
#define KEY_H_TAGSTRING @"HUIView.TagString"

@implementation UIView (HResponder)

- (NSString *)hTagString {
    return objc_getAssociatedObject(self, KEY_H_TAGSTRING);
}

- (void)setHTagString:(NSString *)value {
    objc_setAssociatedObject(self, KEY_H_TAGSTRING, value, OBJC_ASSOCIATION_RETAIN);

}

- (BOOL)h_isCanBecomeFirstResponder {
    BOOL isCanBecomeFirstResponder = ([self canBecomeFirstResponder] && [self isUserInteractionEnabled] && ![self isHidden] && [self alpha]!=0.0);
    
    if (isCanBecomeFirstResponder == YES)
    {
        if ([self isKindOfClass:[UITextField class]])
        {
            isCanBecomeFirstResponder = [(UITextField *)self isEnabled];
        }
        else if ([self isKindOfClass:[UITextView class]])
        {
            isCanBecomeFirstResponder = [(UITextView *)self isEditable];
        }
    }
    
    return isCanBecomeFirstResponder;
}

- (NSArray *)h_responderSiblings {
    NSArray *siblings = self.superview.subviews;
    NSMutableArray *tempTextFields = [[NSMutableArray alloc] init];
    
    for (UITextField *textField in siblings)
        if ([textField h_isCanBecomeFirstResponder])
            [tempTextFields addObject:textField];
    
    return tempTextFields;
}

- (NSArray *)h_responderChildViews {
    NSMutableArray *textFields = [[NSMutableArray alloc] init];
    NSArray *subViews = self.subviews;;
    
    for (UITextField *textField in subViews)
    {
        if ([textField h_isCanBecomeFirstResponder])
        {
            [textFields addObject:textField];
        }
        else if (textField.subviews.count)
        {
            [textFields addObjectsFromArray:[textField h_responderChildViews]];
        }
    }

    return textFields;
}

- (UIViewController *)hh_viewController {
    UIResponder *nextResponder =  self;
    
    do
    {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController *)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}

- (UIViewController *)h_topMostController {
    NSMutableArray *controllersHierarchy = [[NSMutableArray alloc] init];
    UIViewController *topController = self.window.rootViewController;

    if (topController)
    {
        [controllersHierarchy addObject:topController];
    }
    while ([topController presentedViewController]) {
        
        topController = [topController presentedViewController];
        [controllersHierarchy addObject:topController];
    }
    UIResponder *matchController = [self hh_viewController];
    while (matchController != nil && [controllersHierarchy containsObject:matchController] == NO)
    {
        do
        {
            matchController = [matchController nextResponder];
            
        } while (matchController != nil && [matchController isKindOfClass:[UIViewController class]] == NO);
    }

    return (UIViewController *)matchController;
}

- (NSArray<NSString *> *)hSystemTypeArray {
    if (!objc_getAssociatedObject(self, KEY_H_SYSTEMVIEWTYPEARRAY)) {
        NSString * UITextField0 = @"_UITextFieldContentView";
        self.hSystemTypeArray = @[UITextField0];
    }
    return objc_getAssociatedObject(self, KEY_H_SYSTEMVIEWTYPEARRAY);
}

- (void)setHSystemTypeArray:(NSArray<NSString *> *)hSystemTypeArray {
    objc_setAssociatedObject(self, KEY_H_SYSTEMVIEWTYPEARRAY, hSystemTypeArray, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)h_isSystemType:(Class)class{
    NSString * classStr = NSStringFromClass(class);
    for (int i=0; i<self.hSystemTypeArray.count; i++) {
        if ([classStr isEqualToString:self.hSystemTypeArray[i]]) {
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray *)h_findSonViewByClass:(Class)type mutableArray:(NSMutableArray *)sonViews isMember:(BOOL)isMember{
    UIView * superview = self;
    for (UIView *subview in superview.subviews) {
        if ([subview.subviews count] > 0) {
            [subview h_findSonViewByClass:type mutableArray:sonViews isMember:isMember];
        }
        if (isMember) {
            if ([subview  isMemberOfClass:type]) {
                [sonViews addObject:subview];
            }
        } else {
            if ([subview  isKindOfClass:type]) {
                BOOL isSystemType = [self h_isSystemType:[subview class]];
                if (!isSystemType) {
                    [sonViews addObject:subview];
                }
            }
        }
    }
    return sonViews;
}

- (UIView *)h_findFatherViewByClass:(Class)type isMember:(BOOL)isMember{
    
    UIView * subview = self;
    UIView * superView = subview;
    int i = 0;
    while (superView) {
        if (isMember) {
            if ([superView.superview  isMemberOfClass:type]) {
                superView = superView.superview;
                break;
            }else{
                if ([superView.superview isKindOfClass:[UIView class]]) {
                    superView = superView.superview;
                }else{
                    superView = nil;
                    break;
                }
            }
        } else {
            BOOL isSystemType = [self h_isSystemType:[superView.superview class]];
            if ([superView.superview  isKindOfClass:type]&&!isSystemType) {
                superView = superView.superview;
                break;
            }else{
                if ([superView.superview isKindOfClass:[UIView class]]) {
                    superView = superView.superview;
                }else{
                    superView = nil;
                    break;
                }
            }
        }
        i ++;
    }
    return superView;
    
}

- (NSMutableArray *)h_findFatherViewByClass:(Class)type mutableArray:(NSMutableArray *)fatherViews isMember:(BOOL)isMember{
    UIView * fatherV = self;
    while (fatherV && [fatherV isKindOfClass:[UIView class]]) {
        UIView * fatherV1 = [fatherV h_findFatherViewByClass:type isMember:isMember];
        if (fatherV && [fatherV isKindOfClass:type]) {
            [fatherViews addObject:fatherV];
        }
        fatherV = fatherV1;
    }
    
    return fatherViews;
}

- (NSInteger)h_depth {
    NSInteger depth = 0;
    
    if ([self superview])
    {
        depth = [[self superview] h_depth] + 1;
    }
    
    return depth;
}
@end


@implementation UIWindow (HResponder2)

+ (UIWindow *)h_getWindow{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

+ (UIViewController *)h_getWindowRootVC {
    UIViewController *result = nil;
    UIWindow * window = [self h_getWindow];
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

+ (UIViewController *)h_getRootViewController{
    UIViewController * rootVC = [self h_getWindowRootVC];
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *)rootVC;
        if (nav.childViewControllers.count > 0) {
            rootVC = nav.childViewControllers[0];
        }
    }
    return rootVC;
}

+ (UIViewController *)h_topMostController {
    UIViewController *topController = [self h_getRootViewController];
    while ([topController presentedViewController])    topController = [topController presentedViewController];
    return topController;
}

+ (UIViewController *)h_topMostControllerForStack {
    UIViewController *topController = [self h_getWindowRootVC];
    while ([topController presentedViewController])    topController = [topController presentedViewController];
    return topController;
}

+ (UINavigationController *)h_topMostNavigationController {
    UIViewController *topController = [self h_getWindowRootVC];
    if ([topController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)topController;
    }
    topController = [self h_getRootViewController];
    while ([topController presentedViewController]) {
        topController = [topController presentedViewController];
        if ([topController isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)topController;
        }
    }
    return nil;
}

+ (UIViewController *)h_currentNavigationViewController; {
    UIViewController *currentViewController = nil;
    if ([self h_topMostNavigationController]) {
        currentViewController = [self h_topMostNavigationController];
        
        while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController *)currentViewController topViewController])
            currentViewController = [(UINavigationController *)currentViewController topViewController];
    } else {
        currentViewController = [self h_topMostController];
    }
    return currentViewController;
}

+ (UIViewController *)h_currentViewController{
    UIViewController *currentViewController = [self h_currentNavigationViewController];
    while ([currentViewController presentedViewController])    currentViewController = [currentViewController presentedViewController];
    return currentViewController;
}

@end
