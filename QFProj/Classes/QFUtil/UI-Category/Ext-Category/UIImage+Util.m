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

@end
