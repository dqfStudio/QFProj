//
//  HDecimalUtil.m
//  QFProj
//
//  Created by Wind on 2021/4/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HDecimalUtil.h"

@implementation HDecimalUtil

+ (NSString *)currencyName {
    //NSString *region = [DAConfig getUserRegion];
    NSString *region = @"";
    if ([region isEqual:@"Vietnam"]) {
        return @"VND";
    } else if([region isEqual:@"India"]) {
        return @"INR";
    }
    return @"USD";
}

//金额转换
//默认保留两位小数
//area为currencyName
+ (NSString *)amountConversion:(NSString *)amount {
    return [HDecimalUtil amountConversion:amount afterPoint:2];
}

//area为currencyName
+ (NSString *)amountConversion:(NSString *)amount afterPoint:(NSInteger)position {
    return [HDecimalUtil amountConversion:amount afterPoint:position currencyArea:@""];
}

//默认保留两位小数
+ (NSString *)amountConversion:(NSString *)amount currencyArea:(NSString *)area {
    return [HDecimalUtil amountConversion:amount afterPoint:2 currencyArea:area];
}

//金额转换
//不进行四舍五入，当达到千、百万、亿、兆时，使用省略写法（K、M、B、T）。
+ (NSString *)amountConversion:(NSString *)amount afterPoint:(NSInteger)position currencyArea:(NSString *)area {
    
    if (![amount isKindOfClass:NSString.class] || amount.length <= 0) amount = @"0.0";
        
    NSRange range = [amount rangeOfString:@"."];
    NSInteger length = range.location;
    if (range.location == NSNotFound) length = amount.length;
    
    NSString *appendString = @"";
    NSString *dividendString = @"1";
    
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
    
    NSDecimalNumber *divisor = [NSDecimalNumber decimalNumberWithString:amount];
    divisor = [divisor decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:dividendString]];
    return [[HDecimalUtil notRounding:divisor afterPoint:position currencyArea:area] append:appendString];
    
}



//从服务器获取的金额数据处理
//默认保留两位小数
//area为currencyName
+ (NSString *)amountFormServerNotRoundingHandle:(NSString *)amount {
    return [HDecimalUtil amountFormServerNotRoundingHandle:amount afterPoint:2];
}

//从服务器获取的金额数据处理
//area为currencyName
+ (NSString *)amountFormServerNotRoundingHandle:(NSString *)amount afterPoint:(NSInteger)position {
    return [HDecimalUtil amountFormServerNotRoundingHandle:amount afterPoint:position currencyArea:@""];
}

//从服务器获取的金额数据处理
//默认保留两位小数
+ (NSString *)amountFormServerNotRoundingHandle:(NSString *)amount currencyArea:(NSString *)area {
    return [HDecimalUtil amountFormServerNotRoundingHandle:amount afterPoint:2 currencyArea:area];
}

//从服务器获取的金额数据处理
+ (NSString *)amountFormServerNotRoundingHandle:(NSString *)amount afterPoint:(NSInteger)position currencyArea:(NSString *)area {
    //以分为单位，故需要除以100
    if (![amount isKindOfClass:NSString.class] || amount.length <= 0) amount = @"0.0";
    NSDecimalNumber *divisor = [NSDecimalNumber decimalNumberWithString:amount];
    divisor = [divisor decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    return [HDecimalUtil notRounding:divisor afterPoint:position currencyArea:area];
}

//上传服务器的金额数据处理
+ (NSString *)amountToServerNotRoundingHandle:(NSString *)amount {
    //以分为单位，故上传服务器需要乘以100
    if (![amount isKindOfClass:NSString.class] || amount.length <= 0) amount = @"0.0";
    NSDecimalNumber *multiplier = [NSDecimalNumber decimalNumberWithString:amount];
    multiplier = [multiplier decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    return [NSString stringWithFormat:@"%@", multiplier];
}




//默认保留两位小数
//area为currencyName
+ (NSString *)notRounding:(NSNumber *)price {
    return [HDecimalUtil notRounding:price afterPoint:2];
}

////area为currencyName
+ (NSString *)notRounding:(NSNumber *)price afterPoint:(NSInteger)position {
    return [HDecimalUtil notRounding:price afterPoint:position currencyArea:@""];
}

//默认保留两位小数
+ (NSString *)notRounding:(NSNumber *)price currencyArea:(NSString *)area {
    return [HDecimalUtil notRounding:price afterPoint:2 currencyArea:area];
}

//金额显示规则，不同币种不同规则
//越南：1.00=1  1.10=1.1
//印度：1.00=1  1.10=1.1
//USDT：1.00=1.00  1.10=1.10
+ (NSString *)notRounding:(NSNumber *)price afterPoint:(NSInteger)position currencyArea:(NSString *)area {
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    //不四舍五入
    numberFormatter.roundingMode = NSNumberFormatterRoundDown;
    numberFormatter.maximumFractionDigits = position;
    //是否保留小数0
    BOOL exclusive = NO;
    if ([area isKindOfClass:NSString.class] && area.length > 0) {
        exclusive = [area containsString:@"USD"] ? YES : NO;
    }else {
        exclusive = [[HDecimalUtil currencyName] isEqualToString:@"USD"] ? YES : NO;
    }
    numberFormatter.minimumFractionDigits = exclusive ? position : 0;
    
    numberFormatter.groupingSeparator = @",";
    numberFormatter.decimalSeparator = @".";
    
    NSDecimalNumber *decimal = [[NSDecimalNumber alloc] initWithDouble:price.doubleValue];
    return [numberFormatter stringFromNumber:decimal];
}



//multiplier乘以multiplicand
//multiplierString为乘数，multiplicandString为被乘数
//保留两位小数
//area为currencyName
+ (NSString *)decimalNumber:(NSString *)multiplierString multiplyingBy:(NSString *)multiplicandString {
    return [HDecimalUtil decimalNumber:multiplierString multiplyingBy:multiplicandString currencyArea:@""];
}

//multiplier乘以multiplicand
//multiplierString为乘数，multiplicandString为被乘数
//保留两位小数
+ (NSString *)decimalNumber:(NSString *)multiplierString multiplyingBy:(NSString *)multiplicandString currencyArea:(NSString *)area {
    NSDecimalNumber *multiplier = [NSDecimalNumber decimalNumberWithString:multiplierString];
    multiplier = [multiplier decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:multiplicandString]];
    return [HDecimalUtil notRounding:multiplier afterPoint:2 currencyArea:area];
}

//divisor除以dividend
//divisorString为除数，dividendString为被除数
//保留两位小数
//area为currencyName
+ (NSString *)decimalNumber:(NSString *)divisorString dividingBy:(NSString *)dividendString {
    return [HDecimalUtil decimalNumber:divisorString dividingBy:dividendString currencyArea:@""];
}

//divisor除以dividend
//divisorString为除数，dividendString为被除数
//保留两位小数
+ (NSString *)decimalNumber:(NSString *)divisorString dividingBy:(NSString *)dividendString currencyArea:(NSString *)area {
    NSDecimalNumber *divisor = [NSDecimalNumber decimalNumberWithString:divisorString];
    divisor = [divisor decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:dividendString]];
    return [HDecimalUtil notRounding:divisor afterPoint:2 currencyArea:area];
}

@end
