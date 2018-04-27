//
//  UIImage+HChain.m
//  TestProject
//
//  Created by dqf on 2018/4/24.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "UIImage+HChain.h"
#import <objc/runtime.h>

@implementation UIImage (HChain)

+ (UIImage *(^)(NSString *name))fromName {
    return ^UIImage *(NSString *name) {
        return [UIImage imageNamed:name];
    };
}

+ (UIImage *(^)(NSString *path))fromFile {
    return ^UIImage *(NSString *path) {
        return [UIImage imageWithContentsOfFile:path];
    };
}

+ (UIImage *(^)(NSData *data))fromData {
    return ^UIImage *(NSData *data) {
        return [UIImage imageWithData:data];
    };
}

@end

