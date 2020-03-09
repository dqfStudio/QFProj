//
//  AppDelegate+NotifyService.h
//  QFProj
//
//  Created by dqf on 2020/2/22.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "AppDelegate.h"
#import "HLocalNotification.h"
#import "HRemoteNotification.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (NotifyService) <HLocalNotificationDelegate, HRemoteNotificationDelegate>

@end

NS_ASSUME_NONNULL_END
