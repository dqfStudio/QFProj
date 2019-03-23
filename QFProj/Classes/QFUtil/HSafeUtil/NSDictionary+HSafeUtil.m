//
//  NSDictionary+HSafeUtil.m
//  TestProject
//
//  Created by dqf on 2017/9/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSDictionary+HSafeUtil.h"

@implementation NSDictionary (HSafeUtil)

+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HSwizzleInstanceMethodNames(@[@"__NSDictionaryI"], @selector(objectForKey:), @selector(safe_objectForKey:));
        HSwizzleInstanceMethodNames(@[@"__NSPlaceholderDictionary"], @selector(initWithObjects:forKeys:count:), @selector(safe_initWithObjects:forKeys:count:));
        HSwizzleInstanceMethodNames(@[@"__NSDictionaryI", @"__NSSingleEntryDictionaryI"], @selector(objectForKeyedSubscript:), @selector(safe_objectForKeyedSubscript:));
    });
}
- (nullable id)safe_objectForKey:(id)aKey {
    if (aKey) {
        id obj = [self safe_objectForKey:aKey];
        if (obj && [obj isKindOfClass:[NSNull class]]) {
            return nil;
        }
        return [self safe_objectForKey:aKey];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
    return nil;
}
- (instancetype)safe_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    NSInteger index = 0;
    id ks[cnt];
    id objs[cnt];
    for (NSInteger i = 0; i < cnt ; ++i) {
        if (keys[i] && objects[i]) {
            ks[index] = keys[i];
            objs[index] = objects[i];
            ++index;
        }else {
#if DEBUG
            NSAssert(NO,nil);
#endif
            return [NSDictionary dictionary];
        }
    }
    return [self safe_initWithObjects:objects forKeys:keys count:cnt];
}
- (id)safe_objectForKeyedSubscript:(id)key {
    if (key && ![key isKindOfClass:NSNull.class]) {
        return [self safe_objectForKeyedSubscript:key];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
    return nil;
}
@end

@implementation NSMutableDictionary (HSafeUtil)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /** -[__NSDictionaryM setObject:forKeyedSubscript:]: key cannot be nil */
        HSwizzleInstanceMethodNames(@[@"__NSDictionaryM"], @selector(setObject:forKeyedSubscript:), @selector(safe_setObject:forKeyedSubscript:));
        HSwizzleInstanceMethodNames(@[@"__NSDictionaryM"], @selector(objectForKeyedSubscript:), @selector(safe_objectForKeyedSubscript:));
        
        /** -[__NSDictionaryM setObject:forKey:]: key cannot be nil */
        /** -[__NSDictionaryM setObject:forKey:]: object cannot be nil (key: 2) */
        HSwizzleInstanceMethodNames(@[@"__NSDictionaryM"], @selector(setObject:forKey:), @selector(safe_setObject:forKey:));
        
        /** -[__NSDictionaryM removeObjectForKey:]: key cannot be nil */
        HSwizzleInstanceMethodNames(@[@"__NSDictionaryM"], @selector(removeObjectForKey:), @selector(safe_removeObjectForKey:));
    });
}
- (void)safe_setObject:(id)anObject forKey:(id)aKey {
    if (aKey && ![aKey isKindOfClass:NSNull.class]) {
        [self safe_setObject:anObject forKey:aKey];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
}
- (void)safe_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (key) {
        [self safe_setObject:obj forKeyedSubscript:key];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
}
- (id)safe_objectForKeyedSubscript:(id)key {
    if (key && ![key isKindOfClass:NSNull.class]) {
        return [self safe_objectForKeyedSubscript:key];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
    return nil;
}
- (void)safe_removeObjectForKey:(id)aKey {
    if (aKey && ![aKey isKindOfClass:NSNull.class]) {
        [self safe_removeObjectForKey:aKey];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
}
@end


