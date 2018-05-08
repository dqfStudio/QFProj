//
//  HShow+Protocol.h
//  HFundation
//
//  Created by dqf on 2018/1/22.
//  Copyright © 2018年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 协议层，具体协议跟业务相关
 */

typedef void (^HShowClickedBlock)(void);

/**
 基础协议
 */
@protocol HShowBaseProtocol <NSObject>
@optional
- (void)addObserver;
- (void)removeObserver;
@end

/**
 加载等待界面协议
 */
@protocol HLoadingProtocol <HShowBaseProtocol>

@optional
- (void)setMarginTop:(CGFloat)marginTop;
- (void)setYOffset:(CGFloat)yOffset;

@end

/**
 无数据提示界面协议
 */
@protocol HNoDataProtocol <HShowBaseProtocol>

@optional
- (void)setFitFrame:(CGRect)frame;
- (void)setDisplayImage:(BOOL)yn;
- (void)setDesc:(NSString *)desc;
- (void)setDetlDesc:(NSString *)detlDesc;
- (void)setDetlDescColor:(UIColor *)color;
- (void)setMarginTop:(CGFloat)marginTop;
- (void)setYOffset:(CGFloat)yOffset;
- (void)setYRatio:(CGFloat)ratio;
- (void)setClickedBlock:(HShowClickedBlock)showClickedBlock;

@end

/**
 无网络提示界面协议
 */
@protocol HNoNetworkProtocol <HShowBaseProtocol>

@optional
- (void)setFitFrame:(CGRect)frame;
- (void)setDisplayImage:(BOOL)yn;
- (void)setDesc:(NSString *)desc;
- (void)setDetlDesc:(NSString *)detlDesc;
- (void)setMarginTop:(CGFloat)marginTop;
- (void)setYOffset:(CGFloat)yOffset;
- (void)setYRatio:(CGFloat)ratio;
- (void)setClickedBlock:(HShowClickedBlock)showClickedBlock;

@end

/**
 请求失败提示界面协议
 */
@protocol HLoadErrorProtocol <HShowBaseProtocol>

@optional
- (void)setFitFrame:(CGRect)frame;
- (void)setDisplayImage:(BOOL)yn;
- (void)setDesc:(NSString *)desc;
- (void)setDetlDesc:(NSString *)detlDesc;
- (void)setMarginTop:(CGFloat)marginTop;
- (void)setYOffset:(CGFloat)yOffset;
- (void)setYRatio:(CGFloat)ratio;
- (void)setClickedBlock:(HShowClickedBlock)showClickedBlock;

@end

/**
 actionsheet提示协议，表单布局
 */
@protocol HSheetProtocol <HShowBaseProtocol>

@optional
- (void)setRelyView:(UIView *)view;
- (void)setIcon:(NSString *)name;
- (void)setCompletionBlock:(void (^)(NSInteger buttonIndex))completionBlock;

@end

/**
 actionsheet提示协议，网格布局
 */
@protocol HFormProtocol <HShowBaseProtocol>

@end

/**
 toast提示协议
 */
@protocol HToastProtocol <HShowBaseProtocol>

@optional
- (void)setDesc:(NSString *)desc;
- (void)setIcon:(NSString *)name;
- (void)setDelay:(NSTimeInterval)delay;

@end

/**
 alert提示协议
 */
@protocol HAlertProtocol <HShowBaseProtocol>

@optional
- (void)setDesc:(NSString *)desc;
- (void)setDetlDesc:(NSString *)detlDesc;
- (void)setCompletionBlock:(void (^)(NSInteger buttonIndex))completionBlock;

@end

