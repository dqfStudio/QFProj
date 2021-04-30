//
//  NSDecimalNumber+HUtil.h
//  QFProj
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDecimalNumber (HUtil)
//加
- (NSString *)decimalNumberByAddingStringValue:(NSString *)string;
- (NSString *)decimalNumberByAddingStringValue:(NSString *)string pointZero:(BOOL)pointZero;

//减
- (NSString *)decimalNumberBySubtractingStringValue:(NSString *)string;
- (NSString *)decimalNumberBySubtractingStringValue:(NSString *)string pointZero:(BOOL)pointZero;

//乘
- (NSString *)decimalNumberByMultiplyingStringValue:(NSString *)string;
- (NSString *)decimalNumberByMultiplyingStringValue:(NSString *)string pointZero:(BOOL)pointZero;

//除
- (NSString *)decimalNumberByDividingStringValue:(NSString *)string;
- (NSString *)decimalNumberByDividingStringValue:(NSString *)string pointZero:(BOOL)pointZero;

@end


NS_ASSUME_NONNULL_END
