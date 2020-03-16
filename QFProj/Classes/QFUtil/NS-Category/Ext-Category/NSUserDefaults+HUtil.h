//
//  NSUserDefaults+HUtil.h
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (HUtil)

+ (void)setUserDefaultsId:(NSString *_Nullable)aString;
+ (nullable id)getUserDefaultsId;

+ (nullable instancetype)theUserDefaults;
+ (nullable instancetype)theStandardDefaults;

+ (void)saveUserDefaults:(void (^_Nullable)(NSUserDefaults *_Nullable theUserDefaults))block;
+ (void)saveStandardDefaults:(void (^_Nullable)(NSUserDefaults *_Nullable theStandardDefaults))block;

+ (void)setAPPFirstLaunch;
+ (BOOL)isAPPFirstLaunch;

+ (void)setUserFirstLaunch;
+ (BOOL)isUserFirstLaunch;

+ (void)setUserLogin;
+ (void)setUserLogout;
+ (BOOL)isUserLogin;

@end
