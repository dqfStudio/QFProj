//
//  AppDelegate+RotateService.m
//  QFProj
//
//  Created by wind on 2020/2/27.
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
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    if (AppDelegate.shouldAutorotate) {
//        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
//    }
//    return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}
@end
