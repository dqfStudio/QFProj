//
//  UIButton+HUtil.m
//  TestProject
//
//  Created by dqf on 2017/9/23.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "UIButton+HUtil.h"

@implementation UIButton (HUtil)
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

//图上文字下
- (void)imageUpAndTextDownWithSpacing:(CGFloat)spacing {
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, -self.imageView.frame.size.height-spacing/2, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height-spacing/2, 0, 0, -self.titleLabel.intrinsicContentSize.width);
}

@end
