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
+ (NSString *)notRounding:(CGFloat)price afterPoint:(NSInteger)position {
    return [NSDecimalNumber notRounding:price afterPoint:position lastZeroPosition:0 exclusive:YES];
}

//lastZero为小数点后末位0保留个数
//如300.10，lastZero>0，则结果为300.1
//如300.01，lastZero>0，则结果为300.01
+ (NSString *)notRounding:(CGFloat)price afterPoint:(NSInteger)position lastZeroPosition:(NSInteger)lastZero {
    return [NSDecimalNumber notRounding:price afterPoint:position lastZeroPosition:lastZero exclusive:YES];
}


//取小数点儿后的几位数，不四舍五入
//如 price=2.65, position=1，则结果为2.6
//如 price=3, position=1， exclusive=YES，则结果为3.0
//如 price=3, position=1， exclusive=NO，则结果为3
+ (NSString *)notRounding:(CGFloat)price afterPoint:(NSInteger)position lastZeroPosition:(NSInteger)lastZero exclusive:(BOOL)exclusive {
    //根据position保留几位小数
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    NSDecimalNumber *roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString *priceString = [NSString stringWithFormat:@"%@",roundedOunces];
    //根据判断是否包含小数点，确定是否包含小数
    NSRange range = [priceString rangeOfString:@"."];
    NSInteger length = range.location;
    if (range.location == NSNotFound ) length = priceString.length;
    //如果exclusive为YES，强制保留position位小数
    if (exclusive) {
        NSMutableString *mutableString = NSMutableString.new;
        if (range.location == NSNotFound) {//原本不包含小数的情况，末尾添加position位小数
            for (int i=0; i<position; i++) {
                [mutableString appendString:@"0"];
            }
            priceString = [NSString stringWithFormat:@"%@.%@",priceString, mutableString];
        }else {//原本包含小数但小数位数不足的情况，末尾补足position位小数
            NSString *subPriceString = [priceString substringFromIndex:range.location+range.length];
            NSInteger count = position - subPriceString.length;
            if (subPriceString.length > 0 && count > 0) {
                for (int i=0; i<count; i++) {
                    [mutableString appendString:@"0"];
                }
                priceString = [NSString stringWithFormat:@"%@%@",priceString, mutableString];
            }
        }
    }
    //如果lastZero大于零且如果原本含有小数，则如果小数后面有占位零，则去掉lastZero位占位零
    //如300.10，lastZero>0，则结果为300.1
    //如300.01，lastZero>0，则结果为300.01
    NSRange range2 = [priceString rangeOfString:@"."];
    if (range2.location != NSNotFound && lastZero > 0 && lastZero <= position) {
        NSString *subPriceString = [priceString substringFromIndex:range2.location+range2.length];
        for (int i=0; i<lastZero; i++) {
            NSString *tmpString = [subPriceString substringFromIndex:subPriceString.length-1];
            if ([tmpString isEqualToString:@"0"]) {
                subPriceString = [subPriceString substringToIndex:subPriceString.length-1];
            }
        }
        if ([subPriceString isEqualToString:@""]) {//小数点儿后面全为零的情况，取小数点之前的数据
            priceString = [priceString substringToIndex:range2.location];
        }else {//小数点儿后面不全为零的情况，拼接小数点之前的数据与小数点儿后去掉零的数据
            priceString = [[priceString substringToIndex:range2.location+range2.length] stringByAppendingString:subPriceString];
        }
    }
    
    return priceString;
}

@end
