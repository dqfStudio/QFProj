//
//  HPresentationController.h
//  KYProjectModel
//
//  Created by TX-Kevin on 2019/12/13.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCommonDefine.h"
#import "HAnimationHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPresentationController : UIPresentationController
//蒙层
@property (nonatomic, nullable) UIView *contentCoverView;
//蒙层颜色
@property (nonatomic, nullable) UIColor *shadowColor;
//弹出框类型
@property (nonatomic) HTransitionStyle presentType;
//内容层大小
@property (nonatomic) CGSize contentSize;
///点击阴影是否关闭页面
@property (nonatomic) BOOL isShadowDismiss;
@end

NS_ASSUME_NONNULL_END
