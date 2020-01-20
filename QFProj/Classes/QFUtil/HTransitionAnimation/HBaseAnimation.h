//
//  HBaseAnimation.h
//  QFProj
//
//  Created by dqf on 2019/12/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCommonDefine.h"
#import "HTransitionHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBaseAnimation : NSObject <UIViewControllerAnimatedTransitioning>
/**
 * 动画时间, 默认0.25秒
 */
@property (nonatomic) NSTimeInterval animationDuration;
/**
 * 转场动画类型
*/
@property (nonatomic) HTransitionType transitionType;
/**
 * 转场动画结束回调
*/
@property (nonatomic, copy, nullable) HTransitionCompletion transitionCompletion;

#pragma mark -- transitionType（子类实现）
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;
    
@end

NS_ASSUME_NONNULL_END
