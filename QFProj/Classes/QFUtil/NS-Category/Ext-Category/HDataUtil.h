//
//  HDataUtil.h
//  TestProject
//
//  Created by dqf on 2017/9/23.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HJson)
//将字典转化成json data
- (NSData *)jsonData;
//将字典转化成字符串 如：rn=1&tt=3&rr=4
- (NSString *)linkString;
//将字典转化成json字符串
- (NSString *)jsonString;
//去掉json字符串中的空格和换行符
- (NSString *)jsonString2;
@end

@interface NSString (HJson)
//将json字符串转化成字典
- (NSDictionary *)dictionary;
//将字符串转化data
- (NSData *)data;
@end

@interface NSData (HJson)
//将json data转化成字典
- (NSDictionary *)dictionary;
//将data转化成字符串
- (NSString *)string;
@end
