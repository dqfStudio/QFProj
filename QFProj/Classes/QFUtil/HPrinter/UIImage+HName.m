//
//  UIImage+HName.m
//  QFProj
//
//  Created by dqf on 2018/8/22.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "UIImage+HName.h"

@implementation UIImage (HName)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self classMethodSwizzleWithOrigSEL:@selector(imageNamed:) overrideSEL:@selector(name_imageNamed:)];
    });
}

+ (nullable UIImage *)name_imageNamed:(NSString *)name {
    UIImage *image = [self name_imageNamed:name];
    [image setAccessibilityIdentifier:name];
    return image;
}

@end
