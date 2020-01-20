//
//  HBaseAnimation.m
//  QFProj
//
//  Created by dqf on 2019/12/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HBaseAnimation.h"

@implementation HBaseAnimation

- (instancetype)init {
    self = [super init];
    if (self) {
        self.animationDuration = 0.25; //默认0.25秒
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

//动画时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.animationDuration;
}

//所有的过渡动画事务都在这个方法里面完成
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (_transitionType) {
        case HTransitionTypePush:
            [self pushAnimation:transitionContext];
            break;
        case HTransitionTypePop:
            [self popAnimation:transitionContext];
            break;
        case HTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case HTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
        default:
            break;
    }
}

//动画结束
- (void)animationEnded:(BOOL)transitionCompleted {
    if (!transitionCompleted) {
        return;
    }
    switch (_transitionType) {
        case HTransitionTypePush:
            //NSLog(@"push 动画结束");
            break;
        case HTransitionTypePop:
             //NSLog(@"Pop 动画结束");
            break;
        case HTransitionTypePresent:
            //NSLog(@"present 动画结束");
            break;
        case HTransitionTypeDismiss:
            //NSLog(@"dismiss 动画结束");
            break;
        default:
            break;
    }
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {}
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {}
- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {}
- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {}

@end
