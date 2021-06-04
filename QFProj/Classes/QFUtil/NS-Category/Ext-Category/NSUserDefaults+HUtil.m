//
//  NSUserDefaults+HUtil.m
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSUserDefaults+HUtil.h"

#define KFirstLaunchKey        @"ud_first_launch"

@implementation NSUserDefaults (HUtil)

+ (void)saveDefaults:(void (^)(NSUserDefaults *userDefaults))block {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (block) block(userDefaults);
    [userDefaults synchronize];
}

+ (void)setAPPFirstLaunch {
    [NSUserDefaults saveDefaults:^(NSUserDefaults *userDefaults) {
        [userDefaults setBool:YES forKey:KFirstLaunchKey];
    }];
}
+ (BOOL)isAPPFirstLaunch {
    return [[NSUserDefaults standardUserDefaults] boolForKey:KFirstLaunchKey];
}

@end
