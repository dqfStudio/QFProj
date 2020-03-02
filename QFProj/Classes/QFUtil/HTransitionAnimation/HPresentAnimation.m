//
//  HPresentAnimation.m
//  QFProj
//
//  Created by dqf on 2019/12/13.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HPresentAnimation.h"
#import "HPresentationController.h"

@interface HPresentAnimation ()
@property (nonatomic, nullable) HPresentationController *presentationVC; //管理要显示视图的VC
@end

@implementation HPresentAnimation

#pragma mark - UIViewControllerTransitioningDelegate
// 返回的对象控制Presented时的动画 (开始动画的具体细节负责类)
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.transitionType = HTransitionTypePresent;
    return self;
}
// 由返回的控制器控制dismissed时的动画 (结束动画的具体细节负责类)
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.transitionType = HTransitionTypeDismiss;
    return self;
}

#pragma mark - 重写父类方法
- (void)startPresentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self animationForPresentedView:transitionContext];
}
- (void)startDismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self animationForDismissedView:transitionContext];
}

- (void)endPresentAnimation {
    if (self.transitionCompletion) self.transitionCompletion(HTransitionTypePresent);
}
- (void)endDismissAnimation {
    if (self.transitionCompletion) self.transitionCompletion(HTransitionTypeDismiss);
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
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    HAnimationWeakSelf(weakSelf)
    if (self.presetType == HTransitionStyleAlert) {
        presentedView.alpha = 0.0f;
        presentedView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        // 动画弹出
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:50 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            presentedView.alpha = 1.0f;
            presentedView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (finished) {
                [transitionContext completeTransition:YES];
            }
        }];
    } else if (self.presetType == HTransitionStyleSheet) {
        presentedView.transform = CGAffineTransformMakeTranslation(0, weakSelf.contentSize.height);
        [UIView animateWithDuration:duration animations:^{
            presentedView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (finished) {
                [transitionContext completeTransition:YES];
            }
        }];
    }
}
// 弹框消失
- (void)animationForDismissedView:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *presentedView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    //动画时间
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    HAnimationWeakSelf(weakSelf)
    if (self.presetType == HTransitionStyleAlert) {
        // 消失
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            presentedView.alpha = 0.0f;
            presentedView.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
        } completion:^(BOOL finished) {
            if (finished) {
                [presentedView removeFromSuperview];
                [transitionContext completeTransition:YES];
            }
        }];
    }else if (self.presetType == HTransitionStyleSheet) {
        [UIView animateWithDuration:duration animations:^{
            presentedView.transform = CGAffineTransformMakeTranslation(0, weakSelf.contentSize.height);
        } completion:^(BOOL finished) {
            if (finished) {
                [presentedView removeFromSuperview];
                [transitionContext completeTransition:YES];
            }
        }];
    }
}

@end

@implementation HPresentAnimation (HPresent)
#pragma mark - UIViewControllerTransitioningDelegate
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    HPresentationController *presentationVC = [[HPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    presentationVC.presentType = self.presetType;
    presentationVC.contentSize = self.contentSize;
    presentationVC.isShadowDismiss = self.isShadowDismiss;
    presentationVC.shadowColor = self.shadowColor;
    self.presentationVC = presentationVC;
    return presentationVC;
}
@end
