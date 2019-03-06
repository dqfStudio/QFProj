//
//  NSUserDefaults+HUtil.h
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 hisun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (HUtil)

//CURU: current  user
//STDU: standard user

+ (void)setCURUIdentity:(NSString *_Nullable)aString;
+ (nullable id)getCURUIdentity;

+ (nullable instancetype)theCURUDefaults;
+ (nullable instancetype)theSTDUDefaults;

+ (void)saveCURUDefaults:(void (^_Nullable)(NSUserDefaults * _Nullable theCURUDefaults))block;
+ (void)saveSTDUDefaults:(void (^_Nullable)(NSUserDefaults * _Nullable theSTDUDefaults))block;

+ (void)setAPPFirstLaunch;
+ (BOOL)isAPPFirstLaunch;

+ (void)setCURUFirstLaunch;
+ (BOOL)isCURUFirstLaunch;

+ (void)setCURULogin;
+ (void)setCURULogout;
+ (BOOL)isCURULogin;

@end
