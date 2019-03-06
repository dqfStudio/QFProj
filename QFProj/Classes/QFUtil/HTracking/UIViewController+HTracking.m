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

#pragma mark - Method Swizzling

- (void)tracking_viewWillAppear:(BOOL)animated {
    [self tracking_viewWillAppear:animated];
    NSLog(@"你现在进入%@",NSStringFromClass([self class]));
}

- (void)tracking_viewWillDisappear:(BOOL)animated {
    [self tracking_viewWillDisappear:animated];
    NSLog(@"你现在退出%@",NSStringFromClass([self class]));
}

@end
