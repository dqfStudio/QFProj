//
//  UIViewController+Animation.h
//  KYProjectModel
//
//  Created by TX-Kevin on 2019/12/14.
//  Copyright © 2019 admin. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HTransitionAnimation.h"
#import "HPresentAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Animation)
/**
  动画管理类(Present、Dismiss)
 */
@property (nonatomic, nullable) HPresentAnimation *presentAnimation;
/**
  动画管理类(Push、Pop)
 */
@property (nonatomic, nullable) HTransitionAnimation *transitionAnimation;

#pragma mark - Present、Dismiss -> Alert
/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 completion     动画结束后的回调
*/
- (void)presentAlertController:(UIViewController *)viewController contentSize:(CGSize)aSize completion:(HAnimationCompletion __nullable)completion;

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 shadowColor    蒙层颜色
 completion     动画结束后的回调
*/
- (void)presentAlertController:(UIViewController *)viewController contentSize:(CGSize)aSize shadowColor:(UIColor *__nullable)aColor completion:(HAnimationCompletion __nullable)completion;

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 duration       动画时间
 shadowColor    蒙层颜色
 shadowDismiss  点击阴影是否dismiss当前页面
 completion     动画结束后的回调
*/
- (void)presentAlertController:(UIViewController *)viewController contentSize:(CGSize)aSize animationDuration:(NSTimeInterval)duration shadowColor:(UIColor *__nullable)aColor shadowDismiss:(BOOL)isShadowDismiss completion:(HAnimationCompletion __nullable)completion;

#pragma mark - Present、Dismiss -> Sheet
/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 completion     动画结束后的回调
*/
- (void)presentSheetController:(UIViewController *)viewController contentSize:(CGSize)aSize completion:(HAnimationCompletion __nullable)completion;

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 shadowColor    蒙层颜色
 completion     动画结束后的回调
 */
- (void)presentSheetController:(UIViewController *)viewController contentSize:(CGSize)aSize shadowColor:(UIColor *__nullable)aColor completion:(HAnimationCompletion __nullable)completion;

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 duration       动画时间
 shadowColor    蒙层颜色
 shadowDismiss  点击阴影是否dismiss当前页面
 completion     动画结束后的回调
 */
- (void)presentSheetController:(UIViewController *)viewController contentSize:(CGSize)aSize animationDuration:(NSTimeInterval)duration shadowColor:(UIColor *__nullable)aColor shadowDismiss:(BOOL)isShadowDismiss completion:(HAnimationCompletion __nullable)completion;

#pragma mark - Push、Pop
/*
 viewController 要显示的控制器
 completion     动画结束后的回调
*/
- (void)pushViewController:(UIViewController *)viewController completion:(HAnimationCompletion __nullable)completion;

@end

NS_ASSUME_NONNULL_END
