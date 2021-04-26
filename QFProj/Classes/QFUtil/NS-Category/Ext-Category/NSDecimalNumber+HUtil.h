//
//  NSDecimalNumber+HUtil.h
//  QFProj
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDecimalNumber (HUtil)
//exclusive默认为YES
+ (NSString *)notRounding:(CGFloat)price afterPoint:(NSInteger)position;
//取小数点儿后的几位数，不四舍五入
//如 price=2.65, position=1，则结果为2.6
//如 price=3, position=1， exclusive=YES，则结果为3.0
//如 price=3, position=1， exclusive=NO，则结果为3
+ (NSString *)notRounding:(CGFloat)price afterPoint:(NSInteger)position exclusive:(BOOL)exclusive;
//multiplier乘以multiplicand
//multiplierString为乘数，multiplicandString为被乘数
//保留两位小数
+ (NSString *)decimalNumber:(NSString *)multiplierString multiplyingBy:(NSString *)multiplicandString;
//divisor除以dividend
//divisorString为除数，dividendString为被除数
//保留两位小数
+ (NSString *)decimalNumber:(NSString *)divisorString dividingBy:(NSString *)dividendString;
@end

NS_ASSUME_NONNULL_END
