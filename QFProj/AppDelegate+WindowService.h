//
//  AppDelegate+WindowService.h
//  QFProj
//
//  Created by dqf on 2020/2/22.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "AppDelegate.h"
#import "HNavigationController.h"
#import "HMenuController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (WindowService)

+ (AppDelegate *)appDel;

//初始化window
- (void)setupWindow;

//获取当前顶部视图
+ (UIViewController *)currentViewController;

//获取(检查）指定视图
+ (UIViewController *)checkViewController:(id)className;

- (UIViewController *)topViewController;

@end

NS_ASSUME_NONNULL_END
