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
    return [NSDecimalNumber notRounding:price afterPoint:position exclusive:YES];
}

//取小数点儿后的几位数，不四舍五入
//如 price=2.65, position=1，则结果为2.6
//如 price=3, position=1， exclusive=YES，则结果为3.0
//如 price=3, position=1， exclusive=NO，则结果为3
+ (NSString *)notRounding:(CGFloat)price afterPoint:(NSInteger)position exclusive:(BOOL)exclusive {
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    NSDecimalNumber *roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString *priceString = [NSString stringWithFormat:@"%@",roundedOunces];
    
    NSRange range = [priceString rangeOfString:@"."];
    NSInteger length = range.location;
    if (range.location == NSNotFound ) length = priceString.length;
    
    if (exclusive) {
        NSMutableString *mutableString = NSMutableString.new;
        if (range.location == NSNotFound) {
            for (int i=0; i<position; i++) {
                [mutableString appendString:@"0"];
            }
            priceString = [NSString stringWithFormat:@"%@.%@",priceString, mutableString];
        }else {
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
    return priceString;
}

@end
