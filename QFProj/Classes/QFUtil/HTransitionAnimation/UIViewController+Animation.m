//
//  UIViewController+Animation.m
//  KYProjectModel
//
//  Created by TX-Kevin on 2019/12/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import "UIViewController+Animation.h"
#import <objc/runtime.h>

@implementation UIViewController (Animation)

#pragma mark - 通过runtime 动态添加属性
/**
 * Present、Dismiss 动画类
*/
- (HPresentAnimation *)presentAnimation {
    return  objc_getAssociatedObject(self, _cmd);
}
- (void)setPresentAnimation:(HPresentAnimation *)presentAnimation {
    objc_setAssociatedObject(self, @selector(presentAnimation), presentAnimation, OBJC_ASSOCIATION_RETAIN);
}
/**
 * Push、Pop 开门动画效果
*/
- (HTransitionAnimation *)transitionAnimation {
    return  objc_getAssociatedObject(self, _cmd);
}
- (void)setTransitionAnimation:(HTransitionAnimation *)transitionAnimation {
    objc_setAssociatedObject(self, @selector(transitionAnimation), transitionAnimation, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Present、Dismiss -> Alert
/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 completion     动画结束后的回调
*/
- (void)presentAlertController:(UIViewController *)viewController contentSize:(CGSize)aSize completion:(HAnimationCompletion __nullable)completion {
    [self presentAlertController:viewController contentSize:aSize shadowColor:nil completion:completion];
}

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 shadowColor    蒙层颜色
 completion     动画结束后的回调
*/
- (void)presentAlertController:(UIViewController *)viewController contentSize:(CGSize)aSize shadowColor:(UIColor *__nullable)aColor completion:(HAnimationCompletion __nullable)completion {
    [self presentAlertController:viewController contentSize:aSize animationDuration:0.25 shadowColor:aColor shadowDismiss:YES completion:completion];
}

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 duration       动画时间
 shadowColor    蒙层颜色
 shadowDismiss  点击阴影是否dismiss当前页面
 completion     动画结束后的回调
*/
- (void)presentAlertController:(UIViewController *)viewController contentSize:(CGSize)aSize animationDuration:(NSTimeInterval)duration shadowColor:(UIColor *__nullable)aColor shadowDismiss:(BOOL)isShadowDismiss completion:(HAnimationCompletion __nullable)completion {
   HPresentAnimation *animation = HPresentAnimation.new;
   animation.presetType  = HTransitionPresentTypeAlert;
   animation.contentSize = aSize;
   animation.animationDuration = duration;
   animation.shadowColor = aColor;
   animation.isShadowDismiss  = isShadowDismiss;
   animation.animationCompletion = completion;
   [self presentedViewController:viewController animation:animation];
}

#pragma mark - Present、Dismiss -> Sheet
/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 completion     动画结束后的回调
*/
- (void)presentSheetController:(UIViewController *)viewController contentSize:(CGSize)aSize completion:(HAnimationCompletion __nullable)completion {
    [self presentSheetController:viewController contentSize:aSize shadowColor:nil completion:completion];
}

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 shadowColor    蒙层颜色
 completion     动画结束后的回调
 */
- (void)presentSheetController:(UIViewController *)viewController contentSize:(CGSize)aSize shadowColor:(UIColor *__nullable)aColor completion:(HAnimationCompletion __nullable)completion {
    [self presentSheetController:viewController contentSize:aSize animationDuration:0.25 shadowColor:aColor shadowDismiss:YES completion:completion];
}

/*
 viewController 要显示的控制器
 contentSize    显示的视图大小
 duration       动画时间
 shadowColor    蒙层颜色
 shadowDismiss  点击阴影是否dismiss当前页面
 completion     动画结束后的回调
 */
- (void)presentSheetController:(UIViewController *)viewController contentSize:(CGSize)aSize animationDuration:(NSTimeInterval)duration shadowColor:(UIColor *__nullable)aColor shadowDismiss:(BOOL)isShadowDismiss completion:(HAnimationCompletion __nullable)completion {
    HPresentAnimation *animation = HPresentAnimation.new;
    animation.presetType  = HTransitionPresentTypeSheet;
    animation.contentSize = aSize;
    animation.animationDuration = duration;
    animation.shadowColor = aColor;
    animation.isShadowDismiss  = isShadowDismiss;
    animation.animationCompletion = completion;
    [self presentedViewController:viewController animation:animation];
}

#pragma mark - 私有方式
- (void)presentedViewController:(UIViewController*)viewController animation:(HPresentAnimation *)animation {
    if(animation) {
        self.presentAnimation = animation;
        viewController.modalPresentationStyle = UIModalPresentationCustom; //设置目标vc的动画为自定义
        viewController.transitioningDelegate = animation; //设置动画管理代理类
    }
    @weakify(self);
    self.presentAnimation.animationCompletion = ^(HTransitionAnimationType transitionType, BOOL finished) {
        @strongify(self);
        if(transitionType == HTransitionAnimationTypeDismiss && finished) {
            self.presentAnimation = nil;
        }
    };
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - Push、Pop
/*
 viewController 要显示的控制器
 completion     动画结束后的回调
*/
- (void)pushViewController:(UIViewController *)viewController completion:(HAnimationCompletion)completion {
    HTransitionAnimation *anmiation  = HTransitionAnimation.new;
    self.transitionAnimation  = anmiation;
    UINavigationController *navigationVC = nil;
    if([self isKindOfClass:UINavigationController.class]) {
        navigationVC = (UINavigationController*)self;
    }else {
        navigationVC = viewController.navigationController;
    }
    navigationVC.delegate = (id<UINavigationControllerDelegate>)self;
    [navigationVC pushViewController:viewController animated:YES];
}

#pragma mark - UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if(operation == UINavigationControllerOperationPush) {
        self.transitionAnimation.transitionType = HTransitionAnimationTypePush;
        return self.transitionAnimation;
    }else if(operation  == UINavigationControllerOperationPop) {
         self.transitionAnimation.transitionType = HTransitionAnimationTypePop;
        return self.transitionAnimation;
    }
    return nil;
}

@end
