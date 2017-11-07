//
//  UIApplication+QFUtil.h
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 hisun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UIApplication (QFUtil)

//AppDelegate
+ (AppDelegate *)appDel;

//get Window 0
+ (UIWindow *)getKeyWindow;

//get Window 0
- (UIWindow *)getKeyWindow;

//get root VC of window 0
+ (UIViewController *)getKeyWindowRootController;

//get root VC of window 0
- (UIViewController *)getKeyWindowRootController;

//get root navigation controller
+ (UINavigationController *)navi;

//get root navigation controller top
+ (UIViewController *)naviTop;

//get root tabbar vc
+ (UITabBarController *)tabbarVC;

@end
