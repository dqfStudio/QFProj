//
//  NSObject+HSafeMessy.m
//  QFProj
//
//  Created by dqf on 2019/3/20.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import "NSObject+HSafeMessy.h"

@implementation NSNull (HSafeMessy)
+ (NSArray *)arrayValue {
    return nil;
}
- (NSArray *)arrayValue {
    return nil;
}
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
- (NSArray *)arrayValue {
    return nil;
}
- (NSUInteger)length {
    return self.stringValue.length;
}
//会保留小数点儿后六位，如果小数超过六位的情况下
- (NSString *)stringValue {
    NSString *string = [NSString stringWithFormat:@"%f", [self doubleValue]];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:string];
    //NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-cn"];
    return [decimalNumber descriptionWithLocale:nil];
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
- (NSArray *)arrayValue {
    return nil;
}
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

@implementation NSDictionary (HSafeMessy)
- (NSArray *)arrayValue {
    return [NSArray arrayWithObject:self];
}
@end

@implementation NSArray (HSafeMessy)
- (NSArray *)arrayValue {
    return self;
}
@end
