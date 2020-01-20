//
//  UIViewController+Animation.m
//  QFProj
//
//  Created by dqf on 2019/12/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import "UIViewController+Animation.h"
#import <objc/runtime.h>

@interface UIViewController (HTransition)
//动画管理类(Present、Dismiss)
@property (nonatomic, nullable) HPresentAnimation *presentAnimation;
//动画管理类(Push、Pop)
@property (nonatomic, nullable) HPushAnimation *pushAnimation;
@end

@implementation UIViewController (HTransition)

#pragma mark - 通过runtime 动态添加属性
#pragma mark -
//Present、Dismiss 动画类
- (HPresentAnimation *)presentAnimation {
    return  objc_getAssociatedObject(self, _cmd);
}
- (void)setPresentAnimation:(HPresentAnimation *)presentAnimation {
    objc_setAssociatedObject(self, @selector(presentAnimation), presentAnimation, OBJC_ASSOCIATION_RETAIN);
}
//Push、Pop 开门动画效果
- (HPushAnimation *)pushAnimation {
    return  objc_getAssociatedObject(self, _cmd);
}
- (void)setPushAnimation:(HPushAnimation *)pushAnimation {
    objc_setAssociatedObject(self, @selector(pushAnimation), pushAnimation, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - UINavigationControllerDelegate
#pragma mark -
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        self.pushAnimation.transitionType = HTransitionTypePush;
        return self.pushAnimation;
    }else if (operation == UINavigationControllerOperationPop) {
        self.pushAnimation.transitionType = HTransitionTypePop;
        return self.pushAnimation;
    }
    return nil;
}
@end

@implementation UIViewController (Animation)

#pragma mark - Present、Dismiss -> Alert
#pragma mark -
/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 completion     动画结束后的回调
*/
- (void)presentAlertController:(UIViewController *)viewController contentSize:(CGSize)aSize completion:(HTransitionCompletion __nullable)completion {
    [self presentAlertController:viewController contentSize:aSize shadowColor:nil completion:completion];
}

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 shadowColor    蒙层颜色
 completion     动画结束后的回调
*/
- (void)presentAlertController:(UIViewController *)viewController contentSize:(CGSize)aSize shadowColor:(UIColor *__nullable)aColor completion:(HTransitionCompletion __nullable)completion {
    [self presentAlertController:viewController contentSize:aSize animationDuration:0.25 shadowColor:aColor shadowDismiss:NO completion:completion];
}

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 shadowColor    蒙层颜色
 shadowDismiss  点击阴影是否dismiss当前页面
 completion     动画结束后的回调
*/
- (void)presentAlertController:(UIViewController *)viewController contentSize:(CGSize)aSize shadowColor:(UIColor *__nullable)aColor shadowDismiss:(BOOL)isShadowDismiss completion:(HTransitionCompletion __nullable)completion {
   [self presentAlertController:viewController contentSize:aSize animationDuration:0.25 shadowColor:aColor shadowDismiss:isShadowDismiss completion:completion];
}

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 duration       动画时间
 shadowColor    蒙层颜色
 shadowDismiss  点击阴影是否dismiss当前页面
 completion     动画结束后的回调
*/
- (void)presentAlertController:(UIViewController *)viewController contentSize:(CGSize)aSize animationDuration:(NSTimeInterval)duration shadowColor:(UIColor *__nullable)aColor shadowDismiss:(BOOL)isShadowDismiss completion:(HTransitionCompletion __nullable)completion {
   HPresentAnimation *animation = HPresentAnimation.new;
   animation.presetType = HTransitionStyleAlert;
   animation.contentSize = aSize;
   animation.transitionDuration = duration;
   animation.shadowColor = aColor;
   animation.isShadowDismiss = isShadowDismiss;
   animation.transitionCompletion = completion;
   [self presentedViewController:viewController animation:animation];
}

#pragma mark - Present、Dismiss -> Sheet
#pragma mark -
/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 completion     动画结束后的回调
*/
- (void)presentSheetController:(UIViewController *)viewController contentSize:(CGSize)aSize completion:(HTransitionCompletion __nullable)completion {
    [self presentSheetController:viewController contentSize:aSize shadowColor:nil completion:completion];
}

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 shadowColor    蒙层颜色
 completion     动画结束后的回调
 */
- (void)presentSheetController:(UIViewController *)viewController contentSize:(CGSize)aSize shadowColor:(UIColor *__nullable)aColor completion:(HTransitionCompletion __nullable)completion {
    [self presentSheetController:viewController contentSize:aSize animationDuration:0.25 shadowColor:aColor shadowDismiss:NO completion:completion];
}

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 shadowColor    蒙层颜色
 shadowDismiss  点击阴影是否dismiss当前页面
 completion     动画结束后的回调
 */
- (void)presentSheetController:(UIViewController *)viewController contentSize:(CGSize)aSize shadowColor:(UIColor *__nullable)aColor shadowDismiss:(BOOL)isShadowDismiss completion:(HTransitionCompletion __nullable)completion {
    [self presentSheetController:viewController contentSize:aSize animationDuration:0.25 shadowColor:aColor shadowDismiss:isShadowDismiss completion:completion];
}

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 duration       动画时间
 shadowColor    蒙层颜色
 shadowDismiss  点击阴影是否dismiss当前页面
 completion     动画结束后的回调
 */
- (void)presentSheetController:(UIViewController *)viewController contentSize:(CGSize)aSize animationDuration:(NSTimeInterval)duration shadowColor:(UIColor *__nullable)aColor shadowDismiss:(BOOL)isShadowDismiss completion:(HTransitionCompletion __nullable)completion {
    HPresentAnimation *animation = HPresentAnimation.new;
    animation.presetType = HTransitionStyleSheet;
    animation.contentSize = aSize;
    animation.transitionDuration = duration;
    animation.shadowColor = aColor;
    animation.isShadowDismiss = isShadowDismiss;
    animation.transitionCompletion = completion;
    [self presentedViewController:viewController animation:animation];
}

#pragma mark - 私有方式
#pragma mark -
- (void)presentedViewController:(UIViewController*)viewController animation:(HPresentAnimation *)animation {
    if(animation) {
        self.presentAnimation = animation;
        viewController.modalPresentationStyle = UIModalPresentationCustom; //设置目标vc的动画为自定义
        viewController.transitioningDelegate = animation; //设置动画管理代理类
    }
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - Push、Pop
#pragma mark -
/*
 viewController 要显示的控制器
 completion     动画结束后的回调
*/
- (void)pushViewController:(UIViewController *)viewController completion:(HTransitionCompletion)completion {
    HPushAnimation *animation = HPushAnimation.new;
    animation.transitionCompletion = completion;
    self.pushAnimation = animation;
    UINavigationController *navigationVC = nil;
    if([self isKindOfClass:UINavigationController.class]) {
        navigationVC = (UINavigationController*)self;
    }else {
        navigationVC = viewController.navigationController;
    }
    navigationVC.delegate = (id<UINavigationControllerDelegate>)self;
    [navigationVC pushViewController:viewController animated:YES];
}

@end
