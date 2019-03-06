//
//  NSUserDefaults+HUtil.m
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 hisun. All rights reserved.
//

#import "NSUserDefaults+HUtil.h"

#define KUserDefaultsKey       @"ud_user_defaults_id"
#define KFirstLaunchKey        @"ud_first_launch"
#define KUserFirstLaunchKey    @"ud_user_first_launch"
#define KUserLoginKey          @"ud_user_login"

@implementation NSUserDefaults (HUtil)

+ (void)setCURUIdentity:(NSString *)aString {
    [NSUserDefaults saveSTDUDefaults:^(NSUserDefaults * _Nullable theSTDUDefaults) {
        [theSTDUDefaults setObject:aString forKey:KUserDefaultsKey];
    }];
}

+ (nullable id)getCURUIdentity {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KUserDefaultsKey];
}

+ (nullable instancetype)theCURUDefaults {
    NSString *userKey = [[NSUserDefaults standardUserDefaults] objectForKey:KUserDefaultsKey];
    if (userKey) return [[NSUserDefaults alloc] initWithSuiteName:userKey];
    return nil;
}

+ (nullable instancetype)theSTDUDefaults {
    return [NSUserDefaults standardUserDefaults];
}

+ (void)saveCURUDefaults:(void (^)(NSUserDefaults *theCURUDefaults))block {
    NSUserDefaults *userDefaults = [NSUserDefaults theCURUDefaults];
    if (userDefaults) {
        if (block) {
            block(userDefaults);
        }
        [userDefaults synchronize];
    }
}

+ (void)saveSTDUDefaults:(void (^)(NSUserDefaults *theSTDUDefaults))block {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (userDefaults) {
        if (block) {
            block(userDefaults);
        }
        [userDefaults synchronize];
    }
}

+ (void)setAPPFirstLaunch {
    [NSUserDefaults saveSTDUDefaults:^(NSUserDefaults * _Nullable theSTDUDefaults) {
        [theSTDUDefaults setBool:YES forKey:KFirstLaunchKey];
    }];
}

+ (BOOL)isAPPFirstLaunch {
    return [[NSUserDefaults standardUserDefaults] boolForKey:KFirstLaunchKey];
}

+ (void)setCURUFirstLaunch {
    [NSUserDefaults saveCURUDefaults:^(NSUserDefaults * _Nullable theCURUDefaults) {
        [theCURUDefaults setBool:YES forKey:KUserFirstLaunchKey];
    }];
}

+ (BOOL)isCURUFirstLaunch {
    NSUserDefaults *userDefaults = [NSUserDefaults theCURUDefaults];
    if (userDefaults) return [userDefaults boolForKey:KUserFirstLaunchKey];
    return NO;
}

+ (void)setCURULogin {
    [NSUserDefaults saveCURUDefaults:^(NSUserDefaults * _Nullable theCURUDefaults) {
        [theCURUDefaults setBool:YES forKey:KUserLoginKey];
    }];
}

+ (void)setCURULogout {
    [NSUserDefaults saveCURUDefaults:^(NSUserDefaults * _Nullable theCURUDefaults) {
        [theCURUDefaults setBool:NO forKey:KUserLoginKey];
    }];
}

+ (BOOL)isCURULogin {
    NSUserDefaults *userDefaults = [NSUserDefaults theCURUDefaults];
    if (userDefaults) return [userDefaults boolForKey:KUserLoginKey];
    return NO;
}

@end
