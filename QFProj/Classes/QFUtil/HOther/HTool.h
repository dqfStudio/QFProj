//
//  HTool.h
//  QFProj
//
//  Created by dqf on 2018/10/14.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HSafeMessy.h"

@interface HTool : NSObject

+ (NSString *)stringMoneyFamat:(NSString *)number;

+ (NSString *)UTCchangeDate:(NSString *)utc;

+ (NSString *)getCurrentDateTime;

+ (NSString *)getCurrentDate;

+ (NSString *)getLastDaysWith:(NSInteger)days;

+ (NSString *)getLastDayDate;

+ (NSString *)getLastThreeDayDate;

+ (NSString *)getLastWeekDate;

+ (NSString *)getLastTwoWeekDate;

+ (NSString *)getLastMonthDate;

+ (NSString *)getLastMonthDate2;
+ (NSDate *)getLastMonthDate3;

+ (NSString *)currentDateString;

+ (NSDate *)stringToDate:(NSString *)strDate;

+ (NSString *)weekdayStringFromDate:(NSDate *)inputDate;

+ (NSString *)getCountdownTimeStr:(NSTimeInterval)interval;

+ (NSString *)showErrorInfoWithStatusCode:(NSInteger)statusCode;

@end
