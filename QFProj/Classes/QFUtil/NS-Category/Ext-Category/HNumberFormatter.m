//
//  HNumberFormatter.m
//  QFProj
//
//  Created by dqf on 2021/4/30.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HNumberFormatter.h"

typedef NS_ENUM(NSUInteger, HOperationMode) {
    adding,
    subtracting,
    multiplying,
    dividing,
    other
};

@implementation NSDecimalNumber (HFormatter)
//主动操作数据调用
+ (NSDecimalNumber *)activeDecimalNumberWithObjcValue:(id)objcValue operationMode:(HOperationMode)mode {
    return [NSDecimalNumber decimalNumberWithObjcValue:objcValue active:YES operationMode:mode];
}
//被动操作数据调用
+ (NSDecimalNumber *)unactiveDecimalNumberWithObjcValue:(id)objcValue operationMode:(HOperationMode)mode {
    return [NSDecimalNumber decimalNumberWithObjcValue:objcValue active:NO operationMode:mode];
}
//objcValue为NSString或NSNumber类型
+ (NSDecimalNumber *)decimalNumberWithObjcValue:(id)objcValue active:(BOOL)active operationMode:(HOperationMode)mode {
    if ([objcValue isKindOfClass:NSString.class]) {
        NSString *objcStringValue = [objcValue stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([objcStringValue containsString:@","] || [objcStringValue containsString:@"，"]) {
            objcStringValue = [objcStringValue stringByReplacingOccurrencesOfString:@"," withString:@""];
            objcStringValue = [objcStringValue stringByReplacingOccurrencesOfString:@"，" withString:@""];
        }
        //避免[@“” floatValue] == 0 的情况
        if (objcStringValue.length > 0 && [objcStringValue floatValue] >= 0) {
            return [NSDecimalNumber decimalNumberWithString:objcStringValue];
        }
    }else if ([objcValue isKindOfClass:NSNumber.class]) {
        NSNumber *objcNumberValue = objcValue;
        if ([objcNumberValue stringValue].length > 0 && [objcNumberValue floatValue] >= 0) {
            return [NSDecimalNumber decimalNumberWithDecimal:[objcNumberValue decimalValue]];
        }
    }
    switch (mode) {
        case adding: {
            if (active) return [NSDecimalNumber decimalNumberWithString:@"0"];
            else return [NSDecimalNumber decimalNumberWithString:@"0"];
        }
            break;
        case subtracting:{
            if (active) return [NSDecimalNumber decimalNumberWithString:@"0"];
            else return [NSDecimalNumber decimalNumberWithString:@"0"];
        }
            break;
        case multiplying:{
            if (active) return [NSDecimalNumber decimalNumberWithString:@"1"];
            else return [NSDecimalNumber decimalNumberWithString:@"1"];
        }
            break;
        case dividing:{
            if (active) return [NSDecimalNumber decimalNumberWithString:@"0"];
            else return [NSDecimalNumber decimalNumberWithString:@"1"];
        }
            break;
            
        default:
            break;
    }
    return nil;
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
        _symbol = nil;
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
    
    NSDecimalNumber *decimalNumber = [NSDecimalNumber activeDecimalNumberWithObjcValue:numberObjc operationMode:other];
    if (!decimalNumber) return numberObjc;
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
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
    if (decimalNumber.doubleValue == 0) {
        if (symbol.length > 0) {
            numberFormatter.positivePrefix = symbol;
            numberFormatter.negativePrefix = symbol;
        }
    }else if (prefix && symbol.length > 0) {
        numberFormatter.positivePrefix = [@"+" stringByAppendingString:symbol];
        numberFormatter.negativePrefix = [@"-" stringByAppendingString:symbol];
    }else if (symbol.length > 0) {
        numberFormatter.positivePrefix = symbol;
        numberFormatter.negativePrefix = symbol;
    }else if (prefix) {
        numberFormatter.positivePrefix = @"+";
        numberFormatter.negativePrefix = @"-";
    }
    
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
    NSDecimalNumber *selfNumber = [NSDecimalNumber activeDecimalNumberWithObjcValue:value operationMode:adding];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber unactiveDecimalNumberWithObjcValue:value operationMode:adding];
    return [selfNumber decimalNumberByAdding:decimalNumber];
}
//减，value为NSString或NSNumber类型
- (NSDecimalNumber *)subtracting:(id)value {
    NSDecimalNumber *selfNumber = [NSDecimalNumber activeDecimalNumberWithObjcValue:value operationMode:subtracting];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber unactiveDecimalNumberWithObjcValue:value operationMode:subtracting];
    return [selfNumber decimalNumberBySubtracting:decimalNumber];
}
//乘，value为NSString或NSNumber类型
- (NSDecimalNumber *)multiplying:(id)value {
    NSDecimalNumber *selfNumber = [NSDecimalNumber activeDecimalNumberWithObjcValue:value operationMode:multiplying];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber unactiveDecimalNumberWithObjcValue:value operationMode:multiplying];
    return [selfNumber decimalNumberByMultiplyingBy:decimalNumber];
}
//除，value为NSString或NSNumber类型
- (NSDecimalNumber *)dividing:(id)value {
    NSDecimalNumber *selfNumber = [NSDecimalNumber activeDecimalNumberWithObjcValue:value operationMode:dividing];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber unactiveDecimalNumberWithObjcValue:value operationMode:dividing];
    return [selfNumber decimalNumberByDividingBy:decimalNumber];
}
//格式化
- (NSString *)makeFormatter:(void(^_Nullable)(HNumberFormatter *make))block {
    HNumberFormatter *make = HNumberFormatter.new;
    if (block) block(make);
    NSNumber *modeNumber = make.formatterEnum()[make.roundingMode];
    return [make numberObjc:self roundingMode:modeNumber.intValue afterPoint:make.afterPoint pointZero:make.pointZero grouping:make.grouping prefix:make.prefix symbol:make.symbol conversion:make.conversion];
}
@end


@implementation NSString (HFormatter)
//加，value为NSString或NSNumber类型
- (NSDecimalNumber *)adding:(id)value {
    NSDecimalNumber *selfNumber = [NSDecimalNumber activeDecimalNumberWithObjcValue:value operationMode:adding];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber unactiveDecimalNumberWithObjcValue:value operationMode:adding];
    return [selfNumber decimalNumberByAdding:decimalNumber];
}
//减，value为NSString或NSNumber类型
- (NSDecimalNumber *)subtracting:(id)value {
    NSDecimalNumber *selfNumber = [NSDecimalNumber activeDecimalNumberWithObjcValue:value operationMode:subtracting];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber unactiveDecimalNumberWithObjcValue:value operationMode:subtracting];
    return [selfNumber decimalNumberBySubtracting:decimalNumber];
}
//乘，value为NSString或NSNumber类型
- (NSDecimalNumber *)multiplying:(id)value {
    NSDecimalNumber *selfNumber = [NSDecimalNumber activeDecimalNumberWithObjcValue:value operationMode:multiplying];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber unactiveDecimalNumberWithObjcValue:value operationMode:multiplying];
    return [selfNumber decimalNumberByMultiplyingBy:decimalNumber];
}
//除，value为NSString或NSNumber类型
- (NSDecimalNumber *)dividing:(id)value {
    NSDecimalNumber *selfNumber = [NSDecimalNumber activeDecimalNumberWithObjcValue:value operationMode:dividing];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber unactiveDecimalNumberWithObjcValue:value operationMode:dividing];
    return [selfNumber decimalNumberByDividingBy:decimalNumber];
}
//格式化
- (NSString *)makeFormatter:(void(^_Nullable)(HNumberFormatter *make))block {
    HNumberFormatter *make = HNumberFormatter.new;
    if (block) block(make);
    NSNumber *modeNumber = make.formatterEnum()[make.roundingMode];
    return [make numberObjc:self roundingMode:modeNumber.intValue afterPoint:make.afterPoint pointZero:make.pointZero grouping:make.grouping prefix:make.prefix symbol:make.symbol conversion:make.conversion];
}
@end
