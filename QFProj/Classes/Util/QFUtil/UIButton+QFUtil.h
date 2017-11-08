//
//  UIButton+QFUtil.h
//  TestProject
//
//  Created by dqf on 2017/9/23.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+QFUtil.h"

@interface UIButton (QFUtil)
- (void)setTitle:(NSString *)title;
- (void)setTitleColor:(UIColor *)color;
- (void)setFont:(UIFont *)font;
- (void)setTextAlignment:(NSTextAlignment)textAlignment;
- (void)setImage:(UIImage *)image;
- (void)setBackgroundImage:(UIImage *)image;
- (void)addTarget:(id)target action:(SEL)action;

//图左文字右
- (void)imageAndTextWithSpacing:(CGFloat)spacing;
//图右文字左
- (void)textAndImageWithSpacing:(CGFloat)spacing;


- (void (^)(NSString *color))titleColor;
- (void (^)(NSString *color, CGFloat alpha))alTitleColor;

- (void (^)(NSString *color))bgColor;
- (void (^)(NSString *color, CGFloat alpha))alBgColor;

- (void (^)(CGFloat size))font;
- (void (^)(NSString *aString))title;
- (void (^)(NSTextAlignment align))align;

- (void (^)(UIImage *image))image;
- (void (^)(NSString *aString))imageName;

- (void (^)(UIImage *image))bgImage;
- (void (^)(NSString *aString))bgImageName;

- (void (^)(CGFloat spacing))imageTextSpacing;
- (void (^)(CGFloat spacing))textImageSpacing;

@end
