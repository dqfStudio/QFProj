//
//  HPushAnimation.m
//  QFProj
//
//  Created by dqf on 2019/12/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HPushAnimation.h"

@implementation HPushAnimation

#pragma makr - 重写父类方法
- (void)startPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (_pushAnimationType) {
        case HPushAnimationTypeOCDoor:
            [self animationForPushView:transitionContext];
            break;
            
        default:
            break;
    }
}
- (void)startPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (_pushAnimationType) {
        case HPushAnimationTypeOCDoor:
            [self animationForPopView:transitionContext];
            break;
            
        default:
            break;
    }
}

- (void)endPushAnimation {
    if (self.transitionCompletion) self.transitionCompletion(HTransitionTypePush);
}
- (void)endPopAnimation {
    if (self.transitionCompletion) self.transitionCompletion(HTransitionTypePop);
}

#pragma mark - 自定义动画实现方法
//弹出动画，开关门动画
- (void)animationForPushView:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    //取出转场前后视图控制器上的视图view
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *containerView = [transitionContext containerView];
    //左侧动画视图
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(-toView.frame.size.width/2, 0, toView.frame.size.width/2, toView.frame.size.height)];
    leftView.clipsToBounds = YES;
    [leftView addSubview:toView];
    //右侧动画视图
    // 使用系统自带的snapshotViewAfterScreenUpdates:方法，参数为YES，代表视图的属性改变渲染完毕后截屏，参数为NO代表立刻将当前状态的视图截图
    UIView *rightToView = [toView snapshotViewAfterScreenUpdates:YES];
    rightToView.frame = CGRectMake(-toView.frame.size.width/2, 0, toView.frame.size.width, toView.frame.size.height);
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(toView.frame.size.width, 0, toView.frame.size.width/2, toView.frame.size.height)];
    rightView.clipsToBounds = YES;
    [rightView addSubview:rightToView];
    
    //加入动画视图
    [containerView addSubview:fromView];
    [containerView addSubview:leftView];
    [containerView addSubview:rightView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^{
                         leftView.frame = CGRectMake(0, 0, toView.frame.size.width/2, toView.frame.size.height);
                         rightView.frame = CGRectMake(toView.frame.size.width/2, 0, toView.frame.size.width/2, toView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         //由于加入了手势交互转场，所以需要根据手势动作是否完成/取消来做操作
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         if([transitionContext transitionWasCancelled]) {
                             //手势取消
                         }else {
                             //手势完成
                             [containerView addSubview:toView];
                         }
                         [leftView removeFromSuperview];
                         [rightView removeFromSuperview];
                         toView.hidden = NO;
                     }];
}

// 弹框消失
- (void)animationForPopView:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    //取出转场前后视图控制器上的视图view
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];

    UIView *containerView = [transitionContext containerView];

    //左侧动画视图
    UIView *leftFromView = [fromView snapshotViewAfterScreenUpdates:NO];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fromView.frame.size.width/2, fromView.frame.size.height)];
    leftView.clipsToBounds = YES;
    [leftView addSubview:leftFromView];
    //右侧动画视图
    UIView *rightFromView = [fromView snapshotViewAfterScreenUpdates:NO];
    rightFromView.frame = CGRectMake(- fromView.frame.size.width/2, 0, fromView.frame.size.width, fromView.frame.size.height);
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(fromView.frame.size.width/2, 0, fromView.frame.size.width/2, fromView.frame.size.height)];
    rightView.clipsToBounds = YES;
    [rightView addSubview:rightFromView];

    [containerView addSubview:toView];
    [containerView addSubview:leftView];
    [containerView addSubview:rightView];

    fromView.hidden = YES;

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         delay:0
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        leftView.frame = CGRectMake(-fromView.frame.size.width/2, 0, fromView.frame.size.width/2, fromView.frame.size.height);
                        rightView.frame = CGRectMake(fromView.frame.size.width, 0, fromView.frame.size.width/2, fromView.frame.size.height);
                    }
                    completion:^(BOOL finished) {
                        fromView.hidden = NO;
                        [leftView removeFromSuperview];
                        [rightView removeFromSuperview];
                        [transitionContext completeTransition:YES];
                    }];
}

@end