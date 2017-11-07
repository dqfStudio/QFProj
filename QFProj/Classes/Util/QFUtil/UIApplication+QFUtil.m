
//
//  UIApplication+QFUtil.m
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 hisun. All rights reserved.
//

#import "UIApplication+QFUtil.h"

@implementation UIApplication (QFUtil)

+ (AppDelegate *)appDel {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (UIWindow *)getKeyWindow {
    return [[UIApplication sharedApplication] getKeyWindow];
}
- (UIWindow *)getKeyWindow {
    UIWindow *window = self.windows[0];
    return window;
}

+ (UIViewController *)getKeyWindowRootController {
    return [[UIApplication sharedApplication] getKeyWindowRootController];
}
- (UIViewController *)getKeyWindowRootController {
    UIWindow *keyWindow = [self getKeyWindow];
    return keyWindow.rootViewController;
}

//get root navigation controller
+ (UINavigationController *)navi {
    UIViewController *navi = [self getKeyWindowRootController];
    if ([navi isKindOfClass:[UINavigationController class]])
    {
        return (UINavigationController *)navi;
    }
    else return nil;
}

//get root navigation controller top
+ (UIViewController *)naviTop {
    UIViewController *navi = [self getKeyWindowRootController];
    if ([navi isKindOfClass:[UINavigationController class]])
    {
        return [(UINavigationController *)navi topViewController];
    }
    else return nil;
}

//get root tabbar vc
+ (UITabBarController *)tabbarVC {
    UIViewController *tabVC = [self getKeyWindowRootController];
    if ([tabVC isKindOfClass:[UITabBarController class]])
    {
        return (UITabBarController *)tabVC;
    }
    else return nil;
}

@end
