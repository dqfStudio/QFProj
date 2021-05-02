//
//  HNumberFormatter.m
//  QFProj
//
//  Created by Wind on 2021/4/30.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HNumberFormatter.h"

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
    }else if (symbol.length > 0) {
        numberFormatter.positivePrefix = symbol;
        numberFormatter.negativePrefix = symbol;
    }else if (prefix) {
        numberFormatter.positivePrefix = @"+";
        numberFormatter.negativePrefix = @"-";
    }
    
    if ([numberObjc isKindOfClass:NSNumber.class]) {
        return [numberFormatter stringFromNumber:(NSNumber *)numberObjc];
    }else if ([numberObjc isKindOfClass:NSString.class]) {
        return [numberFormatter stringFromNumber:[NSDecimalNumber decimalNumberWithString:(NSString *)numberObjc]];
    }
    
    return @"";
}

@end

@implementation NSDecimalNumber (HFormatter)
//objcValue为NSString或NSNumber类型
+ (NSDecimalNumber *)decimalNumberWithObjcValue:(id)objcValue {
    if ([objcValue isKindOfClass:NSString.class]) {
        return [NSDecimalNumber decimalNumberWithString:objcValue];
    }else if ([objcValue isKindOfClass:NSNumber.class]) {
        NSString *string = [NSString stringWithFormat:@"%lf", [(NSNumber *)objcValue doubleValue]];
        return [NSDecimalNumber decimalNumberWithString:string];
    }
    return NSDecimalNumber.new;
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
    block(make);
    NSNumber *modeNumber = make.formatterEnum()[make.roundingMode];
    return [make numberObjc:self roundingMode:modeNumber.intValue afterPoint:make.afterPoint pointZero:make.pointZero grouping:make.grouping prefix:make.prefix symbol:make.symbol];
}
@end


@implementation NSString (HFormatter)
//加，value为NSString或NSNumber类型
- (NSDecimalNumber *)adding:(id)value {
    if (![value isKindOfClass:NSString.class] && ![value isKindOfClass:NSNumber.class]) value = @"";
    return [[NSDecimalNumber decimalNumberWithString:self] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithObjcValue:value]];
}
//减，value为NSString或NSNumber类型
- (NSDecimalNumber *)subtracting:(id)value {
    if (![value isKindOfClass:NSString.class] && ![value isKindOfClass:NSNumber.class]) value = @"";
    return [[NSDecimalNumber decimalNumberWithString:self] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithObjcValue:value]];
}
//乘，value为NSString或NSNumber类型
- (NSDecimalNumber *)multiplying:(id)value {
    if (![value isKindOfClass:NSString.class] && ![value isKindOfClass:NSNumber.class]) value = @"1";
    return [[NSDecimalNumber decimalNumberWithString:self] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithObjcValue:value]];
}
//除，value为NSString或NSNumber类型
- (NSDecimalNumber *)dividing:(id)value {
    if (![value isKindOfClass:NSString.class] && ![value isKindOfClass:NSNumber.class]) value = @"1";
    return [[NSDecimalNumber decimalNumberWithString:self] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithObjcValue:value]];
}
//格式化
- (NSString *)makeFormatter:(void(^)(HNumberFormatter *make))block {
    HNumberFormatter *make = HNumberFormatter.new;
    block(make);
    NSNumber *modeNumber = make.formatterEnum()[make.roundingMode];
    return [make numberObjc:self roundingMode:modeNumber.intValue afterPoint:make.afterPoint pointZero:make.pointZero grouping:make.grouping prefix:make.prefix symbol:make.symbol];
}
@end
