//
//  NSNumber+HUtil.m
//  QFProj
//
//  Created by dqf on 2021/4/30.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "NSNumber+HUtil.h"

@implementation NSNumber (HUtil)

//不四舍五入，强制保留两位小数
- (NSString *)roundDown {
    return [self roundingMode:NSNumberFormatterRoundDown
                   afterPoint:2
                    pointZero:YES
                     grouping:NO
                       prefix:NO
                       symbol:@""];
}

//不四舍五入，保留两位小数
- (NSString *)roundDownWithPointZero:(BOOL)pointZero {
    return [self roundingMode:NSNumberFormatterRoundDown
                   afterPoint:2
                    pointZero:pointZero
                     grouping:NO
                       prefix:NO
                       symbol:@""];
}

//不四舍五入
- (NSString *)roundDownWithAfterPoint:(NSInteger)position
                            pointZero:(BOOL)pointZero {
    return [self roundingMode:NSNumberFormatterRoundDown
                   afterPoint:position
                    pointZero:pointZero
                     grouping:NO
                       prefix:NO
                       symbol:@""];
}

//不四舍五入
- (NSString *)roundDownWithAfterPoint:(NSInteger)position
                            pointZero:(BOOL)pointZero
                             grouping:(BOOL)grouping
                               prefix:(BOOL)prefix
                               symbol:(NSString *)symbol {
    return [self roundingMode:NSNumberFormatterRoundDown
                   afterPoint:position
                    pointZero:pointZero
                     grouping:grouping
                       prefix:prefix
                       symbol:symbol];
}




//四舍五入，强制保留两位小数
- (NSString *)roundUp {
    return [self roundingMode:NSNumberFormatterRoundUp
                   afterPoint:2
                    pointZero:YES
                     grouping:NO
                       prefix:NO
                       symbol:@""];
}

//四舍五入，保留两位小数
- (NSString *)roundUpWithPointZero:(BOOL)pointZero {
    return [self roundingMode:NSNumberFormatterRoundUp
                   afterPoint:2
                    pointZero:pointZero
                     grouping:NO
                       prefix:NO
                       symbol:@""];
}

//四舍五入
- (NSString *)roundUpWithAfterPoint:(NSInteger)position
                          pointZero:(BOOL)pointZero {
    return [self roundingMode:NSNumberFormatterRoundUp
                   afterPoint:position
                    pointZero:pointZero
                     grouping:NO
                       prefix:NO
                       symbol:@""];
}

//四舍五入
- (NSString *)roundUpWithAfterPoint:(NSInteger)position
                          pointZero:(BOOL)pointZero
                           grouping:(BOOL)grouping
                             prefix:(BOOL)prefix
                             symbol:(NSString *)symbol {
    return [self roundingMode:NSNumberFormatterRoundUp
                   afterPoint:position
                    pointZero:pointZero
                     grouping:grouping
                       prefix:prefix
                       symbol:symbol];
}



- (NSString *)roundingMode:(NSNumberFormatterRoundingMode)mode
                afterPoint:(NSInteger)position
                 pointZero:(BOOL)pointZero
                  grouping:(BOOL)grouping
                    prefix:(BOOL)prefix
                    symbol:(NSString *)symbol {
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    //不四舍五入
    numberFormatter.roundingMode = mode;
    numberFormatter.maximumFractionDigits = position;
    //是否保留小数末尾零位
    numberFormatter.minimumFractionDigits = pointZero ? position : 0;
    //分组分隔符，默认为","且每三位进行分割
    if (grouping) {
        numberFormatter.usesGroupingSeparator = grouping;
        numberFormatter.groupingSeparator = @",";
        numberFormatter.groupingSize = 3;
    }
    //小数分隔符，默认为"."
    numberFormatter.decimalSeparator = @".";
    //正前缀和负前缀
    if (prefix && symbol.length > 0) {
        numberFormatter.positivePrefix = [@"+" stringByAppendingString:symbol];
        numberFormatter.negativePrefix = [@"-" stringByAppendingString:symbol];
    }else if (prefix) {
        numberFormatter.positivePrefix = @"+";
        numberFormatter.negativePrefix = @"-";
    }
    
    return [numberFormatter stringFromNumber:self];
}

@end
