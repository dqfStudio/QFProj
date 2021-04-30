//
//  NSDecimalNumber+HUtil.m
//  QFProj
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSDecimalNumber+HUtil.h"

@implementation NSDecimalNumber (HUtil)

//加
- (NSString *)decimalNumberByAddingStringValue:(NSString *)string {
    return [self decimalNumberByAddingStringValue:string pointZero:YES];
}
- (NSString *)decimalNumberByAddingStringValue:(NSString *)string pointZero:(BOOL)pointZero {
    NSDecimalNumber *addend = [self decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:string]];
    return [addend makeFormatter:^(HDecimalFormatter * _Nonnull make) {
        make.roundingMode = roundDown;
        make.afterPoint = 2;
        make.pointZero = pointZero;
    }];
}

//减
- (NSString *)decimalNumberBySubtractingStringValue:(NSString *)string {
    return [self decimalNumberBySubtractingStringValue:string pointZero:YES];
}
- (NSString *)decimalNumberBySubtractingStringValue:(NSString *)string pointZero:(BOOL)pointZero {
    NSDecimalNumber *subtraction = [self decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:string]];
    return [subtraction makeFormatter:^(HDecimalFormatter * _Nonnull make) {
        make.roundingMode = roundDown;
        make.afterPoint = 2;
        make.pointZero = pointZero;
    }];
}

//乘
- (NSString *)decimalNumberByMultiplyingStringValue:(NSString *)string {
    return [self decimalNumberByMultiplyingStringValue:string pointZero:YES];
}
- (NSString *)decimalNumberByMultiplyingStringValue:(NSString *)string pointZero:(BOOL)pointZero {
    NSDecimalNumber *multiplier = [self decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:string]];
    return [multiplier makeFormatter:^(HDecimalFormatter * _Nonnull make) {
        make.roundingMode = roundDown;
        make.afterPoint = 2;
        make.pointZero = pointZero;
    }];
}

//除
- (NSString *)decimalNumberByDividingStringValue:(NSString *)string {
    return [self decimalNumberByDividingStringValue:string pointZero:YES];
}
- (NSString *)decimalNumberByDividingStringValue:(NSString *)string pointZero:(BOOL)pointZero {
    NSDecimalNumber *divisor = [self decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:string]];
    return [divisor makeFormatter:^(HDecimalFormatter * _Nonnull make) {
        make.roundingMode = roundDown;
        make.afterPoint = 2;
        make.pointZero = pointZero;
    }];
}

@end
