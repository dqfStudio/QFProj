//
//  HTransitionAnimation.m
//  QFProj
//
//  Created by dqf on 2019/12/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HTransitionAnimation.h"

@implementation HTransitionAnimation

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitionDuration = 0.25; //默认0.25秒
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

//动画时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
}

//所有的过渡动画事务都在这个方法里面完成
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (_transitionType) {
        case HTransitionTypePush:
            [self startPushAnimation:transitionContext];
            break;
        case HTransitionTypePop:
            [self startPopAnimation:transitionContext];
            break;
        case HTransitionTypePresent:
            [self startPresentAnimation:transitionContext];
            break;
        case HTransitionTypeDismiss:
            [self startDismissAnimation:transitionContext];
            break;
        default:
            break;
    }
}

//动画结束
- (void)animationEnded:(BOOL)transitionCompleted {
    if (transitionCompleted) {
        switch (_transitionType) {
            case HTransitionTypePush:
                [self endPushAnimation];
                break;
            case HTransitionTypePop:
                [self endPopAnimation];
                break;
            case HTransitionTypePresent:
                [self endPresentAnimation];
                break;
            case HTransitionTypeDismiss:
                [self endDismissAnimation];
                break;
            default:
                break;
        }
    }
}

//动画开始方法
- (void)startPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {}
- (void)startPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {}
- (void)startPresentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {}
- (void)startDismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {}
//动画结束方法
- (void)endPushAnimation {}
- (void)endPopAnimation {}
- (void)endPresentAnimation {}
- (void)endDismissAnimation {}

@end
