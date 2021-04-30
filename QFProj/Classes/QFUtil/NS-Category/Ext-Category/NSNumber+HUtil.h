//
//  NSNumber+HUtil.h
//  QFProj
//
//  Created by dqf on 2021/4/30.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (HUtil)

//不四舍五入，强制保留两位小数
- (NSString *)roundDown;

//不四舍五入，保留两位小数
- (NSString *)roundDownWithPointZero:(BOOL)pointZero;

//不四舍五入
- (NSString *)roundDownWithAfterPoint:(NSInteger)position
                            pointZero:(BOOL)pointZero;

//不四舍五入
- (NSString *)roundDownWithAfterPoint:(NSInteger)position
                            pointZero:(BOOL)pointZero
                             grouping:(BOOL)grouping
                               prefix:(BOOL)prefix
                               symbol:(NSString *)symbol;




//四舍五入，强制保留两位小数
- (NSString *)roundUp;

//四舍五入，保留两位小数
- (NSString *)roundUpWithPointZero:(BOOL)pointZero;

//四舍五入
- (NSString *)roundUpWithAfterPoint:(NSInteger)position
                          pointZero:(BOOL)pointZero;

//四舍五入
- (NSString *)roundUpWithAfterPoint:(NSInteger)position
                          pointZero:(BOOL)pointZero
                           grouping:(BOOL)grouping
                             prefix:(BOOL)prefix
                             symbol:(NSString *)symbol;



- (NSString *)roundingMode:(NSNumberFormatterRoundingMode)mode
                afterPoint:(NSInteger)position
                 pointZero:(BOOL)pointZero
                  grouping:(BOOL)grouping
                    prefix:(BOOL)prefix
                    symbol:(NSString *)symbol;

@end

NS_ASSUME_NONNULL_END
