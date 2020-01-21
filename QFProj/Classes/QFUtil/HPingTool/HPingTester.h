//
//  HPingTester.h
//  BigVPN
//
//  Created by lingxuanfeng on 2017/5/11.
//  Copyright © 2017年 lingxuanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePing.h"

typedef void(^HPingBlock)(NSString *hostName, NSTimeInterval time, NSError *error);

@interface HPingTester : NSObject <SimplePingDelegate>

+ (instancetype)sharedInstance;

@property (nonatomic) NSTimeInterval timeout;//default 1.5

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithHostName:(NSString *)hostName NS_DESIGNATED_INITIALIZER;

- (void)startPingWith:(NSString *)hostName completion:(HPingBlock)pingBlock;
- (void)startPingWith:(HPingBlock)pingBlock;
- (BOOL)isPinging;
- (void)stopPing;

@end

@interface HPingItem : NSObject
@property (nonatomic) uint16_t sequence;
@end



