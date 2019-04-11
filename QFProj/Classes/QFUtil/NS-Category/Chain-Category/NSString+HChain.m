//
//  NSString+HChain.m
//  TestProj
//
//  Created by dqf on 2017/8/10.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSString+HChain.h"

@implementation NSString (HChain)
- (NSString *)idx:(NSInteger)index {
    if(index >= 0 && index < self.length) {
        return self[index];
    }
    return @"";
}
- (NSString *)range:(NSInteger)loc _:(NSInteger)len {
    if(loc >= 0 && len >= 1 && loc+len <= self.length) {
        NSRange range = NSMakeRange(loc, len);
        return [self substringWithRange:range];
    }
    return @"";
}
+ (NSString *)format:(NSString *)format, ... {
    va_list arguments;
    va_start(arguments, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:arguments];
    va_end(arguments);
    return string;
}
+ (NSString *)fromClass:(Class)cls {
    return NSStringFromClass(cls);
}
- (Class)toClass {
    return NSClassFromString(self);
}
+ (NSString *)fromRect:(CGRect)rect {
    return NSStringFromCGRect(rect);
}
- (CGRect)toRect {
    return CGRectFromString(self);
}
+ (NSString *)fromSize:(CGSize)size {
    return NSStringFromCGSize(size);
}
- (CGSize)toSize {
    return CGSizeFromString(self);
}
+ (NSString *)fromPoint:(CGPoint)point {
    return NSStringFromCGPoint(point);
}
- (CGPoint)toPoint {
    return CGPointFromString(self);
}
+ (NSString *)fromRange:(NSRange)range {
    return NSStringFromRange(range);
}
- (NSRange)toRange {
    return NSRangeFromString(self);
}
+ (NSString *)fromSelector:(SEL)aSelector {
    return NSStringFromSelector(aSelector);
}
- (SEL)toSelector {
    return NSSelectorFromString(self);
}
+ (NSString *)fromProtocol:(Protocol *)proto {
    return NSStringFromProtocol(proto);
}
- (Protocol *)toProtocol {
    return NSProtocolFromString(self);
}
+ (NSString *)fromCString:(const char *)c {
    return [NSString stringWithCString:c encoding:NSUTF8StringEncoding];
}
- (const char *)toCString {
    return [self cStringUsingEncoding:NSUTF8StringEncoding];
}
- (NSString *)fromIndex:(NSInteger)loc {
    if(loc >= 0 && loc < self.length) {
        NSRange range = NSMakeRange(loc, self.length-loc);
        return [self substringWithRange:range];
    }
    return @"";
}
- (NSString *)toIndex:(NSInteger)index {
    if(index >= 0) {
        NSRange range = NSMakeRange(0, 0);
        if (index >= self.length) {
            range = NSMakeRange(0, self.length);
        }else {
            range = NSMakeRange(0, index+1);
        }
        return [self substringWithRange:range];
    }
    return @"";
}
- (NSString *)fromSubString:(NSString *)org {
    if ([self containsString:org]) {
        NSRange range = [self rangeOfString:org];
        return [self substringFromIndex:range.location+range.length];
    }
    return @"";
}
- (NSString *)toSubString:(NSString *)org {
    if ([self containsString:org]) {
        NSRange range = [self rangeOfString:org];
        return [self substringToIndex:range.location];
    }
    return @"";
}
- (BOOL)contains:(NSString *)org {
    BOOL yn = NO;
    if ([self containsString:org]) {
        yn = YES;
    }
    return yn;
}
+ (NSString *)append:(id)obj {
    return [NSString stringWithFormat:@"%@",obj];
}
- (NSString *)append:(id)obj {
    return [NSString stringWithFormat:@"%@%@", self,obj];
}
- (NSString *)appendFormat:(NSString *)format, ... {
    va_list arguments;
    va_start(arguments, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:arguments];
    string = [NSString stringWithFormat:@"%@%@", self,string];
    va_end(arguments);
    return string;
}
+ (NSString *)appendCount:(NSString *)org _:(NSUInteger)count {
    NSMutableString *mutableStr = [[NSMutableString alloc] init];
    for (int i=0; i<count; i++) {
        [mutableStr appendString:org];
    }
    return mutableStr;
}
- (NSString *)appendCount:(NSString *)org _:(NSUInteger)count {
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:self];
    for (int i=0; i<count; i++) {
        [mutableStr appendString:org];
    }
    return mutableStr;
}
- (NSString *)replace:(NSString *)org1 _:(NSString *)org2 {
    return [self stringByReplacingOccurrencesOfString:org1 withString:org2];
}
- (NSString *)replaceArray:(NSArray *)org {
    for (NSString *str in org) {
        [self replace:str _:@""];
    }
    return self;
}
- (BOOL)equal:(NSString *)org {
    return [self isEqualToString:org];
}
- (BOOL)isClass:(Class)aClass {
    return [self isKindOfClass:aClass];
}
- (NSArray <NSString *>*)componentsByString:(NSString *)separator {
    return [self componentsSeparatedByString:separator];
}
- (NSArray <NSString *>*)componentsBySetString:(NSString *)separator {
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:separator];
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSArray *arr = [self componentsSeparatedByCharactersInSet:characterSet];
    NSMutableArray *mutablerArr = [NSMutableArray new];
    //过滤掉为空的字符串
    for (int i=0; i<arr.count; i++) {
        NSString *str = arr[i];
        if (str.length > 0) {
            //过滤掉字符串两端为空的字符
            NSString *trimStr = [str stringByTrimmingCharactersInSet:charSet];
            if (trimStr.length > 0) {
                [mutablerArr addObject:trimStr];
            }
        }
    }
    return mutablerArr;
}
- (NSArray <NSString *>*)componentsByStringBySetString:(NSString *)separator _:(NSString *)setSeparator {
    NSMutableArray *mutablerArr = [NSMutableArray new];
    NSArray *arr = [self componentsByString:separator];
    for (int i=0; i<arr.count; i++) {
        NSString *str = arr[i];
        NSArray *tmpArr = [str componentsBySetString:setSeparator];
        [mutablerArr addObjectsFromArray:tmpArr];
    }
    return mutablerArr;
}
- (BOOL)containsStrArr:(NSArray <NSString *>*)arr {
    if (arr.count <= 0) return NO;
    BOOL contain = YES;
    for (NSString *str in arr) {
        if (![self containsString:str]) {
            contain = NO;
        }
    }
    return contain;
}
- (NSString *)objectAtIndexedSubscript:(NSInteger)index {
    if(index >= 0 && index < self.length) {
        NSRange range = NSMakeRange(index, 1);
        return [self substringWithRange:range];
    }
    return nil;
}
- (NSString *)objectForKeyedSubscript:(NSString *)key {
    if (key && [self containsString:key]) {
        return NSStringFromRange([self rangeOfString:key]);
    }
    return @"";
}
@end
