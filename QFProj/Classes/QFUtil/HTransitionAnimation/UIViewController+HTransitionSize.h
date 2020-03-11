//
//  UIViewController+HTransitionSize.h
//  QFProj
//
//  Created by wind on 2020/3/11.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTransitionHeader.h"

@interface UIViewController (HTransitionSize)
//转场动画内容视图的大小
@property (nonatomic, readonly) CGSize containerSize;
//转场动画的时间
@property (nonatomic, readonly) CGFloat transitionDuration;
//转场动画内容视图阴影部分颜色
@property (nonatomic, readonly) UIColor *shadowColor;
//转场动画内容视图点击是否整体消失
@property (nonatomic, readonly) BOOL isShadowDismiss;
//是否隐藏视觉展示效果，如毛玻璃效果
@property (nonatomic, readonly) BOOL hideVisualView;
//转场类型
@property (nonatomic, readonly) HTransitionStyle presetType;
//push转场动画具体类型
@property (nonatomic, readonly) HPushAnimationType animationType;
@end
