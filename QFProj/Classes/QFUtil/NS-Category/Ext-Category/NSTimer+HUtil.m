//
//  NSTimer+HUtil.m
//  QFProj
//
//  Created by dqf on 2018/7/14.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "NSTimer+HUtil.h"
#import <objc/runtime.h>

@implementation NSTimer (HUtil)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval times:(NSTimeInterval)times block:(void (^)(NSTimer *timer))block completion:(void (^)(void))completion {
    __block NSTimeInterval count = 0;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval repeats:YES block:^(NSTimer * _Nonnull timer) {
        count += interval;
        if (count <= interval * times) {
            if (block) block(timer);
        }else if (count > interval * times) {
            [timer invalidate];
            if (completion) completion();
            timer = nil;
        }
    }];
    return timer;
}

+ (NSTimer *)scheduledTimerImmediatelyWithTimeInterval:(NSTimeInterval)interval times:(NSTimeInterval)times block:(void (^)(NSTimer *timer))block completion:(void (^)(void))completion {
    __block NSTimeInterval count = 0;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval repeats:YES block:^(NSTimer * _Nonnull timer) {
        count += interval;
        if (count <= interval * times) {
            if (block) block(timer);
        }else if (count > interval * times) {
            [timer invalidate];
            if (completion) completion();
            timer = nil;
        }
    }];
    //先调用一次
    if (block) {
        count += interval;
        block(timer);
    }
    return timer;
}

@end
