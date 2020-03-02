//
//  NSString+HSafeUtil.m
//  TestProject
//
//  Created by dqf on 2017/9/30.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSString+HSafeUtil.h"

@implementation NSString (HSafeUtil)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *strArr = @[@"__NSCFConstantString", @"NSPlaceholderString", @"__NSCFString"];
        
        HSwizzleInstanceMethodNames(strArr, @selector(hasPrefix:), @selector(safe_hasPrefix:));
        HSwizzleInstanceMethodNames(strArr, @selector(hasSuffix:), @selector(safe_hasSuffix:));
        HSwizzleInstanceMethodNames(strArr, @selector(initWithString:), @selector(safe_initWithString:));
        
        HSwizzleInstanceMethodNames(strArr, @selector(substringFromIndex:), @selector(safe_substringFromIndex:));
        HSwizzleInstanceMethodNames(strArr, @selector(substringToIndex:), @selector(safe_substringToIndex:));
        
        HSwizzleInstanceMethodNames(strArr, @selector(substringWithRange:), @selector(safe_substringWithRange:));
        HSwizzleInstanceMethodNames(strArr, @selector(stringByAppendingString:), @selector(safe_stringByAppendingString:));
    });
}
- (BOOL)safe_hasSuffix:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        return [self safe_hasSuffix:str];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
    return NO;
}
- (BOOL)safe_hasPrefix:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        return [self safe_hasPrefix:str];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
    return NO;
}
- (instancetype)safe_initWithString:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        return [self safe_initWithString:str];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
    return [self safe_initWithString:@""];
}
- (NSString *)safe_substringFromIndex:(NSUInteger)from {
    if (from >=0 && from <= self.length) {
        return [self safe_substringFromIndex:from];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
        if (from < 0) {
            return [self safe_substringFromIndex:0];
        }else if (from > self.length) {
            return @"";
        }
    }
    return @"";
}
- (NSString *)safe_substringToIndex:(NSUInteger)to {
    if (to >=0 && to <= self.length) {
        return [self safe_substringToIndex:to];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
        if (to < 0) {
            return @"";
        }else if (to > self.length) {
            return [self safe_substringToIndex:self.length];
        }
    }
    return @"";
}
- (NSString *)safe_substringWithRange:(NSRange)range {
    NSRange tmpRange = range;
    if (tmpRange.location < 0) {
#if DEBUG
        NSAssert(NO,nil);
#endif
        tmpRange.location = 0;
    }else if (tmpRange.location > self.length) {
#if DEBUG
        NSAssert(NO,nil);
#endif
        tmpRange.location = self.length;
    }
    if (tmpRange.length < 0) {
#if DEBUG
        NSAssert(NO,nil);
#endif
        tmpRange.length = 0;
    }else if (tmpRange.length > self.length) {
#if DEBUG
        NSAssert(NO,nil);
#endif
        tmpRange.length = self.length;
    }
    if (tmpRange.location + tmpRange.length > self.length) {
#if DEBUG
        NSAssert(NO,nil);
#endif
        tmpRange = NSMakeRange(range.location, self.length-tmpRange.length);
        return [self safe_substringWithRange:tmpRange];
    }
    return [self safe_substringWithRange:tmpRange];
}
- (NSString *)safe_stringByAppendingString:(NSString *)aString {
    if ([aString isKindOfClass:[NSString class]]) {
        return [self safe_stringByAppendingString:aString];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
    return [self safe_stringByAppendingString:@""];
}
@end

@implementation NSMutableString (HSafeUtil)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *strArr = @[@"__NSCFConstantString", @"NSPlaceholderString", @"__NSCFString"];
        HSwizzleInstanceMethodNames(strArr, @selector(appendString:), @selector(safe_appendString:));
    });
}
- (void)safe_appendString:(NSString *)aString {
    if ([aString isKindOfClass:[NSString class]]) {
        return [self safe_appendString:aString];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
    return [self safe_appendString:@""];
}
@end
