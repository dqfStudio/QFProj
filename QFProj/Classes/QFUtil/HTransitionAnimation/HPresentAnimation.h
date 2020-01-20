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

/*
 * 弹框的尺寸大小
 */
@property (nonatomic) CGSize contentSize;

/*
 * 弹框的类型(默认Alert)
 */
@property (nonatomic) HTransitionStyle presetType;

/*
 * 弹框点击背景是否dismiss (消失）默认NO
 */
@property (nonatomic) BOOL isShadowDismiss;

/*
* 弹框背景颜色 (默认 [[UIColor blackColor] colorWithAlphaComponent:0.2f]）
*/
@property (nonatomic, nullable) UIColor *shadowColor;

@end

NS_ASSUME_NONNULL_END
