//
//  HDecimalFormatter.m
//  QFProj
//
//  Created by Wind on 2021/4/30.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HDecimalFormatter.h"

@implementation HDecimalFormatter
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

- (NSString *)makeFormatter:(void(^)(HDecimalFormatter *make))block {
    HDecimalFormatter *make = HDecimalFormatter.new;
    block(make);
    NSNumber *modeNumber = self.formatterEnum()[make.roundingMode];
    return [self roundingMode:modeNumber.intValue afterPoint:make.afterPoint pointZero:make.pointZero grouping:make.grouping prefix:make.prefix symbol:make.symbol];
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
    }else if (symbol.length > 0) {
        numberFormatter.positivePrefix = symbol;
        numberFormatter.negativePrefix = symbol;
    }else if (prefix) {
        numberFormatter.positivePrefix = @"+";
        numberFormatter.negativePrefix = @"-";
    }
    
    if ([self isKindOfClass:NSNumber.class]) {
        return [numberFormatter stringFromNumber:(NSNumber *)self];
    }else if ([self isKindOfClass:NSString.class]) {
        return [numberFormatter stringFromNumber:[NSDecimalNumber decimalNumberWithString:(NSString *)self]];
    }
    
    return @"";
}

@end


@implementation NSNumber (HFormatter)
- (NSString *)makeFormatter:(void(^)(HDecimalFormatter *make))block {
    HDecimalFormatter *make = HDecimalFormatter.new;
    block(make);
    NSNumber *modeNumber = make.formatterEnum()[make.roundingMode];
    return [make roundingMode:modeNumber.intValue afterPoint:make.afterPoint pointZero:make.pointZero grouping:make.grouping prefix:make.prefix symbol:make.symbol];
}
@end


@implementation NSString (HFormatter)
- (NSString *)makeFormatter:(void(^)(HDecimalFormatter *make))block {
    HDecimalFormatter *make = HDecimalFormatter.new;
    block(make);
    NSNumber *modeNumber = make.formatterEnum()[make.roundingMode];
    return [make roundingMode:modeNumber.intValue afterPoint:make.afterPoint pointZero:make.pointZero grouping:make.grouping prefix:make.prefix symbol:make.symbol];
}
@end
