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
        
        /**
         __NSPlaceholderArray [NSArray alloc] alloc后未初始化的数组
         __NSArray0 [[NSArray alloc] init] 初始化的空数组
         __NSArrayI 初始化后有值的  不可变数组
         __NSArrayM 初始化后有值的  可变数组
         __NSSingleObjectArrayI 初始化后只有一个值的  不可变数组
         __NSFrozenArrayM 可变数组 copy后
         */
        //NSArray *arrayClassTitles = @[@"__NSArray0", @"__NSArrayI", @"__NSSingleObjectArrayI", @"__NSPlaceholderArray"];
        
        /** array[3] -[__NSArrayI objectAtIndexedSubscript:]: index 3 beyond bounds [0 .. 2] */
        HSwizzleInstanceMethodNames(@[@"__NSArrayI", @"__NSSingleObjectArrayI"], @selector(objectAtIndexedSubscript:), @selector(safe_objectAtIndexedSubscript:));
        
        /** [array objectAtIndex:3] -[__NSArrayI objectAtIndex:]: index 3 beyond bounds [0 .. 2] */
        HSwizzleInstanceMethodNames(@[@"__NSArrayI", @"__NSSingleObjectArrayI"], @selector(objectAtIndex:), @selector(safe_objectAtIndex:));
        
        /** [array addObject:@"3"] -[__NSArrayI addObject:]: unrecognized selector sent to instance 0x604000248550 */
        HSwizzleInstanceMethodNames(@[@"__NSArrayI", @"__NSSingleObjectArrayI"], @selector(addObject:), @selector(safe_addObject:));
        
        /** 类方法创建的数组,插入空时,下面这两个会崩溃 */
        //arrayWithObject    arrayWithObjects:nil count:1
        HSwizzleInstanceMethodNames(@[@"__NSPlaceholderArray"], @selector(initWithObjects:count:), @selector(safe_initWithObjects:count:));
        
        /** -[__NSArrayI objectForKeyedSubscript:]: unrecognized selector sent to instance 0x60000044ada0 */
        /** -[__NSSingleObjectArrayI objectForKeyedSubscript:]: unrecognized selector sent to instance 0x60400001a310 */
        HSwizzleInstanceMethodNames(@[@"__NSArrayI", @"__NSSingleObjectArrayI"], @selector(objectForKeyedSubscript:), @selector(safe_objectForKeyedSubscript:));
        
        /** -[__NSArrayI objectForKey:]: unrecognized selector sent to instance 0x604000220000 */
        /** -[__NSSingleObjectArrayI objectForKey:]: unrecognized selector sent to instance 0x60000000ffe0 */
        HSwizzleInstanceMethodNames(@[@"__NSArrayI", @"__NSSingleObjectArrayI"], @selector(objectForKey:), @selector(safe_objectForKey:));
    });
}
- (id)safe_objectAtIndex:(int)index {
    if(index >= 0 && index < self.count) {
        return [self safe_objectAtIndex:index];
    }else{
#if DEBUG
        NSAssert(NO,nil);
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
#endif
    }
    return nil;
}
- (id)safe_initWithObjects:(const id [])objects count:(NSUInteger)cnt {
    for (int i=0; i<cnt; i++) {
        if (objects == NULL){
#if DEBUG
            NSAssert(NO,nil);
#endif
            return nil;
        }
    }
    return [self safe_initWithObjects:objects count:cnt];
}
- (void)safe_addObject:(id)object {
    NSLog(@"exception %@:can't add object:%@", NSStringFromClass([self class]), object);
#if DEBUG
    NSAssert(NO,nil);
#endif
    return;
}
- (id)safe_objectForKeyedSubscript:(id)key {
    NSLog(@"exception %@:can't objectForKeyedSubscript:%@", NSStringFromClass([self class]), key);
#if DEBUG
    NSAssert(NO,nil);
#endif
    return nil;
}

- (id)safe_objectForKey:(id)key {
    NSLog(@"exception %@:can't objectForKey:%@", NSStringFromClass([self class]), key);
#if DEBUG
    NSAssert(NO,nil);
#endif
    return nil;
}
@end

@implementation NSMutableArray (HSafeUtil)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        /**
         __NSPlaceholderArray [NSArray alloc] alloc后未初始化的数组
         __NSArray0 [[NSArray alloc] init] 初始化的空数组
         __NSArrayI 初始化后有值的  不可变数组
         __NSArrayM 初始化后有值的  可变数组
         __NSSingleObjectArrayI 初始化后只有一个值的  不可变数组
         __NSFrozenArrayM 可变数组 copy后
         */
        NSArray *arrayClassTitles = @[@"__NSArrayM"];
        
        /** array[3] -[__NSArrayI objectAtIndexedSubscript:]: index 3 beyond bounds [0 .. 2] */
        HSwizzleInstanceMethodNames(arrayClassTitles, @selector(objectAtIndexedSubscript:), @selector(safe_objectAtIndexedSubscript:));
        
        /** [array objectAtIndex:3] -[__NSArrayI objectAtIndex:]: index 3 beyond bounds [0 .. 2] */
        HSwizzleInstanceMethodNames(arrayClassTitles, @selector(objectAtIndex:), @selector(safe_objectAtIndex:));
        
        /** [array addObject:nil] -[__NSArrayM insertObject:atIndex:]: object cannot be nil */
        HSwizzleInstanceMethodNames(arrayClassTitles, @selector(addObject:), @selector(safe_addObject:));
        
        /** *** -[__NSArrayM insertObject:atIndex:]: object cannot be nil */
        HSwizzleInstanceMethodNames(arrayClassTitles, @selector(insertObject:atIndex:), @selector(safe_insertObject:atIndex:));
        
        /** -[__NSArrayM replaceObjectAtIndex:withObject:]: index 3 beyond bounds [0 .. 1] */
        HSwizzleInstanceMethodNames(arrayClassTitles, @selector(replaceObjectAtIndex:withObject:), @selector(safe_replaceObjectAtIndex:withObject:));
        
        /** -[__NSArrayM objectForKeyedSubscript:]: unrecognized selector sent to instance 0x60000044ada0 */
        HSwizzleInstanceMethodNames(arrayClassTitles, @selector(objectForKeyedSubscript:), @selector(safe_objectForKeyedSubscript:));
        
        /** -[__NSArrayM objectForKey:]: unrecognized selector sent to instance 0x604000220000 */
        HSwizzleInstanceMethodNames(arrayClassTitles, @selector(objectForKey:), @selector(safe_objectForKey:));
    });
}
- (void)safe_addObject:(id)anObject {
    if(anObject){
        [self safe_addObject:anObject];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
}
- (id)safe_objectAtIndex:(int)index {
    if(index >= 0 && index < self.count) {
        return [self safe_objectAtIndex:index];
    }else{
#if DEBUG
        NSAssert(NO,nil);
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
#endif
    }
    return nil;
}
- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (!anObject) {
#if DEBUG
        NSAssert(NO,nil);
#endif
        return;
    }
    if (index < 0 || index > self.count) {
#if DEBUG
        NSAssert(NO,nil);
#endif
        return;
    }
    [self safe_insertObject:anObject atIndex:index];
}

- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (!anObject) {
#if DEBUG
        NSAssert(NO,nil);
#endif
        return;
    }
    if (index < 0 || index > self.count) {
#if DEBUG
        NSAssert(NO,nil);
#endif
        return;
    }
    [self safe_replaceObjectAtIndex:index withObject:anObject];
}

- (id)safe_objectForKeyedSubscript:(id)key {
    NSLog(@"exception %@:can't objectForKeyedSubscript:%@", NSStringFromClass([self class]), key);
#if DEBUG
    NSAssert(NO,nil);
#endif
    return nil;
}

- (id)safe_objectForKey:(id)key {
    NSLog(@"exception %@:can't objectForKey:%@", NSStringFromClass([self class]), key);
#if DEBUG
    NSAssert(NO,nil);
#endif
    return nil;
}

@end
