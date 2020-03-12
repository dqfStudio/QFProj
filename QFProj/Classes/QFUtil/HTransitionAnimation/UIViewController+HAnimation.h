//
//  UIViewController+HAnimation.h
//  QFProj
//
//  Created by dqf on 2019/12/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+HTransition.h"
#import "HPresentAnimation.h"
#import "HPushAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HAnimation)

#pragma mark - Present、Dismiss -> Alert、Sheet
#pragma mark -
/*
 viewController 要显示的控制器
 completion     动画结束后的回调
*/
- (void)presentController:(UIViewController *)viewController completion:(HTransitionCompletion __nullable)completion;

#pragma mark - Push、Pop
#pragma mark -
/*
 viewController 要显示的控制器
 animationType  动画类型
 completion     动画结束后的回调
*/
- (void)pushViewController:(UIViewController *)viewController completion:(HTransitionCompletion)completion;

@end

NS_ASSUME_NONNULL_END
