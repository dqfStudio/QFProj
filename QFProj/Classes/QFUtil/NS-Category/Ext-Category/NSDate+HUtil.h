//
//  NSDate+HUtil.h
//  TestProject
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NSDateFormat) {
    NSDateFormatDefault = 0, //yyyy-MM-dd HH:mm:ss
    NSDateFormatValue1, //yyyy-MM-dd
    NSDateFormatValue2 //yyyy年MM月dd日
};

@interface NSDate (HUtil)
+ (void)startTime;
+ (void)endTime;
+ (void)time:(void(^)(void))callback;

+ (NSString *)dateWithFormat:(NSDateFormat)format;
+ (NSDate *)dateWithString:(NSString *)aString format:(NSDateFormat)format;
+ (NSString *)weekdayFromDate:(NSDate *)date;
+ (NSString *)pastWithDays:(NSUInteger)days format:(NSDateFormat)format;
+ (NSString *)pastWithDate:(NSDate *)date Days:(NSUInteger)days format:(NSDateFormat)format;
+ (NSDate *)pastWithDays:(NSUInteger)days;
+ (NSDate *)pastWithDate:(NSDate *)date days:(NSUInteger)days;
@end
