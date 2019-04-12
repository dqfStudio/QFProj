//
//  UIViewController+HBackHandler.m
//  Vivi
//
//  Created by dqf on 5/27/15.
//  Copyright (c) 2015 socool. All rights reserved.
//

#import "UIViewController+HBackHandler.h"
#import <objc/runtime.h>

@implementation UIViewController (HBackHandler)

@end

@implementation UINavigationController (HBackHandler)
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem*)item {
    if([self.viewControllers count] < [navigationBar.items count]) return YES;
    BOOL shouldPop = YES;
    UIViewController *vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    }else {
        for(UIView *subview in [navigationBar subviews]) {
            if(subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return NO;
}
@end
