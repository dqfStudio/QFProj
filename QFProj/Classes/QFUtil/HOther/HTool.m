//
//  HTool.m
//  HProjectModel1
//
//  Created by txkj_mac on 2018/10/14.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HTool.h"

@implementation HTool

+ (NSString *)stringMoneyFamat:(NSString *)number {
    if (![number isKindOfClass:NSNumber.class] && ![number isKindOfClass:NSString.class]) {
        return @"0.00";
    }
    NSString *content = number;
    if ([number isKindOfClass:NSNumber.class]) {
        content = [number stringValue];
    }
    if([content isEqualToString:@"--"] || [content isEqualToString:@"维护中"] || [content isEqualToString:@"加载中..."]){
        return content;
    }
    content = [content stringByReplacingOccurrencesOfString:@"," withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"，" withString:@""];
    if ([content doubleValue] > 0) {
        NSNumber *number = @([content doubleValue]);
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        //至少保留两位小数，并不进行四舍五入
        formatter.roundingMode = NSNumberFormatterRoundFloor;
        formatter.maximumFractionDigits = 2;
        formatter.minimumFractionDigits = 2;
        //格式化样式
        formatter.numberStyle  = kCFNumberFormatterDecimalStyle;
        
        return [formatter stringFromNumber:number];
    }else{
        return @"0.00";
    }
}

+ (NSString *)UTCchangeDate:(NSString *)utc {
    
    NSTimeInterval time = [utc doubleValue]/1000;
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

+ (NSString *)getCurrentDateTime {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
    return currentDateStr;
}

+ (NSString *)getCurrentDate {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
    return currentDateStr;
}
+ (NSString *)getLastDaysWith:(NSInteger)days {
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval time = days * 24 * 60 * 60;
    NSDate *lastWeek = [date dateByAddingTimeInterval:-time];
    NSString *startDate =  [dateFormatter stringFromDate:lastWeek];
    return  startDate;
}
+ (NSString *)getLastDayDate {
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval time = 1 * 24 * 60 * 60;
    NSDate *lastWeek = [date dateByAddingTimeInterval:-time];
    NSString *startDate =  [dateFormatter stringFromDate:lastWeek];
    return  startDate;
}
+ (NSString *)getLastThreeDayDate {
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval time = 3 * 24 * 60 * 60;
    NSDate *lastWeek = [date dateByAddingTimeInterval:-time];
    NSString *startDate =  [dateFormatter stringFromDate:lastWeek];
    return  startDate;
}
+ (NSString *)getLastWeekDate {
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval time = 7 * 24 * 60 * 60;
    NSDate *lastWeek = [date dateByAddingTimeInterval:-time];
    NSString *startDate =  [dateFormatter stringFromDate:lastWeek];
    return  startDate;
}
+ (NSString *)getLastTwoWeekDate {
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval time = 14 * 24 * 60 * 60;
    NSDate *lastWeek = [date dateByAddingTimeInterval:-time];
    NSString *startDate =  [dateFormatter stringFromDate:lastWeek];
    return  startDate;
}

+ (NSString *)getLastMonthDate {
    NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:[NSDate date]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *monthagoData = [self getPriousorLaterDateFromDate:nextDate withMonth:-1];
    NSString *agoString = [dateFormatter stringFromDate:monthagoData];
    return agoString;
}

+ (NSString *)getLastMonthDate2 {
    NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:[NSDate date]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *monthagoData = [self getPriousorLaterDateFromDate:nextDate withMonth:-1];
    NSString *agoString = [dateFormatter stringFromDate:monthagoData];
    return agoString;
}

+ (NSDate *)getLastMonthDate3 {
    NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:[NSDate date]];
    NSDate *monthagoData = [self getPriousorLaterDateFromDate:nextDate withMonth:-1];
    return monthagoData;
}

+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

+ (NSDate *)stringToDate:(NSString *)strDate {
    NSString *dateString = strDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}

+ (NSString *)weekdayStringFromDate:(NSDate *)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

+ (NSString *)getCountdownTimeStr:(NSTimeInterval)interval
{
    NSInteger days = interval / (24 * 60 * 60);
    NSInteger hours = ((NSInteger)interval % (24 * 60 * 60)) / (60 * 60);
    NSInteger minuts = (((NSInteger)interval % (24 * 60 * 60)) % (60 * 60)) / 60;
    NSInteger seconds = (((NSInteger)interval % (24 * 60 * 60)) % (60 * 60)) % 60;
    NSString *timeStr = [NSString stringWithFormat:@"%02zd天 %02zd时 %02zd分 %02zd秒", days, hours, minuts, seconds];
    
    return timeStr;
}

#pragma mark - 获取当前的时间
+ (NSString *)currentDateString {
    return [self currentDateStringWithFormat:@"yyyy年MM月dd日"];
}

#pragma mark - 按指定格式获取当前的时间
+ (NSString *)currentDateStringWithFormat:(NSString *)formatterStr {
    // 获取系统当前时间
    NSDate *currentDate = [NSDate date];
    // 用于格式化NSDate对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置格式：yyyy-MM-dd HH:mm:ss
    formatter.dateFormat = formatterStr;
    // 将 NSDate 按 formatter格式 转成 NSString
    NSString *currentDateStr = [formatter stringFromDate:currentDate];
    // 输出currentDateStr
    return currentDateStr;
}

#pragma mark
+ (NSString *)showErrorInfoWithStatusCode:(NSInteger)statusCode {
    
    NSString *message = @"服务器请求失败!";
    switch (statusCode) {
        case -1://NSURLErrorUnknown
            message = @"未知错误";
            break;
        case -999://NSURLErrorCancelled
            message = @"无效的URL地址";
            break;
        case -1000://NSURLErrorBadURL
            message = @"无效的URL地址";
            break;
        case -1001://NSURLErrorTimedOut
            message = @"网络不给力，请稍后再试";
            break;
        case -1002://NSURLErrorUnsupportedURL
            message = @"不支持的URL地址";
            break;
        case -1003://NSURLErrorCannotFindHost
            message = @"找不到服务器";
            break;
        case -1004://NSURLErrorCannotConnectToHost
            message = @"连接不上服务器";
            break;
        case -1103://NSURLErrorDataLengthExceedsMaximum
            message = @"请求数据长度超出最大限度";
            break;
        case -1005://NSURLErrorNetworkConnectionLost
            message = @"网络连接异常";
            break;
        case -1006://NSURLErrorDNSLookupFailed
            message = @"DNS查询失败";
            break;
        case -1007://NSURLErrorHTTPTooManyRedirects
            message = @"HTTP请求重定向";
            break;
        case -1008://NSURLErrorResourceUnavailable
            message = @"资源不可用";
            break;
        case -1009://NSURLErrorNotConnectedToInternet
            message = @"无网络连接";
            break;
        case -1010://NSURLErrorRedirectToNonExistentLocation
            message = @"重定向到不存在的位置";
            break;
        case -1011://NSURLErrorBadServerResponse
            message = @"服务器响应异常";
            break;
        case -1012://NSURLErrorUserCancelledAuthentication
            message = @"用户取消授权";
            break;
        case -1013://NSURLErrorUserAuthenticationRequired
            message = @"需要用户授权";
            break;
        case -1014://NSURLErrorZeroByteResource
            message = @"零字节资源";
            break;
        case -1015://NSURLErrorCannotDecodeRawData
            message = @"无法解码原始数据";
            break;
        case -1016://NSURLErrorCannotDecodeContentData
            message = @"无法解码内容数据";
            break;
        case -1017://NSURLErrorCannotParseResponse
            message = @"无法解析响应";
            break;
        case -1018://NSURLErrorInternationalRoamingOff
            message = @"国际漫游关闭";
            break;
        case -1019://NSURLErrorCallIsActive
            message = @"被叫激活";
            break;
        case -1020://NSURLErrorDataNotAllowed
            message = @"数据不被允许";
            break;
        case -1021://NSURLErrorRequestBodyStreamExhausted
            message = @"请求体";
            break;
        case -1100://NSURLErrorFileDoesNotExist
            message = @"文件不存在";
            break;
        case -1101://NSURLErrorFileIsDirectory
            message = @"文件是个目录";
            break;
        case -1102://NSURLErrorNoPermissionsToReadFile
            message = @"无读取文件权限";
            break;
        case -1200://NSURLErrorSecureConnectionFailed
            message = @"安全连接失败";
            break;
        case -1201://NSURLErrorServerCertificateHasBadDate
            message = @"服务器证书失效";
            break;
        case -1202://NSURLErrorServerCertificateUntrusted
            message = @"不被信任的服务器证书";
            break;
        case -1203://NSURLErrorServerCertificateHasUnknownRoot
            message = @"未知Root的服务器证书";
            break;
        case -1204://NSURLErrorServerCertificateNotYetValid
            message = @"服务器证书未生效";
            break;
        case -1205://NSURLErrorClientCertificateRejected
            message = @"客户端证书被拒";
            break;
        case -1206://NSURLErrorClientCertificateRequired
            message = @"需要客户端证书";
            break;
        case -2000://NSURLErrorCannotLoadFromNetwork
            message = @"无法从网络获取";
            break;
        case -3000://NSURLErrorCannotCreateFile
            message = @"无法创建文件";
            break;
        case -3001:// NSURLErrorCannotOpenFile
            message = @"无法打开文件";
            break;
        case -3002://NSURLErrorCannotCloseFile
            message = @"无法关闭文件";
            break;
        case -3003://NSURLErrorCannotWriteToFile
            message = @"无法写入文件";
            break;
        case -3004://NSURLErrorCannotRemoveFile
            message = @"无法删除文件";
            break;
        case -3005://NSURLErrorCannotMoveFile
            message = @"无法移动文件";
            break;
        case -3006://NSURLErrorDownloadDecodingFailedMidStream
            message = @"下载解码数据失败";
            break;
        case -3007://NSURLErrorDownloadDecodingFailedToComplete
            message = @"下载解码数据失败";
            break;
    }
    return message;
}
@end

