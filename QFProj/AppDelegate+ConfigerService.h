//
//  AppDelegate+ConfigerService.h
//  QFProj
//
//  Created by wind on 2020/2/22.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

#define K_NETWORK_CHANGE_NOTIFICATION  @"networkChangeNotification"

@interface AppDelegate (ConfigerService)

//键盘管理
- (void)setupKeyboardManager;

//网络状态监听
- (void)setupAFNReachability;

@end

NS_ASSUME_NONNULL_END
