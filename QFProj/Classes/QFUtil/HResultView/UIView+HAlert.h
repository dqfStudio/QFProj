//
//  UIView+HAlert.h
//  HFundation
//
//  Created by dqf on 2018/1/22.
//  Copyright © 2018年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWaitingView.h"
#import "HResultView.h"

@interface UIView (HAlert)

//加载等待界面
- (void)showWaiting:(void(^)(HWaitingTransition *make))block;
//请求结果展示界面
- (void)showResult:(void(^)(HResultTransition *make))block;

//移除对应提示
- (void)removeWaiting;
- (void)removeResult;

@end

@interface HProgressHUD (HAlert)
+ (void)showToast:(void(^)(HToastTransition *make))block;
@end
