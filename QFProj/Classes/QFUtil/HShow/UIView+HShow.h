//
//  UIView+HShow.h
//  HFundation
//
//  Created by dqf on 2018/1/22.
//  Copyright © 2018年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HShow+Protocol.h"
#import "HRequestResultView.h"
#import "HRequestWaitingView.h"
#import "HNaviToastView.h"
#import "HShowView.h"
#import "NSObject+HMessy.h"

@interface UIView (HShow)

@property(nonatomic) HRequestWaitingView *mgWaitingView;
@property(nonatomic) HRequestResultView *mgResultView;
@property(nonatomic) HNaviToast *mgNaviToast;
@property(nonatomic) HToast *mgToast;
@property(nonatomic) HAlert *mgAlert;

/**
 加载等待界面

 @param configBlock 参数配置block
 */
- (void)showWaiting:(void(^)(id<HWaitingProtocol> make))configBlock;
/**
 无数据提示界面
 
 @param configBlock 参数配置block
 */
- (void)showNoData:(void(^)(id<HNoDataProtocol> make))configBlock;
/**
 无网络提示界面
 
 @param configBlock 参数配置block
 */
- (void)showNoNetwork:(void(^)(id<HNoNetworkProtocol> make))configBlock;
/**
 请求失败提示界面
 
 @param configBlock 参数配置block
 */
- (void)showLoadError:(void(^)(id<HLoadErrorProtocol> make))configBlock;
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
 alert提示
 
 @param configBlock 参数配置block
 */
- (void)showAlert:(void(^)(id<HAlertProtocol> make))configBlock;


/**
 移除对应提示
 */
- (void)removeWaiting;
- (void)removeNoData;
- (void)removeNoNetwork;
- (void)removeLoadError;
- (void)removeSheet;
- (void)removeForm;

@end
