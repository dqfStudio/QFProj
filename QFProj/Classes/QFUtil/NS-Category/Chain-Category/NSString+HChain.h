//
//  NSString+HChain.h
//  TestProj
//
//  Created by dqf on 2017/8/10.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (HChain)

- (NSString *(^)(NSInteger index))index;
- (NSString *(^)(NSInteger loc, NSInteger len))range;

+ (NSString *(^)(NSString *format, ...))format;

+ (NSString *(^)(Class))fromClass;
- (Class(^)(void))toClass;

+ (NSString *(^)(const char *))fromCString;
- (const char *(^)(void))toCString;

- (NSString *(^)(NSInteger loc))fromIndex;
- (NSString *(^)(NSInteger index))toIndex;

- (NSString *(^)(NSString *))fromString;
- (NSString *(^)(NSString *))toString;

- (SEL (^)(void))toSEL;

- (BOOL (^)(NSString *))exist;

+ (NSString *(^)(id))append;
- (NSString *(^)(id))append;
- (NSString *(^)(NSString *format, ...))appendFormat;

+ (NSString *(^)(NSString *, NSUInteger))appendCount;
- (NSString *(^)(NSString *, NSUInteger))appendCount;

- (NSString *(^)(NSString *, NSString *))replace;
- (BOOL (^)(NSString *))equal;
- (BOOL (^)(Class))isClass;

+ (NSString *(^)(NSUInteger))space;
- (NSString *(^)(NSUInteger))space;

+ (NSString *(^)(NSUInteger))tab;
- (NSString *(^)(NSUInteger))tab;

+ (NSString *(^)(NSUInteger))wrap;
- (NSString *(^)(NSUInteger))wrap;

- (NSArray<NSString *> *(^)(NSString *))componentsByString;
- (NSArray<NSString *> *(^)(NSString *))componentsBySetString;
- (NSArray<NSString *> *(^)(NSString *, NSString *))componentsByStringBySetString;

- (BOOL(^)(NSString *))containsString;
- (BOOL(^)(NSArray<NSString *> *))containsStrArr;

- (NSString *)objectAtIndexedSubscript:(NSInteger)index;
- (NSString *)objectForKeyedSubscript:(NSString *)key;

- (NSRange (^)(void))toRange;

@end
