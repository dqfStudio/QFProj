//
//  HAlert+Protocol.h
//  HFundation
//
//  Created by dqf on 2018/1/22.
//  Copyright © 2018年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFormCell.h"

/**
 协议层，具体协议跟业务相关
 */

typedef void (^HAlertClickedBlock)(void);
typedef void (^HButtonBlock)(NSInteger buttonIndex);

/**
 基础协议
 */
@protocol HShowBaseProtocol <NSObject>

@optional
@property (nonatomic) BOOL isLoading;

@end

/**
 加载等待界面协议
 */
@protocol HWaitingProtocol <HShowBaseProtocol>

@optional
//0为black，1为white，2为gray
@property (nonatomic) NSInteger style; //设置展示样式
@property (nonatomic) UIColor *bgColor; //设置背景颜色
@property (nonatomic) CGFloat marginTop; //设置marginTop的值

@property (nonatomic) NSString *desc; //设置第一行文字
@property (nonatomic) UIFont *descFont; //设置第一行文字字体
@property (nonatomic) UIColor *descColor; //设置第一行文字颜色

@end

/**
 请求结果展示界面协议
 */
@protocol HResultProtocol <HShowBaseProtocol>

@optional
//0为noData，1为loadError，2为noNetwork
@property (nonatomic) NSInteger style; //设置展示样式
@property (nonatomic) UIColor *bgColor; //设置背景颜色
@property (nonatomic) CGFloat marginTop; //设置marginTop的值

@property (nonatomic) BOOL hideImage; //是否展示图片，默认展示图片

@property (nonatomic) NSString *desc; //设置第一行文字，有默认值
@property (nonatomic) UIFont *descFont; //设置第一行文字字体
@property (nonatomic) UIColor *descColor; //设置第一行文字颜色

@property (nonatomic) NSString *detlDesc; //设置第二行文字
@property (nonatomic) UIFont *detlDescFont; //设置第二行文字字体
@property (nonatomic) UIColor *detlDescColor; //设置第二行文字颜色

@property (nonatomic,copy) HAlertClickedBlock clickedBlock; //设置点击事件

@end

/**
 alert提示协议
 */
@protocol HAlertProtocol <HShowBaseProtocol>

@optional
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *msg;

@property (nonatomic) NSString *cancelTitle;
@property (nonatomic) NSArray  *buttonTitles;
@property (nonatomic,copy) HButtonBlock buttonBlock;

@end

/**
 actionsheet提示协议，表单布局
 */
@protocol HSheetProtocol <HShowBaseProtocol>

@optional
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *msg;

@property (nonatomic) NSString *cancelTitle;
@property (nonatomic) NSArray  *buttonTitles;
@property (nonatomic,copy) HButtonBlock buttonBlock;

@end

/**
 actionsheet提示协议，网格布局
 */
@protocol HFormProtocol <HShowBaseProtocol>

@optional
@property (nonatomic) NSInteger type;
@property (nonatomic) NSArray *modelArr;
@property (nonatomic) NSInteger rows;//一页显示几行
@property (nonatomic) NSInteger rowItems;//一行显示几个
@property (nonatomic,copy) HFormCellBlock buttonBlock;

@end

/**
 toast提示协议
 */
@protocol HToastProtocol <HShowBaseProtocol>

@optional
@property (nonatomic) NSString *desc;
@property (nonatomic) NSTimeInterval delay;//默认为2秒

@end

/**
 navi toast提示协议
 */
@protocol HNaviToastProtocol <HShowBaseProtocol>

@optional
@property (nonatomic) NSString *desc;
@property (nonatomic) NSString *icon;
@property (nonatomic) NSTimeInterval delay;//默认为2秒

@end

