//
//  HTestManager.m
//  QFProj
//
//  Created by dqf on 2018/5/9.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTestManager.h"
#import <AdSupport/ASIdentifierManager.h>

@implementation HTestManager

+ (HTestManager *)share {
    static HTestManager *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (void)jump:(void(^)(void))jumpBlock {
    [self jumpToTest:^{} else:^{
        jumpBlock();
    }];
}

- (void)jumpToTest:(void(^)(void))jumpBlock else:(void(^)(void))elseBlock {
#if DEBUG
    __block BOOL needJump = NO;
    [HClassManager scanClassForKey:KTestRegKey fetchblock:^(__unsafe_unretained Class aclass, id userInfo) {
        if (userInfo && [userInfo isKindOfClass:[NSString class]] && [userInfo isEqualToString:[self getUUID]]) {
            jumpBlock();
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[aclass new]];
            [UIApplication sharedApplication].delegate.window.rootViewController = navi;
            [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
            needJump = YES;
            return;
        }
    }];
    if (!needJump) {
        elseBlock();
    }
#else
    elseBlock();
#endif
}

- (NSString *)getUUID {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

@end
