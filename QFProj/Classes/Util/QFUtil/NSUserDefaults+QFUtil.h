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

+ (void)setFirstLaunch;
+ (BOOL)isFirstLaunch;

+ (void)setUserFirstLaunch;
+ (BOOL)isUserFirstLaunch;

+ (void)setUserLogin;
+ (void)setUserLogout;
+ (BOOL)isUserLogin;

@end
