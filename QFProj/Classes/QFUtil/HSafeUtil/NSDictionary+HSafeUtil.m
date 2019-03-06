//
//  NSDictionary+HSafeUtil.m
//  TestProject
//
//  Created by dqf on 2017/9/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSDictionary+HSafeUtil.h"

@interface NSObject (HAlias)
@property (nonatomic) NSString *alias;
@end

@implementation NSObject (HAlias)
- (NSString *)alias {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setAlias:(NSString *)alias {
    [self setAssociateValue:alias withKey:@selector(alias)];
}
@end

@interface NSDictionary ()
@property (nonatomic) NSArray *aliasArr;
@end

@implementation NSDictionary (HSafeUtil)

- (NSArray *)aliasArr {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setAliasArr:(NSArray *)aliasArr {
    [self setAssociateValue:aliasArr withKey:@selector(aliasArr)];
}

//升序排列
- (NSArray *)ascendingComparedAllKeys {
    if (!self.aliasArr || self.aliasArr.count != self.aliasArr.count) {
        if (self.aliasArr) self.aliasArr = nil;
        self.aliasArr = [self keysSortedByValueUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            if ([obj1.alias integerValue] > [obj2.alias integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            if ([obj1.alias integerValue] < [obj2.alias integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
    }
    return self.aliasArr;
}

+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSDictionaryI") methodSwizzleWithOrigSEL:@selector(objectForKey:) overrideSEL:@selector(safe_objectForKey:)];
    });
}
- (nullable id)safe_objectForKey:(id)aKey {
    if (aKey != nil) {
        return [self safe_objectForKey:aKey];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
    return nil;
}
- (NSString *)objectAtIndexedSubscript:(NSInteger)index {
    if(index >= 0 && index < self.count) {
        NSArray *aliasArr = [self ascendingComparedAllKeys];
        NSString *key = aliasArr[index];
        return self[key];
    }
    return nil;
}
@end

@implementation NSMutableDictionary (HSafeUtil)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [objc_getClass("__NSDictionaryM") methodSwizzleWithOrigSEL:@selector(setObject:forKey:) overrideSEL:@selector(safe_setObject:forKey:)];
//        [self methodSwizzleWithOrigSEL:@selector(setObject:forKey:) overrideSEL:@selector(safe_setObject:forKey:)];
    });
}
//- (void)safe_setObject:(id)anObject forKey:(id)aKey {
//    if (aKey != nil && ![aKey isKindOfClass:objc_getClass("__NSCFConstantString")] && ![aKey isKindOfClass:objc_getClass("__NSCFString")]) {
//        [aKey setAlias:@(self.count).stringValue];
//        [self safe_setObject:anObject forKey:aKey];
//    }else {
//#if DEBUG
//        NSAssert(NO,nil);
//#endif
//    }
//}
@end

