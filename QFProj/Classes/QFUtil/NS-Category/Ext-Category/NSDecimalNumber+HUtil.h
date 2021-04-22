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
//lastZero为小数点后末位0保留个数
//如300.10，lastZero>0，则结果为300.1
//如300.01，lastZero>0，则结果为300.01
+ (NSString *)notRounding:(CGFloat)price afterPoint:(NSInteger)position lastZeroPosition:(NSInteger)lastZero;
//取小数点儿后的几位数，不四舍五入
//如 price=2.65, position=1，则结果为2.6
//如 price=3, position=1， exclusive=YES，则结果为3.0
//如 price=3, position=1， exclusive=NO，则结果为3
+ (NSString *)notRounding:(CGFloat)price afterPoint:(NSInteger)position lastZeroPosition:(NSInteger)lastZero exclusive:(BOOL)exclusive;
@end

NS_ASSUME_NONNULL_END
