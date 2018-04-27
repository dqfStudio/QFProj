//
//  NSTimer+HSafeUtil.m
//  TestProject
//
//  Created by dqf on 2017/9/23.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSTimer+HSafeUtil.h"

@implementation NSTimer (HSafeUtil)

+ (NSTimer *)safe_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void(^)(NSTimer * _Nonnull timer))block {
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(safe_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)safe_blockInvoke:(NSTimer *)timer {
    void(^block)(NSTimer * _Nonnull timer) = timer.userInfo;
    if (block != NULL) {
        block(timer);
    }
}

- (void)safe_resume {
    if (![self isValid]) return;
    [self setFireDate:[NSDate date]];
}

- (void)safe_pause {
    if (![self isValid]) return;
    [self setFireDate:[NSDate distantFuture]];
}

@end

