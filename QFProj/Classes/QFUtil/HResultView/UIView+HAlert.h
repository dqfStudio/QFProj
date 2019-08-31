//
//  UIView+HAlert.h
//  HFundation
//
//  Created by dqf on 2018/1/22.
//  Copyright © 2018年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAlert+Protocol.h"
#import "HWaitingView.h"
#import "HResultView.h"
#import "HNaviToastView.h"
#import "HAlertView.h"
#import "NSObject+HMessy.h"

@interface UIView (HAlert)
/**
 加载等待界面

 @param configBlock 参数配置block
 */
- (void)showWaiting:(void(^)(id<HWaitingProtocol> make))configBlock;
/**
 请求结果展示界面协议
 
 @param configBlock 参数配置block
 */
- (void)showResult:(void(^)(id<HResultProtocol> make))configBlock;
/**
 alert提示
 
 @param configBlock 参数配置block
 */
- (void)showAlert:(void(^)(id<HAlertProtocol> make))configBlock;
/**
 actionsheet提示，表单布局
 
 @param configBlock 参数配置block
 */
- (void)showSheet:(void(^)(id<HSheetProtocol> make))configBlock;
/**
 actionsheet提示，网格布局
 
 @param configBlock 参数配置block
 */
- (void)showForm:(void(^)(id<HFormProtocol> make))configBlock;
/**
 toast提示
 
 @param configBlock 参数配置block
 */
- (void)showToast:(void(^)(id<HToastProtocol> make))configBlock;
/**
 navi toast提示，即为navibar上的toast
 
 @param configBlock 参数配置block
 */
- (void)showNaviToast:(void(^)(id<HNaviToastProtocol> make))configBlock;


/**
 移除对应提示
 */
- (void)removeWaiting;
- (void)removeResult;

@end
