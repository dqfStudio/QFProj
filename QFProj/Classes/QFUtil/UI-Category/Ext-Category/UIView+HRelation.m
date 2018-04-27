//
//  UIView+HRelation.m
//  TestProject
//
//  Created by dqf on 2018/4/12.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "UIView+HRelation.h"

@implementation UIView (CGRect)

- (void)fitSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)fitMarginTop:(CGFloat)marginTop {
    CGRect frame = self.frame;
    frame.origin.y += marginTop;
    frame.size.height -= marginTop;
    self.frame = frame;
}

- (void)toScreenWidth {
    CGRect frame = self.frame;
    frame.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.frame = frame;
}

- (void)toScreenHeight {
    CGRect frame = self.frame;
    frame.size.height = CGRectGetHeight([UIScreen mainScreen].bounds);
    self.frame = frame;
}

- (CGFloat)getScreenWidth {
    return CGRectGetWidth([UIScreen mainScreen].bounds);
}
- (CGFloat)getScreenHeight {
    return CGRectGetHeight([UIScreen mainScreen].bounds);
}
- (CGSize)getScreenSize {
    return [UIScreen mainScreen].bounds.size;
}

@end

@implementation UIView (Paternity)

- (void)centerTo:(UIView *)v {
    [self centerTo:v offset:CGPointZero];
}
- (void)centerTo:(UIView *)v xOffset:(CGFloat)offset {
    [self centerTo:v offset:CGPointMake(offset, 0.f)];
}
- (void)centerTo:(UIView *)v yOffset:(CGFloat)offset {
    [self centerTo:v offset:CGPointMake(0.f, offset)];
}
- (void)centerTo:(UIView *)v offset:(CGPoint)offset {
    CGPoint center = v.center;
    center.x += offset.x;
    center.y += offset.y;
    self.center = center;
}

- (void)leftTo:(UIView *)v {
    [self leftTo:v offset:0.f];
}
- (void)leftTo:(UIView *)v offset:(CGFloat)offset {
    CGRect frame1, frame2;
    frame1 = self.frame;
    frame2 = v.frame;
    frame1.origin.x = frame2.origin.x + offset;
    self.frame = frame1;
}

- (void)rightTo:(UIView *)v {
    [self rightTo:v offset:0.f];
}
- (void)rightTo:(UIView *)v offset:(CGFloat)offset {
    CGRect frame1, frame2;
    frame1 = self.frame;
    frame2 = v.frame;
    frame1.origin.x = frame2.size.width - frame1.size.width + offset;
    self.frame = frame1;
}

- (void)topTo:(UIView *)v {
    [self topTo:v offset:0.f];
}
- (void)topTo:(UIView *)v offset:(CGFloat)offset {
    CGRect frame1, frame2;
    frame1 = self.frame;
    frame2 = v.frame;
    frame1.origin.y = frame2.origin.y + offset;
    self.frame = frame1;
}

- (void)bottomTo:(UIView *)v {
    [self bottomTo:v offset:0.f];
}
- (void)bottomTo:(UIView *)v offset:(CGFloat)offset {
    CGRect frame1, frame2;
    frame1 = self.frame;
    frame2 = v.frame;
    frame1.origin.y = frame2.size.height - frame1.size.height + offset;
    self.frame = frame1;
}

@end

@implementation UIView (Brotherhood)

- (void)above:(UIView *)v {
    [self above:v offset:0.f];
    
}
- (void)above:(UIView *)v offset:(CGFloat)offset {
    CGRect frame1, frame2;
    frame1 = self.frame;
    frame2 = v.frame;
    frame1.origin.y = frame2.origin.y - frame1.size.height - offset;
    self.frame = frame1;
}

- (void)below:(UIView *)v {
    [self below:v offset:0.f];
}
- (void)below:(UIView *)v offset:(CGFloat)offset {
    CGRect frame1, frame2;
    frame1 = self.frame;
    frame2 = v.frame;
    frame1.origin.y = frame2.origin.y + frame2.size.height + offset;
    self.frame = frame1;
}

- (void)before:(UIView *)v {
    [self before:v offset:0.f];
}
- (void)before:(UIView *)v offset:(CGFloat)offset {
    CGRect frame1, frame2;
    frame1 = self.frame;
    frame2 = v.frame;
    frame1.origin.x = frame2.origin.x - frame1.size.width - offset;
    self.frame = frame1;
}

- (void)after:(UIView *)v {
    [self after:v offset:0.f];
}
- (void)after:(UIView *)v offset:(CGFloat)offset {
    CGRect frame1, frame2;
    frame1 = self.frame;
    frame2 = v.frame;
    frame1.origin.x = frame2.origin.x + frame2.size.width + offset;
    self.frame = frame1;
}

@end
