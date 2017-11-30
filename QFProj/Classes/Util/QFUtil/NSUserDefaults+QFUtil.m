//
//  NSUserDefaults+QFUtil.m
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 hisun. All rights reserved.
//

#import "NSUserDefaults+QFUtil.h"

#define KUserDefaultsKey       @"ud_user_defaults_id"
#define KFirstLaunchKey        @"ud_first_launch"
#define KUserFirstLaunchKey    @"ud_user_first_launch"
#define KUserLoginKey          @"ud_user_login"

@implementation NSUserDefaults (QFUtil)

+ (void)setUserIdentity:(NSString *)aString {
    [NSUserDefaults saveDefaults:^(NSUserDefaults * _Nullable userDefaults) {
        [userDefaults setObject:aString forKey:KUserDefaultsKey];
    }];
}

+ (nullable id)getUserIdentity {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KUserDefaultsKey];
}

+ (nullable instancetype)theCUserDefaults {
    NSString *userKey = [[NSUserDefaults standardUserDefaults] objectForKey:KUserDefaultsKey];
    if (userKey) return [[NSUserDefaults alloc] initWithSuiteName:userKey];
    return nil;
}

+ (void)saveTheCDefaults:(void (^)(NSUserDefaults *theCUserDefaults))block {
    NSUserDefaults *userDefaults = [NSUserDefaults theCUserDefaults];
    if (userDefaults) {
        if (block) {
            block(userDefaults);
        }
        [userDefaults synchronize];
    }
}

+ (void)saveDefaults:(void (^)(NSUserDefaults *userDefaults))block {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (userDefaults) {
        if (block) {
            block(userDefaults);
        }
        [userDefaults synchronize];
    }
}

+ (void)setFirstLaunch {
    [NSUserDefaults saveDefaults:^(NSUserDefaults * _Nullable userDefaults) {
        [userDefaults setBool:YES forKey:KFirstLaunchKey];
    }];
}

+ (BOOL)isFirstLaunch {
    return [[NSUserDefaults standardUserDefaults] boolForKey:KFirstLaunchKey];
}

+ (void)setUserFirstLaunch {
    [NSUserDefaults saveTheCDefaults:^(NSUserDefaults * _Nullable theCUserDefaults) {
        [theCUserDefaults setBool:YES forKey:KUserFirstLaunchKey];
    }];
}

+ (BOOL)isUserFirstLaunch {
    NSUserDefaults *userDefaults = [NSUserDefaults theCUserDefaults];
    if (userDefaults) return [userDefaults boolForKey:KUserFirstLaunchKey];
    return NO;
}

+ (void)setUserLogin {
    [NSUserDefaults saveTheCDefaults:^(NSUserDefaults * _Nullable theCUserDefaults) {
        [theCUserDefaults setBool:YES forKey:KUserLoginKey];
    }];
}

+ (void)setUserLogout {
    [NSUserDefaults saveTheCDefaults:^(NSUserDefaults * _Nullable theCUserDefaults) {
        [theCUserDefaults setBool:NO forKey:KUserLoginKey];
    }];
}

+ (BOOL)isUserLogin {
    NSUserDefaults *userDefaults = [NSUserDefaults theCUserDefaults];
    if (userDefaults) return [userDefaults boolForKey:KUserLoginKey];
    return NO;
}

@end
