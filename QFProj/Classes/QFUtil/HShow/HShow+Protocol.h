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
- (BOOL)isLoading;
- (void)start;
- (void)end;
@end

/**
 加载等待界面协议
 */
@protocol HWaitingProtocol <HShowBaseProtocol>

@optional
@property (nonatomic) NSInteger style;
@property (nonatomic) UIColor *bgColor;
@property (nonatomic) CGFloat marginTop;

@property (nonatomic) NSString *desc;
@property (nonatomic) UIFont *descFont;
@property (nonatomic) UIColor *descColor;




- (void)resetFrame:(CGRect)frame; //手动设置frame
- (void)setScreenFrame; //frame大小与screen frame 相同
- (void)setBackgroudColor:(UIColor *)color; //设置背景颜色
- (void)setGrayStyle; //设置样式
- (void)setWhiteStyle; //设置样式
- (void)setDesc:(NSString *)desc; //设置第一行文字
- (void)setDescFont:(UIFont *)font; //设置第一行文字字体
- (void)setDescColor:(UIColor *)color; //设置第一行文字颜色
- (void)setMarginTop:(CGFloat)marginTop; //设置marginTop的值
- (void)setNaviMarginTop; //设置marginTop的值为导航栏的高度
- (void)setMarginBottom:(CGFloat)marginBottom; //设置marginBottom的值
- (void)setToolBarMarginBottom; //设置marginBottom的值为iphone x的底部高度34.f
- (void)setYOffset:(CGFloat)yOffset; //设置内容垂直方向偏移量
- (void)setYRatio:(CGFloat)ratio; //按比例设置内容垂直方向偏移量

@end

/**
 无数据提示界面协议
 */
@protocol HNoDataProtocol <HShowBaseProtocol>

@optional
@property (nonatomic) NSInteger style;
@property (nonatomic) UIColor *bgColor;
@property (nonatomic) CGFloat marginTop;

@property (nonatomic) BOOL hideImage;

@property (nonatomic) NSString *desc;
@property (nonatomic) UIFont *descFont;
@property (nonatomic) UIColor *descColor;

@property (nonatomic) NSString *detlDesc;
@property (nonatomic) UIFont *detlDescFont;
@property (nonatomic) UIColor *detlDescColor;

@property (nonatomic,copy) HShowClickedBlock clickedBlock;


- (void)resetFrame:(CGRect)frame; //手动设置frame
- (void)setScreenFrame; //frame大小与screen frame 相同
- (void)setDisplayImage:(BOOL)display; //是否展示图片，默认展示图片
- (void)setDesc:(NSString *)desc; //设置第一行文字
- (void)setDescFont:(UIFont *)font; //设置第一行文字字体
- (void)setDescColor:(UIColor *)color; //设置第一行文字颜色
- (void)setDetlDesc:(NSString *)detlDesc; //设置第二行文字
- (void)setDetlDescFont:(UIFont *)font; //设置第二行文字字体
- (void)setDetlDescColor:(UIColor *)color; //设置第二行文字颜色
- (void)setMarginTop:(CGFloat)marginTop; //设置marginTop的值
- (void)setNaviMarginTop; //设置marginTop的值为导航栏的高度
- (void)setMarginBottom:(CGFloat)marginBottom; //设置marginBottom的值
- (void)setToolBarMarginBottom; //设置marginBottom的值为iphone x的底部高度34.f
- (void)setYOffset:(CGFloat)yOffset; //设置内容垂直方向偏移量
- (void)setYRatio:(CGFloat)ratio; //按比例设置内容垂直方向偏移量
- (void)setYCenter; //设置内容垂直方向居中
- (void)setClickedBlock:(HShowClickedBlock)showClickedBlock; //设置点击事件

@end

/**
 无网络提示界面协议
 */
@protocol HNoNetworkProtocol <HShowBaseProtocol>

@optional

@property (nonatomic) UIColor *bgColor;
@property (nonatomic) CGFloat marginTop;

@property (nonatomic) BOOL hideImage;

@property (nonatomic) NSString *desc;
@property (nonatomic) UIFont *descFont;
@property (nonatomic) UIColor *descColor;

@property (nonatomic) NSString *detlDesc;
@property (nonatomic) UIFont *detlDescFont;
@property (nonatomic) UIColor *detlDescColor;

- (void)resetFrame:(CGRect)frame; //手动设置frame
- (void)setScreenFrame; //frame大小与screen frame 相同
- (void)setDisplayImage:(BOOL)display; //是否展示图片，默认展示图片
- (void)setDesc:(NSString *)desc; //设置第一行文字
- (void)setDescFont:(UIFont *)font; //设置第一行文字字体
- (void)setDescColor:(UIColor *)color; //设置第一行文字颜色
- (void)setDetlDesc:(NSString *)detlDesc; //设置第二行文字
- (void)setDetlDescFont:(UIFont *)font; //设置第二行文字字体
- (void)setDetlDescColor:(UIColor *)color; //设置第二行文字颜色
- (void)setMarginTop:(CGFloat)marginTop; //设置marginTop的值
- (void)setNaviMarginTop; //设置marginTop的值为导航栏的高度
- (void)setMarginBottom:(CGFloat)marginBottom; //设置marginBottom的值
- (void)setToolBarMarginBottom; //设置marginBottom的值为iphone x的底部高度34.f
- (void)setYOffset:(CGFloat)yOffset; //设置内容垂直方向偏移量
- (void)setYRatio:(CGFloat)ratio; //按比例设置内容垂直方向偏移量
- (void)setYCenter; //设置内容垂直方向居中
- (void)setClickedBlock:(HShowClickedBlock)showClickedBlock; //设置点击事件

@end

/**
 请求失败提示界面协议
 */
@protocol HLoadErrorProtocol <HShowBaseProtocol>

@optional

@property (nonatomic) UIColor *bgColor;
@property (nonatomic) CGFloat marginTop;

@property (nonatomic) BOOL hideImage;

@property (nonatomic) NSString *desc;
@property (nonatomic) UIFont *descFont;
@property (nonatomic) UIColor *descColor;

@property (nonatomic) NSString *detlDesc;
@property (nonatomic) UIFont *detlDescFont;
@property (nonatomic) UIColor *detlDescColor;

- (void)resetFrame:(CGRect)frame; //手动设置frame
- (void)setScreenFrame; //frame大小与screen frame 相同
- (void)setDisplayImage:(BOOL)display; //是否展示图片，默认展示图片
- (void)setDesc:(NSString *)desc; //设置第一行文字
- (void)setDescFont:(UIFont *)font; //设置第一行文字字体
- (void)setDescColor:(UIColor *)color; //设置第一行文字颜色
- (void)setDetlDesc:(NSString *)detlDesc; //设置第二行文字
- (void)setDetlDescFont:(UIFont *)font; //设置第二行文字字体
- (void)setDetlDescColor:(UIColor *)color; //设置第二行文字颜色
- (void)setMarginTop:(CGFloat)marginTop; //设置marginTop的值
- (void)setNaviMarginTop; //设置marginTop的值为导航栏的高度
- (void)setMarginBottom:(CGFloat)marginBottom; //设置marginBottom的值
- (void)setToolBarMarginBottom; //设置marginBottom的值为iphone x的底部高度34.f
- (void)setYOffset:(CGFloat)yOffset; //设置内容垂直方向偏移量
- (void)setYRatio:(CGFloat)ratio; //按比例设置内容垂直方向偏移量
- (void)setYCenter; //设置内容垂直方向居中
- (void)setClickedBlock:(HShowClickedBlock)showClickedBlock; //设置点击事件

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

- (void)setTitle:(NSString *)title;
- (void)setMsg:(NSString *)msg;
- (void)setCancelTitle:(NSString *)title;
- (void)setButtonTitles:(NSArray *)titles;
- (void)setCompletionBlock:(void (^)(NSInteger buttonIndex))completionBlock;

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

- (void)setTitle:(NSString *)title;
- (void)setMsg:(NSString *)msg;
- (void)setCancelTitle:(NSString *)title;
- (void)setButtonTitles:(NSArray *)titles;
- (void)setCompletionBlock:(void (^)(NSInteger buttonIndex))completionBlock;

@end

/**
 actionsheet提示协议，网格布局
 */
@protocol HFormProtocol <HShowBaseProtocol>

@optional
- (void)setType:(NSInteger)type;
- (void)setTupleClass:(Class)cls;
- (void)setTitles:(NSArray *)titles icon:(NSArray *)icons;
- (void)setLineItems:(NSInteger)items; //一行显示几个
- (void)setPageLines:(NSInteger)lines; //一页显示几行
- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets;
- (void)setButtonBlock:(void (^)(NSInteger buttonIdex))block;
- (void)setBackgroundColor:(UIColor *)color;
- (void)setItemBackgroundColor:(UIColor *)color;

@end

/**
 toast提示协议
 */
@protocol HToastProtocol <HShowBaseProtocol>

@optional
@property (nonatomic) NSString *desc;
@property (nonatomic) NSTimeInterval delay;

- (void)setDesc:(NSString *)desc;
- (void)setDelay:(NSTimeInterval)delay;

@end

/**
 navi toast提示协议
 */
@protocol HNaviToastProtocol <HShowBaseProtocol>

@optional
@property (nonatomic) NSString *desc;
@property (nonatomic) NSString *icon;
@property (nonatomic) NSTimeInterval delay;//默认为2秒

- (void)setDesc:(NSString *)desc;
- (void)setIcon:(NSString *)name;
- (void)setDelay:(NSTimeInterval)delay; //默认为2秒

@end

