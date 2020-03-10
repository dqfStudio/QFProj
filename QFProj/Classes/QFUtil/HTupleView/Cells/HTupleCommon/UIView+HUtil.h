//
//  UIView+HUtil.h
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "UIDevice+HUtil.h"
#import "UIScreen+HUtil.h"
#import "UIGestureRecognizer+HUtil.h"

// 基准屏幕宽度
#define HRefereWidth  375.0

// 以屏幕宽度为固定比例关系，来计算对应的值。假设：基准屏幕宽度375，floatV=10；当前屏幕宽度为750时，那么返回的值为20
#define HAdaptWidth(floatValue) (floatValue *UIScreen.width/HRefereWidth)

typedef NS_ENUM(NSInteger, HAdaptScreenWidthType) {
    HAdaptScreenWidthTypeConstraint = 1<<0, /* 对约束的constant等比例 */
    HAdaptScreenWidthTypeFrameHeight = 1<<1, /* 对frameHeight等比例 */
    HAdaptScreenWidthTypeFrameSize = 1<<2, /* 对frameSize等比例 */
    HAdaptScreenWidthTypeFontSize = 1<<3, /* 对字体等比例 */
    HAdaptScreenWidthTypeCornerRadius = 1<<4, /* 对圆角等比例 */
    HAdaptScreenWidthTypeAll = 1<<5 /* 对现有支持的属性等比例 */
};

@interface UIView (HUtil)

#pragma mark - Init
#pragma mark -

/**
 *  根据nib name返回UIView
 */
+ (instancetype)viewWithNibName:(NSString *)name;

/**
 *  根据nib创建一个view，nib name为ClassName
 */
+ (instancetype)viewFromNib;

#pragma mark - Frame
#pragma mark -

@property (nonatomic, readwrite) CGFloat h_x;
@property (nonatomic, readwrite) CGFloat h_y;
@property (nonatomic, readwrite) CGFloat h_width;
@property (nonatomic, readwrite) CGFloat h_height;


@property (nonatomic, readwrite) CGPoint h_origin;
@property (nonatomic, readwrite) CGSize  h_size;


@property (nonatomic, readwrite) CGFloat h_centerX;
@property (nonatomic, readwrite) CGFloat h_centerY;


@property (nonatomic, readonly)  CGFloat  h_minX;
@property (nonatomic, readonly)  CGFloat  h_minY;


@property (nonatomic, readonly)  CGFloat  h_midX;
@property (nonatomic, readonly)  CGFloat  h_midY;


@property (nonatomic, readonly)  CGFloat  h_maxX;
@property (nonatomic, readonly)  CGFloat  h_maxY;

#pragma mark - 上下左右边角
#pragma mark -

//设置圆角
@property (nonatomic) CGFloat cornerRadius;

//设置边框宽度和颜色
- (void)setBoarderWith:(CGFloat)width color:(UIColor *)color;

//设置视图上边角幅度
- (void)setTopCorner:(CGFloat)radii;
//设置视图下边角幅度
- (void)setBottomCorner:(CGFloat)radii;
//设置指定角的角幅度
- (void)setCorner:(UIRectCorner)corners radii:(CGFloat)radii;
//设置视图所有角幅度
- (void)setAllCorner:(CGFloat)radii;
//去掉视图所有角幅度
- (void)setNoneCorner;

#pragma mark - 上下左右边线
#pragma mark -

@property (nonatomic, readonly) UIView *topLine;
@property (nonatomic, readonly) UIView *leftLine;
@property (nonatomic, readonly) UIView *bottomLine;
@property (nonatomic, readonly) UIView *rightLine;

- (void)addTopLineWithSize:(CGFloat)size color:(UIColor *)color paddingLeft:(CGFloat)left paddingRight:(CGFloat)right;
- (void)addBottomLineWithSize:(CGFloat)size color:(UIColor *)color paddingLeft:(CGFloat)left paddingRight:(CGFloat)right;

- (void)addLeftLineWithSize:(CGFloat)size color:(UIColor *)color paddingTop:(CGFloat)top paddingBottom:(CGFloat)bottom;
- (void)addRightLineWithSize:(CGFloat)size color:(UIColor *)color paddingTop:(CGFloat)top paddingBottom:(CGFloat)bottom;

#pragma mark - Tap Gesture
#pragma mark -

/**
 *  添加双击事件
 */
- (UITapGestureRecognizer *)addDoubleTapGestureWithBlock:(void (^)(UITapGestureRecognizer *recognizer))block;

/**
 *  添加单击事件，多次调用只会持有一个UITapGestureRecognizer对象，之前的会被清除
 */
- (UITapGestureRecognizer *)addSingleTapGestureWithBlock:(void (^)(UITapGestureRecognizer *recognizer))block;
- (UITapGestureRecognizer *)addSingleTapGestureTarget:(id)target action:(SEL)action;

#pragma mark - adapt screen
#pragma mark -

/**
 遍历当前view对象的subviews和constraints，对目标进行等比例换算
 
 @param type 想要和基准屏幕等比例换算的属性类型
 @param exceptViews 需要对哪些类进行例外
 */
- (void)adaptScreenWidthWithType:(HAdaptScreenWidthType)type exceptViews:(NSArray<Class> *)exceptViews;

- (void)adaptScreenWidthWithType:(HAdaptScreenWidthType)type;

#pragma mark - other
#pragma mark -

/**
 *  返回它所在的ViewController
 */
- (UIViewController *)viewController;

/**
 *  生成快照图像
 */
- (UIImage *)snapshotImage;
- (UIImage *)snapshotImageWithFrame:(CGRect)frame;

- (NSData *)snapshotData;
- (NSData *)snapshotDataWithFrame:(CGRect)frame;

/**
 *  生成快照PDF
 */
- (NSData *)snapshotPDF;

@end

#pragma mark - autoresize easy
#pragma mark -

#define ALWAYS_FULL(view) view.autoresizingMask = (UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)
#define ALWAYS_BOTTOM(view) view.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin)
#define ALWAYS_RIGHT(view) view.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin)
#define ALWAYS_CENTER(view) view.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)
#define ALWAYS_BW(view) view.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth)

