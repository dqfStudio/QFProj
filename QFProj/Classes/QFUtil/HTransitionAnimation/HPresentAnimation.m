//
//  HPresentAnimation.m
//  KYProjectModel
//
//  Created by TX-Kevin on 2019/12/13.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HPresentAnimation.h"
#import "HPresentationController.h"

@interface HPresentAnimation ()
@property (nonatomic, nullable) HPresentationController *presentationVC; //管理要显示视图的VC
@end

@implementation HPresentAnimation

+ (instancetype)defaultAnimation {
    HPresentAnimation *animation  = HPresentAnimation.new;
    animation.presetType  = HTransitionPresentTypeAlert;
    animation.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    animation.contentSize = CGSizeZero;
    animation.isShadowDismiss = YES;
    animation.animationCompletion = nil;
    animation.animationDuration = 0.25;
    return animation;
}

#pragma mark - UIViewControllerTransitioningDelegate
// 返回的对象控制Presented时的动画 (开始动画的具体细节负责类)
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.transitionType = HTransitionAnimationTypePresent;
    if (self.animationCompletion) self.animationCompletion(HTransitionAnimationTypePresent, YES);
    return self;
}
// 由返回的控制器控制dismissed时的动画 (结束动画的具体细节负责类)
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.transitionType  = HTransitionAnimationTypeDismiss;
    if (self.animationCompletion) self.animationCompletion(HTransitionAnimationTypeDismiss, YES);
    return self;
}

#pragma mark - 重写父类方法
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self animationForPresentedView:transitionContext];
}
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self animationForDismissedView:transitionContext];
}
#pragma mark - 自定义动画实现方法
//弹出动画
- (void)animationForPresentedView:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    //获得要显示的view
    UIView *presentedView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [transitionContext.containerView addSubview:presentedView];
    //蒙层颜色
    self.presentationVC.shadowColor = self.shadowColor;
    //设置阴影
//    transitionContext.containerView.layer.shadowColor = self.coverColor.CGColor;
//    transitionContext.containerView.layer.shadowOffset = CGSizeMake(0, 5);
//    transitionContext.containerView.layer.shadowOpacity = 0.5f;
//    transitionContext.containerView.layer.shadowRadius = 10.0f;
    
    //动画时间
    NSTimeInterval duration  = [self transitionDuration:transitionContext];
    
    HAnimationWeakSelf(weakSelf)
    if (self.presetType == HTransitionPresentTypeAlert) {
        presentedView.alpha = 0.0f;
        presentedView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        // 动画弹出
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:50 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            presentedView.alpha = 1.0f;
            presentedView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if(finished){
                [transitionContext completeTransition:YES];
            }
        }];
    } else if (self.presetType == HTransitionPresentTypeSheet) {
        presentedView.transform = CGAffineTransformMakeTranslation(0, weakSelf.contentSize.height);
        [UIView animateWithDuration:duration animations:^{
            presentedView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if(finished){
                [transitionContext completeTransition:YES];
            }
        }];
    }
}
// 弹框消失
- (void)animationForDismissedView:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *presentedView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    //动画时间
    NSTimeInterval duration  = [self transitionDuration:transitionContext];
    
    HAnimationWeakSelf(weakSelf)
    if (self.presetType == HTransitionPresentTypeAlert) {
        // 消失
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            presentedView.alpha = 0.0f;
            presentedView.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
        } completion:^(BOOL finished) {
            if(finished){
                [presentedView removeFromSuperview];
                [transitionContext completeTransition:YES];
            }
        }];
    }else if (self.presetType == HTransitionPresentTypeSheet){
        [UIView animateWithDuration:duration animations:^{
            presentedView.transform = CGAffineTransformMakeTranslation(0, weakSelf.contentSize.height);
        } completion:^(BOOL finished) {
            if(finished){
                [presentedView removeFromSuperview];
                [transitionContext completeTransition:YES];
            }
        }];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    HPresentationController *presentationVC = [[HPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    presentationVC.presentType = self.presetType;
    presentationVC.contentSize = self.contentSize;
    presentationVC.isShadowDismiss = self.isShadowDismiss;
    presentationVC.shadowColor  = self.shadowColor;
    self.presentationVC = presentationVC;
    return presentationVC;
}

@end
