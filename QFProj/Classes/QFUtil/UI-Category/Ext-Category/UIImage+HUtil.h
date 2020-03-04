//
//  UIImage+HUtil.h
//  HProj
//
//  Created by dqf on 2017/11/8.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HUtil)

+ (UIImage *)imageFromName:(NSString *)aName;
+ (UIImage *)imageFromFile:(NSString *)filePath;
+ (UIImage *)imageFromData:(NSData *)imageData;

+ (UIImage *)testImage;//默认200*200
+ (UIImage *)testImage:(CGSize)size;

+ (UIImage *)mergeImage:(UIImage *)imageSource tagertImage:(UIImage *)targetImage;

+ (UIImage *)mergeImage:(UIImage *)image text:(NSString *)text font:(UIFont *)textFont color:(UIColor *)textColor;

@end
