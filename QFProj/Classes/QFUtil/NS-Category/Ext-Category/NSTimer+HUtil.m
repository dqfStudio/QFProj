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


+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval times:(NSTimeInterval)times block:(void (^)(NSTimer *timer))block {
    __block NSTimeInterval count = 0;
    NSTimer *timer = [NSTimer h_scheduledTimerWithTimeInterval:interval repeats:YES block:^(NSTimer * _Nonnull timer) {
        count += interval;
        if (count < interval * times) {
            if (block) block(timer);
        }else if (count >= interval * times) {
            [timer invalidate];
            if (block) block(timer);
            timer = nil;
        }
    }];
    return timer;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval times:(NSTimeInterval)times block:(void (^)(NSTimer *timer))block completion:(void (^)(void))completion {
    __block NSTimeInterval count = 0;
    NSTimer *timer = [NSTimer h_scheduledTimerWithTimeInterval:interval repeats:YES block:^(NSTimer * _Nonnull timer) {
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





+ (NSTimer *)scheduledTimerImmediatelyWithTimeInterval:(NSTimeInterval)interval times:(NSTimeInterval)times block:(void (^)(NSTimer *timer))block {
    __block NSTimeInterval count = 0;
    NSTimer *timer = [NSTimer h_scheduledTimerWithTimeInterval:interval repeats:YES block:^(NSTimer * _Nonnull timer) {
        count += interval;
        if (count < interval * times) {
            if (block) block(timer);
        }else if (count == interval * times) {
            [timer invalidate];
            if (block) block(timer);
            timer = nil;
        }else if (count > interval * times) {
            [timer invalidate];
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

+ (NSTimer *)scheduledTimerImmediatelyWithTimeInterval:(NSTimeInterval)interval times:(NSTimeInterval)times block:(void (^)(NSTimer *timer))block completion:(void (^)(void))completion {
    __block NSTimeInterval count = 0;
    NSTimer *timer = [NSTimer h_scheduledTimerWithTimeInterval:interval repeats:YES block:^(NSTimer * _Nonnull timer) {
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

+ (NSTimer *)h_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void(^)(NSTimer * _Nonnull timer))block {
    if (@available(iOS 10.0, *)) {
        return [NSTimer scheduledTimerWithTimeInterval:interval repeats:repeats block:block];
    }else {
        return [self scheduledTimerWithTimeInterval:interval
                                             target:self
                                           selector:@selector(h_blockInvoke:)
                                           userInfo:[block copy]
                                            repeats:repeats];
    }
}

+ (void)h_blockInvoke:(NSTimer *)timer {
    void(^block)(NSTimer * _Nonnull timer) = timer.userInfo;
    if (block != NULL) {
        block(timer);
    }
}

//恢复
- (void)resume {
    if (![self isValid]) return;
    [self setFireDate:[NSDate date]];
}

//暂停
- (void)pause {
    if (![self isValid]) return;
    [self setFireDate:[NSDate distantFuture]];
}

@end
