//
//  HView+HLine.m
//  QFProj
//
//  Created by wind on 2020/2/8.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HView+HLine.h"
#import <objc/runtime.h>

static char const * const KTopLineViewKey = "KTopLineViewKey";
static char const * const KBottomLineView = "KBottomLineView";
static char const * const KLeftLineView   = "KLeftLineView";
static char const * const KRightLineView  = "RightLineView";

#define KLineDefaultColor [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0]

@implementation UIView (HLine)

#pragma mark - size

- (CGFloat)topLineSize {
    CGFloat size = [[self getAssociatedValueForKey:_cmd] integerValue];
    if (size <= 0) size = 1.0;
    return size;
}
- (void)setTopLineSize:(CGFloat)topLineSize {
    [self setAssociateValue:@(topLineSize) withKey:@selector(topLineSize)];
}

- (CGFloat)bottomLineSize {
    CGFloat size = [[self getAssociatedValueForKey:_cmd] integerValue];
    if (size <= 0) size = 1.0;
    return size;
}
- (void)setBottomLineSize:(CGFloat)bottomLineSize {
    [self setAssociateValue:@(bottomLineSize) withKey:@selector(bottomLineSize)];
}

- (CGFloat)leftLineSize {
    CGFloat size = [[self getAssociatedValueForKey:_cmd] integerValue];
    if (size <= 0) size = 1.0;
    return size;
}
- (void)setLeftLineSize:(CGFloat)leftLineSize {
    [self setAssociateValue:@(leftLineSize) withKey:@selector(leftLineSize)];
}

- (CGFloat)rightLineSize {
    CGFloat size = [[self getAssociatedValueForKey:_cmd] integerValue];
    if (size <= 0) size = 1.0;
    return size;
}
- (void)setRightLineSize:(CGFloat)rightLineSize {
    [self setAssociateValue:@(rightLineSize) withKey:@selector(rightLineSize)];
}


#pragma mark - color

- (UIColor *)topLineColor {
    UIColor *color = [self getAssociatedValueForKey:_cmd];
    if (!color) color = KLineDefaultColor;
    return color;
}
- (void)setTopLineColor:(UIColor *)topLineColor {
    [self setAssociateValue:topLineColor withKey:@selector(topLineColor)];
}

- (UIColor *)bottomLineColor {
    UIColor *color = [self getAssociatedValueForKey:_cmd];
    if (!color) color = KLineDefaultColor;
    return color;
}
- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    [self setAssociateValue:bottomLineColor withKey:@selector(bottomLineColor)];
}

- (UIColor *)leftLineColor {
    UIColor *color = [self getAssociatedValueForKey:_cmd];
    if (!color) color = KLineDefaultColor;
    return color;
}
- (void)setLeftLineColor:(UIColor *)leftLineColor {
    [self setAssociateValue:leftLineColor withKey:@selector(leftLineColor)];
}

- (UIColor *)rightLineColor {
    UIColor *color = [self getAssociatedValueForKey:_cmd];
    if (!color) color = KLineDefaultColor;
    return color;
}
- (void)setRightLineColor:(UIColor *)rightLineColor {
    [self setAssociateValue:rightLineColor withKey:@selector(rightLineColor)];
}


#pragma mark - view

- (BOOL)showTopLineView {
    UIView *lineView = objc_getAssociatedObject(self, KTopLineViewKey);
    if (lineView.superview) {
        return YES;
    }
    return NO;
}
- (void)setShowTopLineView:(BOOL)showTopLineView {
    UIView *lineView = objc_getAssociatedObject(self, KTopLineViewKey);
    if (showTopLineView) {
        if (!lineView) {
            lineView = UIView.new;
            lineView.backgroundColor = self.topLineColor;
            lineView.frame = CGRectMake(0, 0, self.bounds.size.width, self.topLineSize);
            lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            objc_setAssociatedObject(self, KTopLineViewKey, lineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (![self.subviews containsObject:lineView]) {
            [self addSubview:lineView];
        }
    }else if (lineView) {
        [lineView removeFromSuperview];
    }
}


- (BOOL)showBottomLineView {
    UIView *lineView = objc_getAssociatedObject(self, KBottomLineView);
    if (lineView.superview) {
        return YES;
    }
    return NO;
}
- (void)setShowBottomLineView:(BOOL)showBottomLineView {
    UIView *lineView = objc_getAssociatedObject(self, KBottomLineView);
    if (showBottomLineView) {
        if (!lineView) {
            lineView = UIView.new;
            lineView.backgroundColor = self.bottomLineColor;
            lineView.frame = CGRectMake(0, self.bounds.size.height-self.bottomLineSize, self.bounds.size.width, self.bottomLineSize);
            lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            objc_setAssociatedObject(self, KBottomLineView, lineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (![self.subviews containsObject:lineView]) {
            [self addSubview:lineView];
        }
    }else if (lineView) {
        [lineView removeFromSuperview];
    }
}


- (BOOL)showLeftLineView {
    UIView *lineView = objc_getAssociatedObject(self, KLeftLineView);
    if (lineView.superview) {
        return YES;
    }
    return NO;
}
- (void)setShowLeftLineView:(BOOL)showLeftLineView {
    UIView *lineView = objc_getAssociatedObject(self, KLeftLineView);
    if (showLeftLineView) {
        if (!lineView) {
            lineView = UIView.new;
            lineView.backgroundColor = self.leftLineColor;
            lineView.frame = CGRectMake(0, 0, self.leftLineSize, self.bounds.size.height);
            lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            objc_setAssociatedObject(self, KLeftLineView, lineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (![self.subviews containsObject:lineView]) {
            [self addSubview:lineView];
        }
    }else if (lineView) {
        [lineView removeFromSuperview];
    }
}


- (BOOL)showRightLineView {
    UIView *lineView = objc_getAssociatedObject(self, KRightLineView);
    if (lineView.superview) {
        return YES;
    }
    return NO;
}
- (void)setShowRightLineView:(BOOL)showRightLineView {
    UIView *lineView = objc_getAssociatedObject(self, KRightLineView);
    if (showRightLineView) {
        if (!lineView) {
            lineView = UIView.new;
            lineView.backgroundColor = self.rightLineColor;
            lineView.frame = CGRectMake(self.bounds.size.width-self.rightLineSize, 0, self.rightLineSize, self.bounds.size.height);
            lineView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
            objc_setAssociatedObject(self, KRightLineView, lineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (![self.subviews containsObject:lineView]) {
            [self addSubview:lineView];
        }
    }else if (lineView) {
        [lineView removeFromSuperview];
    }
}

@end
