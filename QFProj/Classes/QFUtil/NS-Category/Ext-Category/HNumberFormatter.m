//
//  HNumberFormatter.m
//  QFProj
//
//  Created by dqf on 2021/4/30.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HNumberFormatter.h"

@implementation NSDecimalNumber (HFormatter)
//objcValue为NSString或NSNumber类型
+ (NSDecimalNumber *)decimalNumberWithObjcValue:(id)objcValue {
    if ([objcValue isKindOfClass:NSString.class]) {
        NSString *objcStrintValue = [objcValue stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([objcStrintValue containsString:@","] || [objcStrintValue containsString:@"，"]) {
            objcStrintValue = [objcStrintValue stringByReplacingOccurrencesOfString:@"," withString:@""];
            objcStrintValue = [objcStrintValue stringByReplacingOccurrencesOfString:@"，" withString:@""];
        }
        return [NSDecimalNumber decimalNumberWithString:objcStrintValue];
    }else if ([objcValue isKindOfClass:NSNumber.class]) {
        return [NSDecimalNumber decimalNumberWithDecimal:[(NSNumber *)objcValue decimalValue]];
    }
    return NSDecimalNumber.new;
}
@end

@implementation HNumberFormatter

- (instancetype)init {
    self = [super init];
    if (self) {
        _roundingMode = roundDown;
        _afterPoint = 2;
        _pointZero = YES;
        _grouping = NO;
        _prefix = NO;
        _symbol = @"";
        _conversion = NO;
    }
    return self;
}

- (NSArray *(^)(void))formatterEnum {
   return ^NSArray *(void) {
       static dispatch_once_t once;
       static NSArray *array;
       dispatch_once(&once, ^{
           array = @[@(NSNumberFormatterRoundCeiling),
                     @(NSNumberFormatterRoundFloor),
                     @(NSNumberFormatterRoundDown),
                     @(NSNumberFormatterRoundUp),
                     @(NSNumberFormatterRoundHalfEven),
                     @(NSNumberFormatterRoundHalfDown),
                     @(NSNumberFormatterRoundHalfUp)];
       });
       return array;
   };
}

- (NSString *)numberObjc:(id)numberObjc
            roundingMode:(NSNumberFormatterRoundingMode)mode
              afterPoint:(NSInteger)position
               pointZero:(BOOL)pointZero
                grouping:(BOOL)grouping
                  prefix:(BOOL)prefix
                  symbol:(NSString *)symbol
              conversion:(BOOL)conversion {
    
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
    }else if (symbol.length > 0) {
        numberFormatter.positivePrefix = symbol;
        numberFormatter.negativePrefix = symbol;
    }else if (prefix) {
        numberFormatter.positivePrefix = @"+";
        numberFormatter.negativePrefix = @"-";
    }
    
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithObjcValue:numberObjc];
    //判断是否要金额缩写
    if (conversion) {
        
        NSString *tmpString = numberObjc;
        if ([numberObjc isKindOfClass:NSNumber.class]) {
            tmpString = [NSString stringWithFormat:@"%lf", [(NSNumber *)tmpString doubleValue]];
        }
        
        NSRange range = [tmpString rangeOfString:@"."];
        NSInteger length = range.location;
        if (range.location == NSNotFound) length = tmpString.length;
        
        NSString *appendString = @"";
        NSString *dividendString = @"1";
        
        //当达到千、百万、亿、兆时，使用省略写法（K、M、B、T）
        if (length >= 13) {
            appendString = @"T";
            dividendString = @"1000000000000";
        }else if (length >= 9) {
            appendString = @"B";
            dividendString = @"100000000";
        }else if (length >= 7) {
            appendString = @"M";
            dividendString = @"1000000";
        }else if (length >= 4) {
            appendString = @"K";
            dividendString = @"1000";
        }
        //除以相关位数
        decimalNumber = [decimalNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:dividendString]];
        //正后缀和负后缀
        numberFormatter.positiveSuffix = appendString;
        numberFormatter.negativeSuffix = appendString;
    }
    
    return [numberFormatter stringFromNumber:decimalNumber];
}

@end

@implementation NSNumber (HFormatter)
//加，value为NSString或NSNumber类型
- (NSDecimalNumber *)adding:(id)value {
    if (![value isKindOfClass:NSString.class] && ![value isKindOfClass:NSNumber.class]) value = @"";
    return [[NSDecimalNumber decimalNumberWithObjcValue:self] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithObjcValue:value]];
}
//减，value为NSString或NSNumber类型
- (NSDecimalNumber *)subtracting:(id)value {
    if (![value isKindOfClass:NSString.class] && ![value isKindOfClass:NSNumber.class]) value = @"";
    return [[NSDecimalNumber decimalNumberWithObjcValue:self] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithObjcValue:value]];
}
//乘，value为NSString或NSNumber类型
- (NSDecimalNumber *)multiplying:(id)value {
    if (![value isKindOfClass:NSString.class] && ![value isKindOfClass:NSNumber.class]) value = @"1";
    return [[NSDecimalNumber decimalNumberWithObjcValue:self] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithObjcValue:value]];
}
//除，value为NSString或NSNumber类型
- (NSDecimalNumber *)dividing:(id)value {
    if (![value isKindOfClass:NSString.class] && ![value isKindOfClass:NSNumber.class]) value = @"1";
    return [[NSDecimalNumber decimalNumberWithObjcValue:self] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithObjcValue:value]];
}
//格式化
- (NSString *)makeFormatter:(void(^)(HNumberFormatter *make))block {
    HNumberFormatter *make = HNumberFormatter.new;
    if (block) block(make);
    NSNumber *modeNumber = make.formatterEnum()[make.roundingMode];
    return [make numberObjc:self roundingMode:modeNumber.intValue afterPoint:make.afterPoint pointZero:make.pointZero grouping:make.grouping prefix:make.prefix symbol:make.symbol conversion:make.conversion];
}
@end


@implementation NSString (HFormatter)
//加，value为NSString或NSNumber类型
- (NSDecimalNumber *)adding:(id)value {
    if (![value isKindOfClass:NSString.class] && ![value isKindOfClass:NSNumber.class]) value = @"";
    return [[NSDecimalNumber decimalNumberWithObjcValue:self] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithObjcValue:value]];
}
//减，value为NSString或NSNumber类型
- (NSDecimalNumber *)subtracting:(id)value {
    if (![value isKindOfClass:NSString.class] && ![value isKindOfClass:NSNumber.class]) value = @"";
    return [[NSDecimalNumber decimalNumberWithObjcValue:self] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithObjcValue:value]];
}
//乘，value为NSString或NSNumber类型
- (NSDecimalNumber *)multiplying:(id)value {
    if (![value isKindOfClass:NSString.class] && ![value isKindOfClass:NSNumber.class]) value = @"1";
    return [[NSDecimalNumber decimalNumberWithObjcValue:self] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithObjcValue:value]];
}
//除，value为NSString或NSNumber类型
- (NSDecimalNumber *)dividing:(id)value {
    if (![value isKindOfClass:NSString.class] && ![value isKindOfClass:NSNumber.class]) value = @"1";
    return [[NSDecimalNumber decimalNumberWithObjcValue:self] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithObjcValue:value]];
}
//格式化
- (NSString *)makeFormatter:(void(^)(HNumberFormatter *make))block {
    HNumberFormatter *make = HNumberFormatter.new;
    if (block) block(make);
    NSNumber *modeNumber = make.formatterEnum()[make.roundingMode];
    return [make numberObjc:self roundingMode:modeNumber.intValue afterPoint:make.afterPoint pointZero:make.pointZero grouping:make.grouping prefix:make.prefix symbol:make.symbol conversion:make.conversion];
}
@end
