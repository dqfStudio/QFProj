//
//  AppDelegate+WindowService.m
//  QFProj
//
//  Created by dqf on 2020/2/22.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "AppDelegate+WindowService.h"

@implementation AppDelegate (WindowService)

+ (AppDelegate *)appDel {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

//初始化window
- (void)setupWindow {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    HNavigationController *navController = [[HNavigationController alloc] initWithRootViewController:HMenuController.new];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
}

//获取当前顶部视图
+ (UIViewController *)currentViewController {
   UIWindow *window = [[UIApplication sharedApplication] keyWindow];
   if (window.windowLevel != UIWindowLevelNormal) {
       NSArray *windows = [[UIApplication sharedApplication] windows];
       for (UIWindow *tmpWindow in windows){
           if (tmpWindow.windowLevel == UIWindowLevelNormal) {
               window = tmpWindow;
               break;
           }
       }
   }
   UIViewController *result = window.rootViewController;
   while (result.presentedViewController) {
       result = result.presentedViewController;
   }
   if ([result isKindOfClass:UITabBarController.class]) {
       result = [(UITabBarController *)result selectedViewController];
   }else if ([result isKindOfClass:UINavigationController.class]) {
       result = [(UINavigationController *)result topViewController];
   }
   return result;
}

//获取(检查）指定视图
+ (UIViewController *)checkViewController:(id)className {
    if (className == nil) return nil;
    Class class = className;
    if ([className isKindOfClass:NSString.class]) {
        class = NSClassFromString(className);
    }
    for (UIViewController *vc in UIApplication.navi.viewControllers) {
        if ([vc isKindOfClass:class]) {
            return vc;
        }
    }
    return nil;
}

@end

