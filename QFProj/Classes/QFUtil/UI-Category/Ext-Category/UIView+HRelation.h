//
//  UIView+HRelation.h
//  TestProject
//
//  Created by dqf on 2018/4/12.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CGRect)

- (void)fitSize:(CGSize)size;
- (void)fitMarginTop:(CGFloat)marginTop;
- (void)toScreenWidth;
- (void)toScreenHeight;
- (CGFloat)getScreenWidth;
- (CGFloat)getScreenHeight;
- (CGSize)getScreenSize;

@end

@interface UIView (Paternity)

- (void)centerTo:(UIView *)v;
- (void)centerTo:(UIView *)v xOffset:(CGFloat)offset;
- (void)centerTo:(UIView *)v yOffset:(CGFloat)offset;
- (void)centerTo:(UIView *)v offset:(CGPoint)offset;

- (void)leftTo:(UIView *)v;
- (void)leftTo:(UIView *)v offset:(CGFloat)offset;

- (void)rightTo:(UIView *)v;
- (void)rightTo:(UIView *)v offset:(CGFloat)offset;

- (void)topTo:(UIView *)v;
- (void)topTo:(UIView *)v offset:(CGFloat)offset;

- (void)bottomTo:(UIView *)v;
- (void)bottomTo:(UIView *)v offset:(CGFloat)offset;

@end

@interface UIView (Brotherhood)

- (void)above:(UIView *)v;
- (void)above:(UIView *)v offset:(CGFloat)offset;

- (void)below:(UIView *)v;
- (void)below:(UIView *)v offset:(CGFloat)offset;

- (void)before:(UIView *)v;
- (void)before:(UIView *)v offset:(CGFloat)offset;

- (void)after:(UIView *)v;
- (void)after:(UIView *)v offset:(CGFloat)offset;

@end
