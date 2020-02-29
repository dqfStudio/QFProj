//
//  AppDelegate+RotateService.m
//  QFProj
//
//  Created by dqf on 2020/2/27.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "AppDelegate+RotateService.h"
#import <objc/runtime.h>

@implementation AppDelegate (RotateService)
+ (BOOL)shouldAutorotate {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
+ (void)setShouldAutorotate:(BOOL)shouldAutorotate {
    objc_setAssociatedObject(self, @selector(shouldAutorotate), @(shouldAutorotate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIDeviceOrientationStyle)orientationStyle {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
+ (void)setOrientationStyle:(UIDeviceOrientationStyle)orientationStyle {
    objc_setAssociatedObject(self, @selector(orientationStyle), @(orientationStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (AppDelegate.shouldAutorotate) {
        if (AppDelegate.orientationStyle  == UIDeviceOrientationStyleVertical) {// 竖屏
            return UIInterfaceOrientationMaskPortrait;
        }else if (AppDelegate.orientationStyle == UIDeviceOrientationStyleHorizontal) {// 横屏
            return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
        }else if (AppDelegate.orientationStyle == UIDeviceOrientationStyleHorizontalLeft) {// 横屏左旋转
            return UIInterfaceOrientationMaskLandscapeLeft;
        }else if (AppDelegate.orientationStyle == UIDeviceOrientationStyleHorizontalRight) {// 横屏右旋转
            return UIInterfaceOrientationMaskLandscapeRight;
        }
    }
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    
}
@end
