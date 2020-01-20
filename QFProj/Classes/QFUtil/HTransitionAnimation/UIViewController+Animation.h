//
//  UIViewController+Animation.h
//  QFProj
//
//  Created by dqf on 2019/12/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPresentAnimation.h"
#import "HPushAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Animation)

#pragma mark - Present、Dismiss -> Alert
#pragma mark -
/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 completion     动画结束后的回调
*/
- (void)presentAlertController:(UIViewController *)viewController contentSize:(CGSize)aSize completion:(HTransitionCompletion __nullable)completion;

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 shadowColor    蒙层颜色
 completion     动画结束后的回调
*/
- (void)presentAlertController:(UIViewController *)viewController contentSize:(CGSize)aSize shadowColor:(UIColor *__nullable)aColor completion:(HTransitionCompletion __nullable)completion;

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 shadowColor    蒙层颜色
 shadowDismiss  点击阴影是否dismiss当前页面
 completion     动画结束后的回调
*/
- (void)presentAlertController:(UIViewController *)viewController contentSize:(CGSize)aSize shadowColor:(UIColor *__nullable)aColor shadowDismiss:(BOOL)isShadowDismiss completion:(HTransitionCompletion __nullable)completion;

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 duration       动画时间
 shadowColor    蒙层颜色
 shadowDismiss  点击阴影是否dismiss当前页面
 completion     动画结束后的回调
*/
- (void)presentAlertController:(UIViewController *)viewController contentSize:(CGSize)aSize animationDuration:(NSTimeInterval)duration shadowColor:(UIColor *__nullable)aColor shadowDismiss:(BOOL)isShadowDismiss completion:(HTransitionCompletion __nullable)completion;


#pragma mark - Present、Dismiss -> Sheet
#pragma mark -
/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 completion     动画结束后的回调
*/
- (void)presentSheetController:(UIViewController *)viewController contentSize:(CGSize)aSize completion:(HTransitionCompletion __nullable)completion;

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 shadowColor    蒙层颜色
 completion     动画结束后的回调
 */
- (void)presentSheetController:(UIViewController *)viewController contentSize:(CGSize)aSize shadowColor:(UIColor *__nullable)aColor completion:(HTransitionCompletion __nullable)completion;

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 shadowColor    蒙层颜色
 shadowDismiss  点击阴影是否dismiss当前页面
 completion     动画结束后的回调
 */
- (void)presentSheetController:(UIViewController *)viewController contentSize:(CGSize)aSize shadowColor:(UIColor *__nullable)aColor shadowDismiss:(BOOL)isShadowDismiss completion:(HTransitionCompletion __nullable)completion;

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 duration       动画时间
 shadowColor    蒙层颜色
 shadowDismiss  点击阴影是否dismiss当前页面
 completion     动画结束后的回调
 */
- (void)presentSheetController:(UIViewController *)viewController contentSize:(CGSize)aSize animationDuration:(NSTimeInterval)duration shadowColor:(UIColor *__nullable)aColor shadowDismiss:(BOOL)isShadowDismiss completion:(HTransitionCompletion __nullable)completion;

#pragma mark - Push、Pop
#pragma mark -
/*
 viewController 要显示的控制器
 completion     动画结束后的回调
*/
- (void)pushViewController:(UIViewController *)viewController completion:(HTransitionCompletion __nullable)completion;

@end

NS_ASSUME_NONNULL_END
