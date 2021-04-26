//
//  NSDecimalNumber+HUtil.m
//  QFProj
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSDecimalNumber+HUtil.h"

@implementation NSDecimalNumber (HUtil)

//exclusive默认为YES
+ (NSString *)notRounding:(NSNumber *)price afterPoint:(NSInteger)position {
    return [NSDecimalNumber notRounding:price afterPoint:position exclusive:YES];
}

//取小数点儿后的几位数，不四舍五入
//如 price=2.65, position=1，则结果为2.6
//如 price=3, position=1， exclusive=YES，则结果为3.0
//如 price=3, position=1， exclusive=NO，则结果为3
+ (NSString *)notRounding:(NSNumber *)price afterPoint:(NSInteger)position exclusive:(BOOL)exclusive {
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    //不四舍五入
    numberFormatter.roundingMode = NSNumberFormatterRoundDown;
    numberFormatter.maximumFractionDigits = position;
    //是否保留小数0
    numberFormatter.minimumFractionDigits = exclusive ? position : 0;
    
    numberFormatter.groupingSeparator = @",";
    numberFormatter.decimalSeparator = @".";
    
    NSDecimalNumber *decimal = [[NSDecimalNumber alloc] initWithDouble:price.doubleValue];
    return [numberFormatter stringFromNumber:decimal];
}

//multiplier乘以multiplicand
//multiplierString为乘数，multiplicandString为被乘数
//保留两位小数
+ (NSString *)decimalNumber:(NSString *)multiplierString multiplyingBy:(NSString *)multiplicandString {
    NSDecimalNumber *multiplier = [NSDecimalNumber decimalNumberWithString:multiplierString];
    multiplier = [multiplier decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:multiplicandString]];
    return [NSDecimalNumber notRounding:multiplier afterPoint:2 exclusive:NO];
}

//divisor除以dividend
//divisorString为除数，dividendString为被除数
//保留两位小数
+ (NSString *)decimalNumber:(NSString *)divisorString dividingBy:(NSString *)dividendString {
    NSDecimalNumber *divisor = [NSDecimalNumber decimalNumberWithString:divisorString];
    divisor = [divisor decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:dividendString]];
    return [NSDecimalNumber notRounding:divisor afterPoint:2 exclusive:NO];
}

@end
