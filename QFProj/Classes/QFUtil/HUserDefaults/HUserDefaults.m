//
//  HUserDefaults.m
//  HProjectModel1
//
//  Created by txkj_mac on 2018/9/27.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HUserDefaults.h"
#import "NSObject+HAutoFill.h"

#define KUSER @"H_USER_DEFAULTS"

@implementation HUserDefaults

static HUserDefaults *instance = nil;

+ (HUserDefaults *)defaults {
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
    [self autoClear];
    [self saveUser];
}


- (void)setBaseLink:(NSString *)baseLink {
    [[NSUserDefaults standardUserDefaults] setObject:baseLink forKey:@"baseLink"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)baseLink {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"baseLink"];
}



- (void)setH5Link:(NSString *)h5Link {
    [[NSUserDefaults standardUserDefaults] setObject:h5Link forKey:@"h5Link"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)h5Link {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"h5Link"];
}



- (void)setPlatCodeLink:(NSString *)platCodeLink {
    [[NSUserDefaults standardUserDefaults] setObject:platCodeLink forKey:@"platCodeLink"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)platCodeLink {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"platCodeLink"];
}


- (void)setSrc1Link:(NSString *)src1Link {
    [[NSUserDefaults standardUserDefaults] setObject:src1Link forKey:@"src1Link"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)src1Link {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"src1Link"];
}

@end
