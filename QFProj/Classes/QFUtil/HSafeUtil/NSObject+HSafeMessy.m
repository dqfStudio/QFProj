//
//  NSObject+HSafeMessy.m
//  QFProj
//
//  Created by wind on 2019/3/20.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import "NSObject+HSafeMessy.h"

@implementation NSNull (HSafeMessy)
+ (NSString *)stringValue {
    return @"";
}
- (NSString *)stringValue {
    return @"";
}
+ (NSUInteger)length {
    return 0;
}
- (NSUInteger)length {
    return 0;
}
+ (BOOL)isEmpty {
    return YES;
}
- (BOOL)isEmpty {
    return YES;
}
@end

@implementation NSNumber (HSafeMessy)
- (NSUInteger)length {
    return self.stringValue.length;
}
- (NSString *)stringValue {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    //格式化样式
    formatter.numberStyle  = kCFNumberFormatterDecimalStyle;
    return [formatter stringFromNumber:self];
}
- (BOOL)isEmpty {
    NSString *string = [self.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (string.length == 0) {
        return YES;
    }
    return NO;
}
@end

@implementation NSString (HSafeMessy)
- (NSString *)stringValue {
    return self;
}
- (BOOL)isEmpty {
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (string.length == 0) {
        return YES;
    }
    return NO;
}
@end
