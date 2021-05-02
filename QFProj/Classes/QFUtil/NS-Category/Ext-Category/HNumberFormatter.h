//
//  HNumberFormatter.h
//  QFProj
//
//  Created by Wind on 2021/4/30.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HNumberFormatterRoundingMode) {
    roundCeiling = NSNumberFormatterRoundCeiling,
    roundFloor = NSNumberFormatterRoundFloor,
    roundDown = NSNumberFormatterRoundDown,
    roundUp = NSNumberFormatterRoundUp,
    roundHalfEven = NSNumberFormatterRoundHalfEven,
    roundHalfDown = NSNumberFormatterRoundHalfDown,
    roundHalfUp = NSNumberFormatterRoundHalfUp
};

NS_ASSUME_NONNULL_BEGIN

@interface HNumberFormatter : NSObject
//默认roundingMode == roundDown
@property(nonatomic, assign) HNumberFormatterRoundingMode roundingMode;
//默认保留两位小数，即afterPoint == 2
@property(nonatomic, assign) NSInteger afterPoint;
//默认pointZero == YES
@property(nonatomic, assign) BOOL pointZero;
//默认grouping == NO
@property(nonatomic, assign) BOOL grouping;
//默认prefix == NO
@property(nonatomic, assign) BOOL prefix;
//默认symbol == @""
@property(nonatomic) NSString *symbol;
@end

@interface NSNumber (HFormatter)
//加，value为NSString或NSNumber类型
- (NSDecimalNumber *)adding:(id)value;
//减，value为NSString或NSNumber类型
- (NSDecimalNumber *)subtracting:(id)value;
//乘，value为NSString或NSNumber类型
- (NSDecimalNumber *)multiplying:(id)value;
//除，value为NSString或NSNumber类型
- (NSDecimalNumber *)dividing:(id)value;
//格式化
- (NSString *)makeFormatter:(void(^)(HNumberFormatter *make))block;
@end

@interface NSString (HFormatter)
//加，value为NSString或NSNumber类型
- (NSDecimalNumber *)adding:(id)value;
//减，value为NSString或NSNumber类型
- (NSDecimalNumber *)subtracting:(id)value;
//乘，value为NSString或NSNumber类型
- (NSDecimalNumber *)multiplying:(id)value;
//除，value为NSString或NSNumber类型
- (NSDecimalNumber *)dividing:(id)value;
//格式化
- (NSString *)makeFormatter:(void(^)(HNumberFormatter *make))block;
@end

NS_ASSUME_NONNULL_END
