//
//  HAlertFormatter.h
//  QFProj
//
//  Created by Wind on 2021/6/2.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HProgressHUD.h"

typedef void (^HAlertClickedBlock)(void);
typedef void (^HAlertButtonBlock)(NSInteger buttonIndex);

@interface HWaitingTransition : NSObject

//0为black，1为white，2为gray
@property (nonatomic) NSInteger style; //设置展示样式
@property (nonatomic) UIColor *bgColor; //设置背景颜色
@property (nonatomic) CGFloat marginTop; //设置marginTop的值

@property (nonatomic) NSString *desc; //设置第一行文字
@property (nonatomic) UIFont *descFont; //设置第一行文字字体
@property (nonatomic) UIColor *descColor; //设置第一行文字颜色

@end

@interface HResultTransition : NSObject

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

@interface HToastTransition : NSObject

@property (nonatomic) NSString *desc;
@property (nonatomic) NSTimeInterval delay;//默认为2秒
@property (nonatomic) UIView *inView;//add view to，默认为UIWindow

@end
