//
//  NSUserDefaults+HUtil.m
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSUserDefaults+HUtil.h"

#define KUserDefaultsKey       @"ud_user_defaults_id"
#define KFirstLaunchKey        @"ud_first_launch"
#define KUserFirstLaunchKey    @"ud_user_first_launch"
#define KUserLoginKey          @"ud_user_login"

@implementation NSUserDefaults (HUtil)
+ (void)setUserDefaultsId:(NSString *)aString {
    [NSUserDefaults saveStandardDefaults:^(NSUserDefaults *_Nullable theStandardDefaults) {
        [theStandardDefaults setObject:aString forKey:KUserDefaultsKey];
    }];
}
+ (nullable id)getUserDefaultsId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KUserDefaultsKey];
}
+ (nullable instancetype)theUserDefaults {
    NSString *userKey = [[NSUserDefaults standardUserDefaults] objectForKey:KUserDefaultsKey];
    if (userKey) return [[NSUserDefaults alloc] initWithSuiteName:userKey];
    return nil;
}
+ (nullable instancetype)theStandardDefaults {
    return [NSUserDefaults standardUserDefaults];
}
+ (void)saveUserDefaults:(void (^)(NSUserDefaults *theUserDefaults))block {
    NSUserDefaults *userDefaults = [NSUserDefaults theUserDefaults];
    if (userDefaults) {
        if (block) {
            block(userDefaults);
        }
        [userDefaults synchronize];
    }
}
+ (void)saveStandardDefaults:(void (^)(NSUserDefaults *theStandardDefaults))block {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (userDefaults) {
        if (block) {
            block(userDefaults);
        }
        [userDefaults synchronize];
    }
}
+ (void)setAPPFirstLaunch {
    [NSUserDefaults saveStandardDefaults:^(NSUserDefaults *_Nullable theStandardDefaults) {
        [theStandardDefaults setBool:YES forKey:KFirstLaunchKey];
    }];
}
+ (BOOL)isAPPFirstLaunch {
    return [[NSUserDefaults standardUserDefaults] boolForKey:KFirstLaunchKey];
}
+ (void)setUserFirstLaunch {
    [NSUserDefaults saveUserDefaults:^(NSUserDefaults *_Nullable theUserDefaults) {
        [theUserDefaults setBool:YES forKey:KUserFirstLaunchKey];
    }];
}
+ (BOOL)isUserFirstLaunch {
    NSUserDefaults *userDefaults = [NSUserDefaults theUserDefaults];
    if (userDefaults) return [userDefaults boolForKey:KUserFirstLaunchKey];
    return NO;
}
+ (void)setUserLogin {
    [NSUserDefaults saveUserDefaults:^(NSUserDefaults *_Nullable theUserDefaults) {
        [theUserDefaults setBool:YES forKey:KUserLoginKey];
    }];
}
+ (void)setUserLogout {
    [NSUserDefaults saveUserDefaults:^(NSUserDefaults *_Nullable theUserDefaults) {
        [theUserDefaults setBool:NO forKey:KUserLoginKey];
    }];
}
+ (BOOL)isUserLogin {
    NSUserDefaults *userDefaults = [NSUserDefaults theUserDefaults];
    if (userDefaults) return [userDefaults boolForKey:KUserLoginKey];
    return NO;
}
@end
