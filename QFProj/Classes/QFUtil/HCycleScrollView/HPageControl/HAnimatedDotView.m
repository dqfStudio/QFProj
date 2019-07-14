//
//  HAnimatedDotView.m
//  HPageControl
//
//  Created by Tanguy Aladenise on 2015-01-22.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

#import "HAnimatedDotView.h"

static CGFloat const kHAnimateDuration = 1;

@implementation HAnimatedDotView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    return self;
}
- (void)setDotColor:(UIColor *)dotColor {
    _dotColor = dotColor;
    self.layer.borderColor  = dotColor.CGColor;
}
- (void)initialization {
    _dotColor = [UIColor whiteColor];
    self.backgroundColor    = [UIColor clearColor];
    self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2;
    self.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.layer.borderWidth  = 2;
}
- (void)changeActivityState:(BOOL)active {
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDeactiveState];
    }
}
- (void)animateToActiveState {
    [UIView animateWithDuration:kHAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = self->_dotColor;
        self.transform = CGAffineTransformMakeScale(1.4, 1.4);
    } completion:nil];
}
- (void)animateToDeactiveState {
    [UIView animateWithDuration:kHAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}
@end
