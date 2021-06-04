//
//  NSUserDefaults+HUtil.h
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (HUtil)

+ (void)saveDefaults:(void (^)(NSUserDefaults *userDefaults))block;

+ (void)setAPPFirstLaunch;
+ (BOOL)isAPPFirstLaunch;

@end
