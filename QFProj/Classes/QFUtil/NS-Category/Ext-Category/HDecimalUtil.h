//
//  HDecimalUtil.h
//  QFProj
//
//  Created by dqf on 2021/4/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDecimalUtil : NSObject

//金额转换
//默认保留两位小数
//area为currencyName
+ (NSString *)amountConversion:(NSString *)amount;
//area为currencyName
+ (NSString *)amountConversion:(NSString *)amount afterPoint:(NSInteger)position;
//默认保留两位小数
+ (NSString *)amountConversion:(NSString *)amount currencyArea:(NSString *)area;
//金额转换
//不进行四舍五入，当达到千、百万、亿、兆时，使用省略写法（K、M、B、T）。
+ (NSString *)amountConversion:(NSString *)amount afterPoint:(NSInteger)position currencyArea:(NSString *)area;


//从服务器获取的金额数据处理
//默认保留两位小数
//area为currencyName
+ (NSString *)amountFormServerNotRoundingHandle:(NSString *)amount;
//从服务器获取的金额数据处理
//area为currencyName
+ (NSString *)amountFormServerNotRoundingHandle:(NSString *)amount afterPoint:(NSInteger)position;
//从服务器获取的金额数据处理
//默认保留两位小数
+ (NSString *)amountFormServerNotRoundingHandle:(NSString *)amount currencyArea:(NSString *)area;
//从服务器获取的金额数据处理
+ (NSString *)amountFormServerNotRoundingHandle:(NSString *)amount afterPoint:(NSInteger)position currencyArea:(NSString *)area;

//上传服务器的金额数据处理
+ (NSString *)amountToServerNotRoundingHandle:(NSString *)amount;


//默认保留两位小数
//area为currencyName
+ (NSString *)notRounding:(NSNumber *)price;
//area为currencyName
+ (NSString *)notRounding:(NSNumber *)price afterPoint:(NSInteger)position;
//默认保留两位小数
+ (NSString *)notRounding:(NSNumber *)price currencyArea:(NSString *)area;
//金额显示规则，不同币种不同规则
//越南：1.00=1  1.10=1.1
//印度：1.00=1  1.10=1.1
//USDT：1.00=1.00  1.10=1.10
+ (NSString *)notRounding:(NSNumber *)price afterPoint:(NSInteger)position currencyArea:(NSString *)area;


//multiplier乘以multiplicand
//multiplierString为乘数，multiplicandString为被乘数
//保留两位小数
//area为currencyName
+ (NSString *)decimalNumber:(NSString *)multiplierString multiplyingBy:(NSString *)multiplicandString;
//multiplier乘以multiplicand
//multiplierString为乘数，multiplicandString为被乘数
//保留两位小数
+ (NSString *)decimalNumber:(NSString *)multiplierString multiplyingBy:(NSString *)multiplicandString currencyArea:(NSString *)area;


//divisor除以dividend
//divisorString为除数，dividendString为被除数
//保留两位小数
//area为currencyName
+ (NSString *)decimalNumber:(NSString *)divisorString dividingBy:(NSString *)dividendString;
//divisor除以dividend
//divisorString为除数，dividendString为被除数
//保留两位小数
+ (NSString *)decimalNumber:(NSString *)divisorString dividingBy:(NSString *)dividendString currencyArea:(NSString *)area;

@end

NS_ASSUME_NONNULL_END
