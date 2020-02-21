//
//  UIView+HUtil.h
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "UIScreen+HUtil.h"
#import "UIGestureRecognizer+HUtil.h"

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

/**
 *  设置圆角
 */
@property (nonatomic) CGFloat cornerRadius;

/**
 *  设置边框宽度和颜色
 */
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

@property (nonatomic) UIView *topLine;
@property (nonatomic) UIView *leftLine;
@property (nonatomic) UIView *bottomLine;
@property (nonatomic) UIView *rightLine;

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

