//
//  NSDate+QFUtil.m
//  TestProject
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSDate+QFUtil.h"

static const NSDate *startDate=nil;

@implementation NSDate (QFUtil)

+ (void)startTime {
    startDate =  [NSDate date];
}

+ (void)endTime {
    if (startDate) {
        NSLog(@"time: %f", -[startDate timeIntervalSinceNow]);
        [self startTime];
    }
}

+ (void)time:(void(^)(void))callback {
    if (callback) {
        NSDate *startDate = [NSDate date];
        callback();
        NSLog(@"block time: %f", -[startDate timeIntervalSinceNow]);
    }
}

@end
