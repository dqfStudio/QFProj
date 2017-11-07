//
//  NSArray+QFSafeUtil.m
//  TestProject
//
//  Created by dqf on 2017/9/29.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSArray+QFSafeUtil.h"

@implementation NSArray (QFSafeUtil)
#if DEBUG
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
        NSAssert(NO,nil);
    }
    return nil;
}
- (id)safe_objectAtIndexedSubscript:(int)index {
    if(index >= 0 && index < self.count) {
        return [self safe_objectAtIndexedSubscript:index];
    }else{
        NSAssert(NO,nil);
    }
    return nil;
}
- (id)safe_initWithObjects:(const id [])objects count:(NSUInteger)cnt {
    for (int i=0; i<cnt; i++) {
        if(objects[i] == nil) {
            NSAssert(NO,nil);
            return nil;
        }
    }
    return [self safe_initWithObjects:objects count:cnt];
}
#endif
@end

@implementation NSMutableArray (QFSafeUtil)
#if DEBUG
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
        NSAssert(NO,nil);
    }
}
#endif
@end

