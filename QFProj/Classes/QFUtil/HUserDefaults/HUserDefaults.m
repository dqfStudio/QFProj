//
//  HUserDefaults.m
//  HProjectModel1
//
//  Created by txkj_mac on 2018/9/27.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HUserDefaults.h"
#import "NSObject+HUtil.h"

#define KUSER @"H_USER_DEFAULTS"

@implementation HUserDefaults

static HUserDefaults *instance = nil;

+ (instancetype)defaults {
    if (!instance) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [userDefaults objectForKey:KUSER];
        instance = [[self alloc] initWithSerializedData:data];
    }
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveUser) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

- (void)saveUser {
    if (self.isLogin) {
        NSDictionary *dict = [self serialization];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:KUSER];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:KUSER];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)removeUser {
    instance = nil;
    self.isLogin = NO;
    [self saveUser];
}

@end
