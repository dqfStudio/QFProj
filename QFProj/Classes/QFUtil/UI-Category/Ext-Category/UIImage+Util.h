//
//  UIImage+Util.h
//  TestProject
//
//  Created by dqf on 2017/11/8.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)

+ (UIImage *)imageFromName:(NSString *)aName;
+ (UIImage *)imageFromFile:(NSString *)filePath;
+ (UIImage *)imageFromData:(NSData *)imageData;

+ (UIImage *)testImage;//默认200*200
+ (UIImage *)testImage:(CGSize)size;

@end
