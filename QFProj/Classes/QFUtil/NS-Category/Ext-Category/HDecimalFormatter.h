//
//  HDecimalFormatter.h
//  QFProj
//
//  Created by Wind on 2021/4/30.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HDecimalFormatterRoundingMode) {
    roundCeiling = NSNumberFormatterRoundCeiling,
    roundFloor = NSNumberFormatterRoundFloor,
    roundDown = NSNumberFormatterRoundDown,
    roundUp = NSNumberFormatterRoundUp,
    roundHalfEven = NSNumberFormatterRoundHalfEven,
    roundHalfDown = NSNumberFormatterRoundHalfDown,
    roundHalfUp = NSNumberFormatterRoundHalfUp
};

NS_ASSUME_NONNULL_BEGIN

@interface HDecimalFormatter : NSObject
//默认roundingMode == roundDown
@property(nonatomic, assign) HDecimalFormatterRoundingMode roundingMode;
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
- (NSString *)makeFormatter:(void(^)(HDecimalFormatter *make))block;
@end

@interface NSString (HFormatter)
- (NSString *)makeFormatter:(void(^)(HDecimalFormatter *make))block;
@end

NS_ASSUME_NONNULL_END
