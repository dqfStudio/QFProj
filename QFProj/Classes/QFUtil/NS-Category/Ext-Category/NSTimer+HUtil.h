//
//  NSTimer+HUtil.h
//  QFProj
//
//  Created by dqf on 2018/7/14.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (HUtil)

+ (void)scheduledTimerWithTimeInterval:(NSTimeInterval)interval times:(NSTimeInterval)times block:(void (^)(NSTimer *timer))block completion:(void (^)(void))completion;

+ (void)scheduledTimerImmediatelyWithTimeInterval:(NSTimeInterval)interval times:(NSTimeInterval)times block:(void (^)(NSTimer *timer))block completion:(void (^)(void))completion;

@end
