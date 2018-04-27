//
//  NSTimer+HSafeUtil.h
//  TestProject
//
//  Created by dqf on 2017/9/23.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (HSafeUtil)

+ (NSTimer *_Nullable)safe_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void(^_Nullable)(NSTimer * _Nonnull timer))block;

//恢复
- (void)safe_resume;
//暂停
- (void)safe_pause;

@end
