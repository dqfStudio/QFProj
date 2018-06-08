//
//  NSArray+HSafeUtil.m
//  TestProject
//
//  Created by dqf on 2017/9/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSArray+HSafeUtil.h"

@implementation NSArray (HSafeUtil)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSPlaceholderArray") methodSwizzleWithOrigSEL:@selector(initWithObjects:count:) overrideSEL:@selector(safe_initWithObjects:count:)];
        [objc_getClass("__NSArrayI") methodSwizzleWithOrigSEL:@selector(objectAtIndex:) overrideSEL:@selector(safe_objectAtIndex:)];
        [objc_getClass("__NSArrayI") methodSwizzleWithOrigSEL:@selector(objectAtIndexedSubscript:) overrideSEL:@selector(safe_objectAtIndexedSubscript:)];
    });
}
- (id)safe_objectAtIndex:(int)index {
    if(index >= 0 && index < self.count) {
        return [self safe_objectAtIndex:index];
    }else{
#if DEBUG
        NSAssert(NO,nil);
#else
        return @"";
#endif
    }
    return nil;
}
- (id)safe_objectAtIndexedSubscript:(int)index {
    if(index >= 0 && index < self.count) {
        return [self safe_objectAtIndexedSubscript:index];
    }else{
#if DEBUG
        NSAssert(NO,nil);
#else
        return @"";
#endif
    }
    return nil;
}
- (id)safe_initWithObjects:(const id [])objects count:(NSUInteger)cnt {
    for (int i=0; i<cnt; i++) {
        if(objects[i] == nil) {
#if DEBUG
            NSAssert(NO,nil);
#else
            objects[i] = @"";
#endif
        }
    }
    return [self safe_initWithObjects:objects count:cnt];
}
@end

@implementation NSMutableArray (HSafeUtil)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArrayM") methodSwizzleWithOrigSEL:@selector(addObject:) overrideSEL:@selector(safe_addObject:)];
    });
}
- (void)safe_addObject:(id)anObject {
    if(anObject != nil){
        [self safe_addObject:anObject];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#else
        [self safe_addObject:@""];
#endif
    }
}
@end

