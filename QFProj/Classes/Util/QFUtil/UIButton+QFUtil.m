//
//  UIButton+QFUtil.m
//  TestProject
//
//  Created by dqf on 2017/9/23.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "UIButton+QFUtil.h"

@implementation UIButton (QFUtil)
- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)setTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
}
- (void)setFont:(UIFont *)font {
    [self.titleLabel setFont:font];
}
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [self.titleLabel setTextAlignment:textAlignment];
}
- (void)setImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}
- (void)setBackgroundImage:(UIImage *)image {
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)addTarget:(id)target action:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

//let the min respond area is 44*44
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

//图左文字右
- (void)imageAndTextWithSpacing:(CGFloat)spacing {
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
}

//图右文字左
- (void)textAndImageWithSpacing:(CGFloat)spacing {
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.frame.size.width, 0, self.imageView.frame.size.width-spacing)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width-spacing, 0, -self.titleLabel.bounds.size.width)];
}





- (void (^)(NSString *color))titleColor {
    return ^void (NSString *color) {
        [self setTitleColor:[UIColor colorWithString:color] forState:UIControlStateNormal];
    };
}

- (void (^)(NSString *color, CGFloat alpha))alTitleColor {
    return ^void (NSString *color, CGFloat alpha) {
        [self setTitleColor:[UIColor colorWithString:color alpha:alpha] forState:UIControlStateNormal];
    };
}

- (void (^)(NSString *color))bgColor {
    return ^void (NSString *color) {
        self.backgroundColor = [UIColor colorWithString:color];
    };
}

- (void (^)(NSString *color, CGFloat alpha))alBgColor {
    return ^void (NSString *color, CGFloat alpha) {
        self.backgroundColor = [UIColor colorWithString:color alpha:alpha];
    };
}

- (void (^)(CGFloat size))font {
    return ^void (CGFloat size) {
        [self.titleLabel setFont:[UIFont systemFontOfSize:size]];
    };
}

- (void (^)(NSString *aString))title {
    return ^void (NSString *aString) {
        [self setTitle:aString forState:UIControlStateNormal];
    };
}

- (void (^)(NSTextAlignment align))align {
    return ^void (NSTextAlignment align) {
        [self.titleLabel setTextAlignment:align];
    };
}

- (void (^)(UIImage *image))image {
    return ^void (UIImage *image) {
        [self setImage:image forState:UIControlStateNormal];
    };
}

- (void (^)(NSString *aString))imageName {
    return ^void (NSString *aString) {
        [self setImage:[UIImage imageNamed:aString] forState:UIControlStateNormal];
    };
}

- (void (^)(UIImage *image))bgImage {
    return ^void (UIImage *image) {
        [self setBackgroundImage:image forState:UIControlStateNormal];
    };
}

- (void (^)(NSString *aString))bgImageName {
    return ^void (NSString *aString) {
        [self setBackgroundImage:[UIImage imageNamed:aString] forState:UIControlStateNormal];
    };
}

- (void (^)(CGFloat spacing))imageTextSpacing {
    return ^void (CGFloat spacing) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    };
}

- (void (^)(CGFloat spacing))textImageSpacing {
    return ^void (CGFloat spacing) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.frame.size.width, 0, self.imageView.frame.size.width-spacing)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width-spacing, 0, -self.titleLabel.bounds.size.width)];
    };
}

@end
