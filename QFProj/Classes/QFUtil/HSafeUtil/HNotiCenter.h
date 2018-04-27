//
//  HNotiCenter.h
//  HNotiCenter
//
//  Created by dqf on 2017/7/31.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNotiCenter : NSObject

+ (void)registerNoti:(NSString *_Nullable)name callback:(void(^_Nullable)(NSNotification * _Nullable note))callback;
+ (void)postNoti:(nonnull NSString *)name;
+ (void)postNoti:(nonnull NSString *)name object:(id _Nullable )anObject;
+ (void)removeNoti:(nonnull NSString *)name;

@end
