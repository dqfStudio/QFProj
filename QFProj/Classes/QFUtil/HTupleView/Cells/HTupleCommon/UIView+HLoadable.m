//
//  UIView+HLoadable.m
//  QFProj
//
//  Created by dqf on 2020/3/21.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "UIView+HLoadable.h"
#import <objc/runtime.h>

@protocol HListLoadable <NSObject>
- (NSArray *)h_visibleContentViews;
@end


@interface UITableView (HCPHolder) <HListLoadable>
- (NSArray *)h_visibleContentViews;
@end
@implementation UITableView (HCPHolder)
- (NSArray *)h_visibleContentViews {
    return [self.visibleCells valueForKey:@"contentView"];
}
@end


@interface UICollectionView (HCPHolder) <HListLoadable>
- (NSArray *)h_visibleContentViews;
@end
@implementation UICollectionView (HCPHolder)
- (NSArray *)h_visibleContentViews {
    return [self.visibleCells valueForKey:@"contentView"];
}
@end


@interface UIView (HCPHolder)
- (UIView *)h_getCutoutView;
- (void)h_setCutoutView:(UIView *)aView;
- (CAGradientLayer *)h_getGradient;
- (void)h_setGradient:(CAGradientLayer *)aLayer;
- (void)h_addLoader;
- (void)h_removeLoader;
- (void)configureAndAddAnimationToGradient:(CAGradientLayer *)gradient;
- (void)addCutoutView;
@end


@interface HListLoader: NSObject
+ (void)addLoaderToViews:(NSArray *)views;
+ (void)removeLoaderFromViews:(NSArray *)views;
+ (void)addLoaderTo:(id<HListLoadable>)list;
+ (void)removeLoaderFrom:(id<HListLoadable>)list;
@end
@implementation HListLoader : NSObject
+ (void)addLoaderToViews:(NSArray *)views {
    [CATransaction begin];
    for (UIView *view in views) {
        [view h_addLoader];
    }
    [CATransaction commit];
}
+ (void)removeLoaderFromViews:(NSArray *)views {
    [CATransaction begin];
    for (UIView *view in views) {
        [view h_removeLoader];
    }
    [CATransaction commit];
}
+ (void)addLoaderTo:(id<HListLoadable>)list {
    [self addLoaderToViews:list.h_visibleContentViews];
}
+ (void)removeLoaderFrom:(id<HListLoadable>)list {
    [self removeLoaderFromViews:list.h_visibleContentViews];
}
@end


@interface UIColor (HCPHolder)
+ (UIColor *)backgroundFadedGrey;
+ (UIColor *)gradientFirstStop;
+ (UIColor *)gradientSecondStop;
@end
@implementation UIColor (HCPHolder)
+ (UIColor *)backgroundFadedGrey {
    return [UIColor colorWithRed:246.0/255.0 green:247.0/255.0 blue:248.0/255.0 alpha:1.f];
}
+ (UIColor *)gradientFirstStop {
    return [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.f];
}
+ (UIColor *)gradientSecondStop {
    return [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.f];
}
@end

@implementation UIView (HCPHolder3)
- (void)boundInside:(UIView *)superView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subview]-0-|"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:@{@"subview":self}];
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[subview]-0-|"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:@{@"subview":self}];
}
@end

@interface HCutoutView : UIView
@end
@implementation HCutoutView : UIView
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, UIColor.whiteColor.CGColor);
    CGContextFillRect(contextRef, self.bounds);

    for (UIView *view in self.superview.subviews) {
        if (view != self) {
            CGContextSetBlendMode(contextRef, kCGBlendModeClear);
            CGRect rect = view.frame;
            CGPathRef clipPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                            cornerRadius:view.layer.cornerRadius].CGPath;
            CGContextAddPath(contextRef, clipPath);
            CGContextSetFillColorWithColor(contextRef, UIColor.clearColor.CGColor);
            CGContextClosePath(contextRef);
            CGContextFillPath(contextRef);
        }
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.superview.h_getGradient.frame = self.superview.bounds;
}
@end

UInt8 cutoutHandle         = 0;
UInt8 gradientHandle       = 0;
//UInt8 loaderDuration       = 0.85;
UInt8 loaderDuration       = 1.0;
UInt8 gradientWidth        = 0.17;
UInt8 gradientFirstStop    = 0.1;

@implementation UIView (HCPHolder)

- (UIView *)h_getCutoutView {
    return objc_getAssociatedObject(self, &cutoutHandle);
}

- (void)h_setCutoutView:(UIView *)aView {
    objc_setAssociatedObject(self, &cutoutHandle, aView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAGradientLayer *)h_getGradient {
    return objc_getAssociatedObject(self, &gradientHandle);
}

- (void)h_setGradient:(CAGradientLayer *)aLayer {
    objc_setAssociatedObject(self, &gradientHandle, aLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)h_addLoader {
    CAGradientLayer *gradient = CAGradientLayer.new;
    gradient.frame = self.bounds;
    [self.layer insertSublayer:gradient atIndex:0];
    [self configureAndAddAnimationToGradient:gradient];
    [self addCutoutView];
}

- (void)h_removeLoader {
    [self.h_getCutoutView removeFromSuperview];
    [self.h_getGradient removeAllAnimations];
    [self.h_getGradient removeFromSuperlayer];
    for (UIView *view in self.subviews) {
        view.alpha = 1.f;
    }
}

- (void)configureAndAddAnimationToGradient:(CAGradientLayer *)gradient {
    gradient.startPoint = CGPointMake(-1.0 + gradientWidth, 0);
    gradient.endPoint = CGPointMake(1.0 + gradientWidth, 0);

    gradient.colors = @[(id)UIColor.backgroundFadedGrey.CGColor,
                        (id)UIColor.gradientFirstStop.CGColor,
                        (id)UIColor.gradientSecondStop.CGColor,
                        (id)UIColor.gradientFirstStop.CGColor,
                        (id)UIColor.backgroundFadedGrey.CGColor];

    NSArray *startLocations = @[@(gradient.startPoint.x),
                                @(gradient.startPoint.x),
                                @(0),
                                @(gradientWidth),
                                @(1 + gradientWidth)];
    
    gradient.locations = startLocations;
    CABasicAnimation *gradientAnimation = [CABasicAnimation animationWithKeyPath:@"locations"];
    gradientAnimation.fromValue = startLocations;
    gradientAnimation.toValue = @[@(0),
                                  @(1),
                                  @(1),
                                  @(1 + gradientWidth - gradientFirstStop),
                                  @(1 + gradientWidth)];
    
    gradientAnimation.repeatCount = CGFLOAT_MAX;
    gradientAnimation.fillMode = kCAFillModeForwards;
    gradientAnimation.removedOnCompletion = NO;
    gradientAnimation.duration = loaderDuration;
    [gradient addAnimation:gradientAnimation forKey:@"locations"];
    
    [self h_setGradient:gradient];
}

- (void)addCutoutView {
    HCutoutView *cutout = [[HCutoutView alloc] initWithFrame:self.bounds];
    cutout.backgroundColor = UIColor.clearColor;
    
    [self addSubview:cutout];
    [cutout setNeedsLayout];
    [cutout boundInside:self];
    
    for (UIView *view in self.subviews) {
        if (view != cutout) {
            view.alpha = 0.f;
        }
    }
    
    [self h_setCutoutView:cutout];
}

@end


@implementation UIView (HLoadable)
- (void)showLoader {
    self.userInteractionEnabled = NO;
    if ([self isKindOfClass:UITableView.class]) {
        [HListLoader addLoaderTo:(UITableView *)self];
    }else if ([self isKindOfClass:UICollectionView.class]) {
        [HListLoader addLoaderTo:(UICollectionView *)self];
    }else {
        [HListLoader addLoaderToViews:@[self]];
    }
}
- (void)hideLoader {
    self.userInteractionEnabled = YES;
    if ([self isKindOfClass:UITableView.class]) {
        [HListLoader removeLoaderFrom:(UITableView *)self];
    }else if ([self isKindOfClass:UICollectionView.class]) {
        [HListLoader removeLoaderFrom:(UICollectionView *)self];
    }else {
        [HListLoader removeLoaderFromViews:@[self]];
    }
}
@end
