//
//  HHexUtil.h
//  TestProject
//
//  Created by dqf on 2017/9/23.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHexUtil : NSObject

//普通字符串转换为十六进制字符串
+ (NSString *)hexStringFromString:(NSString *)string;

//十六进制转换为普通字符串
+ (NSString *)hexStrToString:(NSString *)hexString;

// 十六进制转二进制
+ (NSString *)getBinaryByhex:(NSString *)hex;

//十进制转十六进制
+ (NSString *)toHexString:(uint16_t)value;

@end
