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

+ (UIImage *(^)(NSString *name))imageName {
    return ^UIImage *(NSString *name) {
        return [UIImage imageNamed:name];
    };
}

+ (UIImage *(^)(NSString *path))imageFile {
    return ^UIImage *(NSString *path) {
        return [UIImage imageWithContentsOfFile:path];
    };
}

+ (UIImage *(^)(NSData *data))imageData {
    return ^UIImage *(NSData *data) {
        return [UIImage imageWithData:data];
    };
}

@end
