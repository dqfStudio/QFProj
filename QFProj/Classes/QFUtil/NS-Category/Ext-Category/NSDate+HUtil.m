//
//  NSDate+HUtil.m
//  HProj
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSDate+HUtil.h"

static const NSDate *startDate = nil;

@implementation NSDate (HUtil)
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

+ (NSString *)dateWithFormat:(NSDateFormat)format {
    NSString *formatString = [self stringWithFormat:format];
    NSDateFormatter *formatter = NSDateFormatter.new;
    [formatter setDateFormat:formatString];
    return [formatter stringFromDate:[NSDate date]];
}
+ (NSDate *)dateWithString:(NSString *)aString format:(NSDateFormat)format {
    if (!aString || aString.length == 0) return nil;
    NSString *formatString = [self stringWithFormat:format];
    NSDateFormatter *formatter = NSDateFormatter.new;
    [formatter setDateFormat:formatString];
    return [formatter dateFromString:aString];
}
+ (NSString *)weekdayFromDate:(NSDate *)date {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    return [weekdays objectAtIndex:theComponents.weekday];
}
+ (NSString *)pastWithDays:(NSUInteger)days format:(NSDateFormat)format {
    return [self pastWithDate:NSDate.date Days:days format:format];
}
+ (NSString *)pastWithDate:(NSDate *)date Days:(NSUInteger)days format:(NSDateFormat)format {
    NSString *formatString = [self stringWithFormat:format];
    NSDateFormatter *formatter = NSDateFormatter.new;
    [formatter setDateFormat:formatString];
    NSDate *pastDay = [self pastWithDate:date days:days];
    return [formatter stringFromDate:pastDay];
}
+ (NSDate *)pastWithDays:(NSUInteger)days {
    return [self pastWithDate:NSDate.date days:days];
}
+ (NSDate *)pastWithDate:(NSDate *)date days:(NSUInteger)days {
    if (!date || days < 0) return nil;
    NSTimeInterval time = days *24 * 60 * 60;
    return [date dateByAddingTimeInterval:-time];
}
+ (NSString *)stringWithFormat:(NSDateFormat)format {
    NSString *formatString = nil;
    switch (format) {
        case NSDateFormatDefault:
            formatString = @"yyyy-MM-dd HH:mm:ss";
            break;
        case NSDateFormatValue1:
            formatString = @"yyyy-MM-dd";
            break;
        case NSDateFormatValue2:
            formatString = @"yyyy年MM月dd日";
            break;
        default:
            formatString = @"yyyy-MM-dd HH:mm:ss";
            break;
    }
    return formatString;
}
@end
