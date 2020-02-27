//
//  UIViewController+HTracking.m
//  QFProj
//
//  Created by dqf on 2018/7/28.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "UIViewController+HTracking.h"

@implementation UIViewController (HTracking)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodSwizzleWithOrigSEL:@selector(viewWillAppear:) overrideSEL:@selector(tracking_viewWillAppear:)];
        [[self class] methodSwizzleWithOrigSEL:@selector(viewWillDisappear:) overrideSEL:@selector(tracking_viewWillDisappear:)];
    });
}
- (void)tracking_viewWillAppear:(BOOL)animated {
    [self tracking_viewWillAppear:animated];
    if (![self isSystemClass:self.class]) {
        printf("HPrinting-->你现已进入%s\n", NSStringFromClass(self.class).UTF8String);
    }
}
- (void)tracking_viewWillDisappear:(BOOL)animated {
    [self tracking_viewWillDisappear:animated];
    if (![self isSystemClass:self.class]) {
        printf("HPrinting-->你现已退出%s\n", NSStringFromClass(self.class).UTF8String);
    }
}
@end
