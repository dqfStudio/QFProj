//
//  UIImage+Util.m
//  TestProject
//
//  Created by dqf on 2017/11/8.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "UIImage+Util.h"
#import <objc/runtime.h>

@implementation UIImage (Util)

+ (UIImage *)imageFromName:(NSString *)aName {
    return [UIImage imageNamed:aName];
}

+ (UIImage *)imageFromFile:(NSString *)filePath {
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (UIImage *)imageFromData:(NSData *)imageData {
    return [UIImage imageWithData:imageData];
}

+ (UIImage *)testImage {
    return [self testImage:CGSizeMake(200, 200)];
}

+ (UIImage *)testImage:(CGSize)size {
    NSString *imageString = @"🏄";
    UIFont *font = [UIFont fontWithName:@"Menlo" size:size.height];
    UIImage *image = [self imageWithString:imageString font:font width:size.width textAlignment:NSTextAlignmentLeft];
    return image;
}

+ (UIImage *)imageWithString:(NSString *)string font:(UIFont *)font width:(CGFloat)width textAlignment:(NSTextAlignment)textAlignment {
    NSDictionary *attributeDic = @{NSFontAttributeName:font};
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, 10000)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                    attributes:attributeDic
                                       context:nil].size;
    
    if ([UIScreen.mainScreen respondsToSelector:@selector(scale)]) {
        if (UIScreen.mainScreen.scale == 2.0) {
            UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
        }else {
            UIGraphicsBeginImageContext(size);
        }
    }else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] set];
    
    CGRect rect = CGRectMake(0, 0, size.width + 1, size.height + 1);
    
    CGContextFillRect(context, rect);
    
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = textAlignment;
    
    NSDictionary *attributes = @ {
    NSForegroundColorAttributeName:[UIColor blackColor],
    NSFontAttributeName:font,
    NSParagraphStyleAttributeName:paragraph
    };
    
    [string drawInRect:rect withAttributes:attributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)mergeImage:(UIImage *)image text:(NSString *)text font:(UIFont *)textFont color:(UIColor *)textColor {
    
    if (text == nil || text.length == 0) return image;
    
    CGSize imageSize = image.size;
    
    //以image的图大小为画布创建上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, UIScreen.mainScreen.scale);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter; //文字剧中
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName:textColor,
        NSFontAttributeName:textFont,
        NSKernAttributeName: @(0.5f), //字间距
        NSParagraphStyleAttributeName:paragraph
    };
    
    //计算文本大小
    CGRect textRect = [text boundingRectWithSize:imageSize
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    
    CGFloat textWidth  = textRect.size.width;
    CGFloat textHeight = textRect.size.height;
    
    //取文本的与图片大小的最小值
    CGFloat mixTextWidth  = MIN(textWidth, imageSize.width);
    CGFloat mixTextHeight = MIN(textHeight, imageSize.height);
    
    CGRect rect = CGRectMake((imageSize.width - mixTextWidth)/2.0f,
                            (imageSize.height - mixTextHeight)/2.0f,
                             mixTextWidth,
                             mixTextHeight);
    
    [text drawInRect:rect withAttributes:attributes];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}

@end
