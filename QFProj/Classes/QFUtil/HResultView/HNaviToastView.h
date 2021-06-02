//
//  HNaviToastView.h
//  QFProj
//
//  Created by dqf on 2018/5/30.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScreen+HUtil.h"

@interface HNaviToastView : UIView

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic) UIImage *iconImage;

//显示
- (void)show:(BOOL)animated;

//隐藏
- (void)hide:(BOOL)animated;

//延迟隐藏
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)interval;


//返回当前view上的所有MGToastView子视图
+ (NSArray<HNaviToastView *> *)allToastForView:(UIView *)view;


//隐藏view视图上所有的MGToastView子视图
+ (void)hideAllToastForView:(UIView *)view animated:(BOOL)animated;

//快速获取通用toast
+ (instancetype)customToastAddedTo:(UIView *)view animated:(BOOL)animated;
+ (instancetype)showCustomToast:(NSString *)string afterDelay:(NSTimeInterval)delay icon:(UIImage *)icon;
//快速获取错误toast
+ (instancetype)errorToastAddedTo:(UIView *)view animated:(BOOL)animated;
+ (instancetype)showErrorToast:(NSString *)string afterDelay:(NSTimeInterval)delay icon:(UIImage *)icon;


@end
