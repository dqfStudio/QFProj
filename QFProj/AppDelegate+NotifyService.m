//
//  AppDelegate+NotifyService.m
//  QFProj
//
//  Created by dqf on 2020/2/22.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "AppDelegate+NotifyService.h"
#import "NSObject+HSwizzleUtil.h"

@implementation AppDelegate (NotifyService)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodSwizzleWithOrigSEL:@selector(application:didFinishLaunchingWithOptions:) overrideSEL:@selector(notify_application:didFinishLaunchingWithOptions:)];
        
        [[self class] methodSwizzleWithOrigSEL:@selector(application:didReceiveLocalNotification:) overrideSEL:@selector(notify_application:didReceiveLocalNotification:)];
        
        [[self class] methodSwizzleWithOrigSEL:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:) overrideSEL:@selector(notify_application:didRegisterForRemoteNotificationsWithDeviceToken:)];
        
        [[self class] methodSwizzleWithOrigSEL:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:) overrideSEL:@selector(notify_application:didReceiveRemoteNotification:fetchCompletionHandler:)];
    });
}

- (void)pushLocalNotification:(id)sender {
    if (@available(iOS 10.0, *)) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
        [[HLocalNotification shareInstance] pushLocalNotificationWithBadge:2 sound:@"notification.caf" title:@"测试1" message:@"1111111111" params:@{@"tag":@"H11111111"} trigger:trigger identifier:@"test"];
    } else {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:5];
        [[HLocalNotification shareInstance] pushLocalNotificationWithBadge:2 sound:@"notification.caf" title:@"测试1" message:@"1111111111" params:@{@"tag":@"H11111111"} fireDate:date repeatInterval:0 identifier:@"test"];
    }
}

- (BOOL)notify_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[HLocalNotification shareInstance]  setDelegate:self];
    [[HRemoteNotification shareInstance] setDelegate:self];
    [[HLocalNotification shareInstance]  setShowNotificationWhenApplicationActice:NO];
    [[HRemoteNotification shareInstance] setShowNotificationWhenApplicationActice:NO];
    
    //当本地推送和远程推送同时存在时，只需注册远程推送即可
    [[HRemoteNotification shareInstance] registerRemoteNotification];
    return [self notify_application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)notify_application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[HLocalNotification shareInstance] application:application didReceiveLocalNotification:notification];
}

- (void)notify_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[HRemoteNotification shareInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)notify_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[HRemoteNotification shareInstance] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

#pragma mark -HLocalNotificationDelegate
- (void)didReceiveLocalNotificationOnApplicationBackgroundWithUserInfo:(NSDictionary *)userInfo {
    NSLog(@"localNotification_ApplicationBackgroundWithUserInfo:%@",userInfo.description);
}

- (void)didReceiveLocalNotificationOnApplicationActiveWithUserInfo:(NSDictionary *)userInfo {
    NSLog(@"localNotification_ApplicationActiveWithUserInfo:%@",userInfo.description);
}

#pragma mark-HRemoteNotificationDelegate
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token tokenString:(NSString *)tokenString {
    NSLog(@"remoteNotification_deviceTokenString:%@",tokenString);
}

- (void)didReceiveRemoteNotificationOnApplicationActiveWithUserInfo:(NSDictionary *)userInfo {
    NSLog(@"remoteNotification_ApplicationActiveWithUserInfo:%@",userInfo.description);
}

- (void)didReceiveRemoteNotificationOnApplicationBackgroundWithUserInfo:(NSDictionary *)userInfo {
    NSLog(@"remoteNotification_ApplicationBackgroundWithUserInfo:%@",userInfo.description);
}

@end
