//
//  UIImageView+HString.h
//  QFProj
//
//  Created by wind on 2020/2/8.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HString)

#pragma mark - 默认contextSize大小

- (void)setImageWithString:(NSString *)aString stringSize:(CGFloat)fontSize;
- (void)setImageWithString:(NSString *)aString stringSize:(CGFloat)fontSize stringColor:(UIColor *)stringColor contextColor:(UIColor *)contextColor;

/// 根据字符串返回图片，此处上下文的大小默认就是字符串的大小
/// @param aString 要显示的字符串
/// @param stringFont 字符串的大小
/// @param stringColor 字符串的颜色，默认黑色
/// @param contextColor 上下文的颜色，默认白色
- (void)setImageWithString:(NSString *)aString stringFont:(UIFont *)stringFont stringColor:(UIColor *)stringColor contextColor:(UIColor *)contextColor;

#pragma mark - 可单独设置contextSize大小

- (void)setImageWithString:(NSString *)aString stringSize:(CGFloat)fontSize contextSize:(CGSize)contextSize;
- (void)setImageWithString:(NSString *)aString stringSize:(CGFloat)fontSize stringColor:(UIColor *)stringColor contextSize:(CGSize)contextSize contextColor:(UIColor *)contextColor;

/// 根据字符串返回图片
/// @param aString 要显示的字符串
/// @param stringFont 字符串的大小
/// @param stringColor 字符串的颜色，默认黑色
/// @param contextSize 上下文的大小，此处可单独设置上下文的大小
/// @param contextColor 上下文的颜色，默认白色
- (void)setImageWithString:(NSString *)aString stringFont:(UIFont *)stringFont stringColor:(UIColor *)stringColor contextSize:(CGSize)contextSize contextColor:(UIColor *)contextColor;

@end

