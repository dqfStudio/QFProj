//
//  HTransitionAnimation.h
//  QFProj
//
//  Created by dqf on 2019/12/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCommonDefine.h"
#import "HTransitionHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

/**
 * 转场动画类型
*/
@property (nonatomic) HTransitionType transitionType;
/**
 * 动画时间, 默认0.25秒
 */
@property (nonatomic) NSTimeInterval transitionDuration;
/**
 * 转场动画结束回调
*/
@property (nonatomic, copy, nullable) HTransitionCompletion transitionCompletion;

//#pragma mark -- transitionType（子类实现）
//动画开始方法
- (void)startPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)startPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)startPresentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)startDismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;
//动画结束方法
- (void)endPushAnimation;
- (void)endPopAnimation;
- (void)endPresentAnimation;
- (void)endDismissAnimation;
    
@end

NS_ASSUME_NONNULL_END
