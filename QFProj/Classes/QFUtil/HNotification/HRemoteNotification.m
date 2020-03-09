//
//  HRemoteNotification.m
//  QFProj
//
//  Created by wind on 2020/3/9.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HRemoteNotification.h"

@implementation HRemoteNotification

+ (instancetype)shareInstance {
    static HRemoteNotification *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HRemoteNotification alloc] init];
        instance.showNotificationWhenApplicationActice = YES;
    });
    return instance;
}

- (void)registerRemoteNotification {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        center.delegate = self;
    } else {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)setApplicationIconBadgeNumber:(NSInteger)badge {
    if (badge < 0) {
        badge = 0;
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
}

- (void)clearApplicationIconBadge {
    [self setApplicationIconBadgeNumber:0];
}

#pragma mark -UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    if (self.showNotificationWhenApplicationActice) {
        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    } else {
        NSDictionary *userInfo = notification.request.content.userInfo;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveRemoteNotificationOnApplicationActiveWithUserInfo:)]) {
            [self.delegate didReceiveRemoteNotificationOnApplicationActiveWithUserInfo:userInfo];
        }
        completionHandler(0);
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveRemoteNotificationOnApplicationActiveWithUserInfo:)]) {
            [self.delegate didReceiveRemoteNotificationOnApplicationActiveWithUserInfo:userInfo];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveRemoteNotificationOnApplicationBackgroundWithUserInfo:)]) {
            [self.delegate didReceiveRemoteNotificationOnApplicationBackgroundWithUserInfo:userInfo];
        }
    }
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveRemoteNotificationOnApplicationActiveWithUserInfo:)]) {
            [self.delegate didReceiveRemoteNotificationOnApplicationActiveWithUserInfo:userInfo];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveRemoteNotificationOnApplicationBackgroundWithUserInfo:)]) {
            [self.delegate didReceiveRemoteNotificationOnApplicationBackgroundWithUserInfo:userInfo];
        }
    }
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRegisterForRemoteNotificationsWithDeviceToken:tokenString:)]) {
        NSString *deviceString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        deviceString = [deviceString stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self.delegate didRegisterForRemoteNotificationsWithDeviceToken:deviceToken tokenString:deviceString];
    }
}

@end
