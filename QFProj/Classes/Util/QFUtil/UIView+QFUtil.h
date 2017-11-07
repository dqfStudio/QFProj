//
//  UIView+QFUtil.h
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 hisun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QFUtil)

#pragma mark - position

@property (nonatomic, readwrite) CGFloat x;
@property (nonatomic, readwrite) CGFloat y;
@property (nonatomic, readwrite) CGFloat width;
@property (nonatomic, readwrite) CGFloat height;


@property (nonatomic, readwrite) CGFloat sx;
@property (nonatomic, readwrite) CGFloat sy;
@property (nonatomic, readwrite) CGFloat swidth;
@property (nonatomic, readwrite) CGFloat sheight;


@property (nonatomic, readwrite) CGPoint origin;
@property (nonatomic, readwrite) CGSize  size;


@property (nonatomic, readwrite) CGFloat centerX;
@property (nonatomic, readwrite) CGFloat centerY;


@property (nonatomic, readonly)  CGFloat  minX;
@property (nonatomic, readonly)  CGFloat  minY;


@property (nonatomic, readonly)  CGFloat  midX;
@property (nonatomic, readonly)  CGFloat  midY;


@property (nonatomic, readonly)  CGFloat  maxX;
@property (nonatomic, readonly)  CGFloat  maxY;

#pragma mark - other

@property (nonatomic, strong) id userInfo;

- (void)addTarget:(id)target gestureAction:(SEL)action;


//设置视图上边角幅度
- (void)setCornerOnTop;
//设置视图下边角幅度
- (void)setCornerOnBottom;
//设置指定角的角幅度
- (void)setGivenCorner:(UIRectCorner)corners;
//设置视图所有角幅度
- (void)setAllCorner:(UIRectCorner)corners;
//去掉视图所有角幅度
- (void)setNoneCorner;


//根据视图生成图片
- (UIImage *)createImage;
- (UIImage *)createImageWithFrame:(CGRect)frame;

@end
