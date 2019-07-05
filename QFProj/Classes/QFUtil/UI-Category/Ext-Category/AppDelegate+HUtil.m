//
//  AppDelegate+HUtil.m
//  QFProj
//
//  Created by wind on 2019/7/5.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "AppDelegate+HUtil.h"

@implementation AppDelegate (HUtil)
+ (BOOL)shouldAutorotate {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
+ (void)setShouldAutorotate:(BOOL)shouldAutorotate {
    objc_setAssociatedObject(self, @selector(shouldAutorotate), @(shouldAutorotate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (UIInterfaceOrientationMask)interfaceOrientation {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
+ (void)setInterfaceOrientation:(UIInterfaceOrientationMask)interfaceOrientation {
    objc_setAssociatedObject(self, @selector(interfaceOrientation), @(interfaceOrientation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (AppDelegate.shouldAutorotate) {
        return AppDelegate.interfaceOrientation;
    }
    return UIInterfaceOrientationMaskPortrait;
}
@end
