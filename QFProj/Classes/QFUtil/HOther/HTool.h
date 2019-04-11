//
//  HTool.h
//  HProjectModel1
//
//  Created by txkj_mac on 2018/10/14.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HMessy.h"

@interface HTool : NSObject

+ (NSString *)stringMoneyFamat:(NSString *)number;

+ (NSString *)stringChineseFamat:(NSString *)number;

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

+ (NSDate *)stringToDate:(NSString*)strDate;

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

+ (NSString *)getCountdownTimeStr:(NSTimeInterval)interval;

+ (NSString *)showErrorInfoWithStatusCode:(NSInteger)statusCode;

@end
