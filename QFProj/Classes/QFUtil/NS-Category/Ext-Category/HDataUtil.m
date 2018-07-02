//
//  HDataUtil.m
//  TestProject
//
//  Created by dqf on 2017/9/23.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "HDataUtil.h"

@implementation NSDictionary (HJson)
//将字典转化成json data
- (NSData *)jsonData {
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
}
//将字典转化成字符串 如：rn=1&tt=3&rr=4
- (NSString *)linkString {
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    for (NSString *key in self.allKeys) {
        NSString *value = self[key];
        [mutableString appendString:key];
        [mutableString appendString:@"="];
        [mutableString appendString:value];
        [mutableString appendString:@"&"];
    }
    return [mutableString substringToIndex:mutableString.length-1];;
}
//将字典转化成json字符串
- (NSString *)jsonString {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
//去掉json字符串中的空格和换行符
- (NSString *)jsonString2 {
    NSString *jsonString = [self jsonString];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}
@end

@implementation NSString (HJson)
//将json字符串转化成字典
- (NSDictionary *)dictionary {
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                           options:NSJSONReadingMutableContainers
                                             error:nil];
}
//将字符串转化data
- (NSData *)data {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}
@end

@implementation NSData (HJson)
//将json data转化成字典
- (NSDictionary *)dictionary {
    return [NSJSONSerialization JSONObjectWithData:self
                                           options:NSJSONReadingMutableContainers
                                             error:nil];
}
//将data转化成字符串
- (NSString *)string {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}
@end
