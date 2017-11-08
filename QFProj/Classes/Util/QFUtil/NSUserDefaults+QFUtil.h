//
//  NSUserDefaults+QFUtil.h
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 hisun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (QFUtil)

+ (void)setUserIdentity:(NSString *_Nullable)aString;
+ (nullable id)getUserIdentity;
+ (nullable instancetype)theCUserDefaults;

+ (void)saveTheCDefaults:(void (^_Nullable)(NSUserDefaults * _Nullable theCUserDefaults))block;
+ (void)saveDefaults:(void (^_Nullable)(NSUserDefaults * _Nullable userDefaults))block;

+ (void)setFirstLaunch;
+ (BOOL)isFirstLaunch;

+ (void)setUserFirstLaunch;
+ (BOOL)isUserFirstLaunch;

+ (void)setUserLogin;
+ (void)setUserLogout;
+ (BOOL)isUserLogin;

@end
