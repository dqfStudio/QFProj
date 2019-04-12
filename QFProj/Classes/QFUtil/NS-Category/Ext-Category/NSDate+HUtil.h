//
//  NSDate+HUtil.h
//  TestProject
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HUtil)
+ (void)startTime;
+ (void)endTime;
+ (void)time:(void(^)(void))callback;
@end
