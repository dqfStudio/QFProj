//
//  UIViewController+HAnimation.m
//  QFProj
//
//  Created by dqf on 2019/12/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import "UIViewController+HAnimation.h"
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

@implementation UIViewController (HAnimation)

#pragma mark - Present、Dismiss -> Alert、Sheet
#pragma mark -
/*
 viewController 要显示的控制器
 completion     动画结束后的回调
*/
- (void)presentController:(UIViewController *)viewController completion:(HTransitionCompletion __nullable)completion {
    HPresentAnimation *animation = HPresentAnimation.new;
    animation.presetType = viewController.presetType;
    animation.contentSize = viewController.containerSize;
    animation.transitionDuration = viewController.transitionDuration;
    animation.shadowColor = viewController.shadowColor;
    animation.isShadowDismiss = viewController.isShadowDismiss;
    animation.transitionCompletion = completion;
    self.presentAnimation = animation;
    viewController.modalPresentationStyle = UIModalPresentationCustom; //设置目标vc的动画为自定义
    viewController.transitioningDelegate = animation; //设置动画管理代理类
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - Push、Pop
#pragma mark -
/*
 viewController 要显示的控制器
 animationType  动画类型
 completion     动画结束后的回调
*/
- (void)pushViewController:(UIViewController *)viewController completion:(HTransitionCompletion)completion {
    HPushAnimation *animation = HPushAnimation.new;
    animation.pushAnimationType = viewController.animationType;
    animation.transitionCompletion = completion;
    self.pushAnimation = animation;
    UINavigationController *navigationVC = nil;
    if ([self isKindOfClass:UINavigationController.class]) {
        navigationVC = (UINavigationController *)self;
    }else {
        navigationVC = viewController.navigationController;
    }
    navigationVC.delegate = (id<UINavigationControllerDelegate>)self;
    [navigationVC pushViewController:viewController animated:YES];
}

@end
