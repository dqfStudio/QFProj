//
//  NSString+HUtil.h
//  TestProject
//
//  Created by dqf on 2018/4/24.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (HUtil)

//用于测试阶段自动生成字符串
+ (NSString *)testString;

+ (NSString *)leftArrowString;
+ (NSString *)rightArrowString;
+ (NSString *)cancelString;
+ (NSString *)checkedString;

- (id)JSONValue;

- (NSString *)trim;

- (NSString *)md5;

- (NSString *)encode;

- (NSString *)decode;

//String contains Emoji
- (BOOL)stringContainsEmoji;

@end

