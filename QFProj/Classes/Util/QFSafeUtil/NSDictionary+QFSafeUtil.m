//
//  NSDictionary+QFSafeUtil.m
//  TestProject
//
//  Created by dqf on 2017/9/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSDictionary+QFSafeUtil.h"

@implementation NSDictionary (QFSafeUtil)
#if DEBUG
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
        NSAssert(NO,nil);
    }
    return nil;
}
#endif
@end

@implementation NSMutableDictionary (QFSafeUtil)
#if DEBUG
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSDictionaryM") methodSwizzleWithOrigSEL:@selector(setObject:forKey:) overrideSEL:@selector(safe_setObject:forKey:)];
    });
}
- (void)safe_setObject:(id)anObject forKey:(id)aKey {
    if (aKey != nil) {
        [self safe_setObject:anObject forKey:aKey];
    }else {
        NSAssert(NO,nil);
    }
}
#endif
@end

