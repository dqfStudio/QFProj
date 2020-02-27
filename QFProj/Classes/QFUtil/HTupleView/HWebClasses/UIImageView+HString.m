//
//  UIImageView+HString.m
//  QFProj
//
//  Created by dqf on 2020/2/8.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "UIImageView+HString.h"

@implementation UIImageView (HString)

#pragma mark - 默认contextSize大小

- (void)setImageWithString:(NSString *)aString stringSize:(CGFloat)fontSize {
    [self setImage:[self imageWithString:aString stringSize:fontSize]];
}
- (void)setImageWithString:(NSString *)aString stringSize:(CGFloat)fontSize stringColor:(UIColor *)stringColor contextColor:(UIColor *)contextColor {
    [self setImage:[self imageWithString:aString stringSize:fontSize stringColor:stringColor contextColor:contextColor]];
}

/// 根据字符串返回图片，此处上下文的大小默认就是字符串的大小
/// @param aString 要显示的字符串
/// @param stringFont 字符串的大小
/// @param stringColor 字符串的颜色，默认为黑色
/// @param contextColor 上下文的颜色，默认为白色
- (void)setImageWithString:(NSString *)aString stringFont:(UIFont *)stringFont stringColor:(UIColor *)stringColor contextColor:(UIColor *)contextColor {
    [self setImage:[self imageWithString:aString stringFont:stringFont stringColor:stringColor contextColor:contextColor]];
}

#pragma mark - 可单独设置contextSize大小

- (void)setImageWithString:(NSString *)aString stringSize:(CGFloat)fontSize contextSize:(CGSize)contextSize {
    [self setImage:[self imageWithString:aString stringSize:fontSize contextSize:contextSize]];
}
- (void)setImageWithString:(NSString *)aString stringSize:(CGFloat)fontSize stringColor:(UIColor *)stringColor contextSize:(CGSize)contextSize contextColor:(UIColor *)contextColor {
    [self setImage:[self imageWithString:aString stringSize:fontSize stringColor:stringColor contextSize:contextSize contextColor:contextColor]];
}

/// 根据字符串返回图片
/// @param aString 要显示的字符串
/// @param stringFont 字符串的大小
/// @param stringColor 字符串的颜色，默认为黑色
/// @param contextSize 上下文的大小，此处可单独设置上下文的大小
/// @param contextColor 上下文的颜色，默认为白色
- (void)setImageWithString:(NSString *)aString stringFont:(UIFont *)stringFont stringColor:(UIColor *)stringColor contextSize:(CGSize)contextSize contextColor:(UIColor *)contextColor {
    [self setImage:[self imageWithString:aString stringFont:stringFont stringColor:stringColor contextSize:contextSize contextColor:contextColor]];
}



#pragma mark - 默认contextSize大小

- (UIImage *)imageWithString:(NSString *)aString stringSize:(CGFloat)fontSize {
    return [self imageWithString:aString stringSize:fontSize stringColor:nil contextColor:nil];
}
- (UIImage *)imageWithString:(NSString *)aString stringSize:(CGFloat)fontSize stringColor:(UIColor *)stringColor contextColor:(UIColor *)contextColor {
    return [self imageWithString:aString stringFont:[UIFont systemFontOfSize:fontSize] stringColor:stringColor contextColor:contextColor];
}

/// 根据字符串返回图片，此处上下文的大小默认就是字符串的大小
/// @param aString 要显示的字符串
/// @param stringFont 字符串的大小
/// @param stringColor 字符串的颜色，默认为黑色
/// @param contextColor 上下文的颜色，默认为白色
- (UIImage *)imageWithString:(NSString *)aString stringFont:(UIFont *)stringFont stringColor:(UIColor *)stringColor contextColor:(UIColor *)contextColor {
    NSDictionary *attributeDic = @{NSFontAttributeName:stringFont};

    CGSize stringSize = [aString boundingRectWithSize:CGSizeMake(10000, 10000)
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                           attributes:attributeDic
                                              context:nil].size;

    if ([UIScreen.mainScreen respondsToSelector:@selector(scale)]) {
        if (UIScreen.mainScreen.scale == 2.0) {
            UIGraphicsBeginImageContextWithOptions(stringSize, NO, 1.0);
        }else {
            UIGraphicsBeginImageContext(stringSize);
        }
    }else {
        UIGraphicsBeginImageContext(stringSize);
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!contextColor) {
        contextColor = UIColor.whiteColor;
    }
    [contextColor set];
    CGRect rect = CGRectMake(0, 0, stringSize.width + 1, stringSize.height + 1);
    CGContextFillRect(context, rect);

    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;

    if (!stringColor) {
        stringColor = UIColor.blackColor;
    }
    NSDictionary *attributes = @{NSForegroundColorAttributeName:stringColor,
                                 NSFontAttributeName:stringFont,
                                 NSParagraphStyleAttributeName:paragraph};

    [aString drawInRect:rect withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 可单独设置contextSize大小

- (UIImage *)imageWithString:(NSString *)aString stringSize:(CGFloat)fontSize contextSize:(CGSize)contextSize {
    return [self imageWithString:aString stringSize:fontSize stringColor:nil contextSize:contextSize contextColor:nil];
}
- (UIImage *)imageWithString:(NSString *)aString stringSize:(CGFloat)fontSize stringColor:(UIColor *)stringColor contextSize:(CGSize)contextSize contextColor:(UIColor *)contextColor {
    return [self imageWithString:aString stringFont:[UIFont systemFontOfSize:fontSize] stringColor:stringColor contextSize:contextSize contextColor:contextColor];
}

/// 根据字符串返回图片
/// @param aString 要显示的字符串
/// @param stringFont 字符串的大小
/// @param stringColor 字符串的颜色，默认为黑色
/// @param contextSize 上下文的大小，此处可单独设置上下文的大小
/// @param contextColor 上下文的颜色，默认为白色
- (UIImage *)imageWithString:(NSString *)aString stringFont:(UIFont *)stringFont stringColor:(UIColor *)stringColor contextSize:(CGSize)contextSize contextColor:(UIColor *)contextColor {
    NSDictionary *attributeDic = @{NSFontAttributeName:stringFont};

    CGSize stringSize = [aString boundingRectWithSize:contextSize
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                           attributes:attributeDic
                                              context:nil].size;
    
    if ([UIScreen.mainScreen respondsToSelector:@selector(scale)]) {
        if (UIScreen.mainScreen.scale == 2.0) {
            UIGraphicsBeginImageContextWithOptions(contextSize, NO, 1.0);
        }else {
            UIGraphicsBeginImageContext(contextSize);
        }
    }else {
        UIGraphicsBeginImageContext(contextSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!contextColor) {
        contextColor = UIColor.whiteColor;
    }
    [contextColor set];
    CGRect rect = CGRectMake(contextSize.width/2-stringSize.width/2, contextSize.height/2-stringSize.height/2, stringSize.width + 1, stringSize.height + 1);
    CGContextFillRect(context, CGRectMake(0, 0, contextSize.width, contextSize.height));
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    
    if (!stringColor) {
        stringColor = UIColor.blackColor;
    }
    NSDictionary *attributes = @{NSForegroundColorAttributeName:stringColor,
                                 NSFontAttributeName:stringFont,
                                 NSParagraphStyleAttributeName:paragraph};
    
    [aString drawInRect:rect withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
