//
//  NSDecimalNumber+HUtil.m
//  QFProj
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSDecimalNumber+HUtil.h"

@implementation NSDecimalNumber (HUtil)

//取小数点儿后的几位数，不四舍五入，如 price=2.65, position=1，则结果为2.6
//如 price=3, position=1，则结果为3
+ (NSString *)notRounding:(float)price afterPoint:(int)position {
    return [NSDecimalNumber notRounding:price afterPoint:position exclusive:NO];
}

//取小数点儿后的几位数，不四舍五入，如 price=2.65, position=1，则结果为2.6
//如 price=3, position=1， number=1，则结果为3.0
+ (NSString *)notRounding:(float)price afterPoint:(int)position exclusive:(BOOL)exclusive {
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    NSDecimalNumber *roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString *priceString = [NSString stringWithFormat:@"%@",roundedOunces];
    if (exclusive) {
        NSMutableString *mutableString = NSMutableString.new;
        for (int i=0; position; i++) {
            [mutableString appendString:@"0"];
        }
        priceString = [NSString stringWithFormat:@"%@.%@",priceString, mutableString];
    }
    return priceString;
}

@end
