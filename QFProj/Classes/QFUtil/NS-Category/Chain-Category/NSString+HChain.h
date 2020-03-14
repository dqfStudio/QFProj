//
//  NSString+HChain.h
//  QFProj
//
//  Created by dqf on 2017/8/10.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (HChain)
- (NSString *)idx:(NSInteger)index;
- (NSString *)range:(NSInteger)loc _:(NSInteger)len;

+ (NSString *)format:(NSString *)format, ...;

+ (NSString *)fromClass:(Class)cls;
- (Class)toClass;

+ (NSString *)fromRect:(CGRect)rect;
- (CGRect)toRect;

+ (NSString *)fromSize:(CGSize)size;
- (CGSize)toSize;

+ (NSString *)fromPoint:(CGPoint)point;
- (CGPoint)toPoint;

+ (NSString *)fromRange:(NSRange)range;
- (NSRange)toRange;

+ (NSString *)fromSelector:(SEL)aSelector;
- (SEL)toSelector;

+ (NSString *)fromProtocol:(Protocol *)proto;
- (Protocol *)toProtocol;

+ (NSString *)fromCString:(const char *)c;
- (const char *)toCString;

- (NSString *)fromIndex:(NSInteger)loc;
- (NSString *)toIndex:(NSInteger)index;
- (NSString *)fromSubString:(NSString *)org;
- (NSString *)toSubString:(NSString *)org;

- (BOOL)contains:(NSString *)org;

+ (NSString *)append:(id)obj;
- (NSString *)append:(id)obj;
- (NSString *)appendFormat:(NSString *)format, ...;

+ (NSString *)appendCount:(NSString *)org _:(NSUInteger)count;
- (NSString *)appendCount:(NSString *)org _:(NSUInteger)count;

- (NSString *)replace:(NSString *)org1 _:(NSString *)org2;
- (NSString *)replaceArray:(NSArray *)org;

- (BOOL)equal:(NSString *)org;
- (BOOL)isClass:(Class)aClass;

- (NSArray <NSString *>*)componentsByString:(NSString *)separator;
- (NSArray <NSString *>*)componentsBySetString:(NSString *)separator;
- (NSArray <NSString *>*)componentsByStringBySetString:(NSString *)separator _:(NSString *)setSeparator;
- (BOOL)containsStrArr:(NSArray <NSString *>*)arr;

- (NSString *)objectAtIndexedSubscript:(NSInteger)index;
- (NSString *)objectForKeyedSubscript:(NSString *)key;
@end
