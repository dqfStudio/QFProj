//
//  HPresentAnimation.h
//  QFProj
//
//  Created by dqf on 2019/12/13.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HTransitionAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPresentAnimation : HTransitionAnimation <UIViewControllerTransitioningDelegate>

//转场视图尺寸大小
@property (nonatomic) CGSize contentSize;

//转场动画类型(默认Alert)
@property (nonatomic) HTransitionStyle presetType;

//转场视图点击背景是否dismiss (消失）默认NO
@property (nonatomic) BOOL isShadowDismiss;

//转场视图背景颜色 (默认 [UIColor colorWithWhite:0.1 alpha:0.2]）
@property (nonatomic, nullable) UIColor *shadowColor;

@end

NS_ASSUME_NONNULL_END
