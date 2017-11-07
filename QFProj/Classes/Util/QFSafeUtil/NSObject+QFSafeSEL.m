//
//  NSObject+QFSafeSEL.m
//  TestProject
//
//  Created by dqf on 2017/9/30.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSObject+QFSafeSEL.h"

@implementation NSObject (QFSafeSEL)
#if DEBUG
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodSwizzleWithOrigSEL:@selector(performSelector:) overrideSEL:@selector(safe_performSelector:)];
        [[self class] methodSwizzleWithOrigSEL:@selector(performSelector:withObject:) overrideSEL:@selector(safe_performSelector:withObject:)];
        [[self class] methodSwizzleWithOrigSEL:@selector(performSelector:withObject:withObject:) overrideSEL:@selector(safe_performSelector:withObject:withObject:)];
        
        
        [[self class] methodSwizzleWithOrigSEL:@selector(performSelectorOnMainThread:withObject:waitUntilDone:modes:) overrideSEL:@selector(safe_performSelectorOnMainThread:withObject:waitUntilDone:modes:)];
        [[self class] methodSwizzleWithOrigSEL:@selector(performSelectorOnMainThread:withObject:waitUntilDone:) overrideSEL:@selector(safe_performSelectorOnMainThread:withObject:waitUntilDone:)];
        [[self class] methodSwizzleWithOrigSEL:@selector(performSelector:onThread:withObject:waitUntilDone:modes:) overrideSEL:@selector(safe_performSelector:onThread:withObject:waitUntilDone:modes:)];
        [[self class] methodSwizzleWithOrigSEL:@selector(performSelector:onThread:withObject:waitUntilDone:) overrideSEL:@selector(safe_performSelector:onThread:withObject:waitUntilDone:)];
        [[self class] methodSwizzleWithOrigSEL:@selector(performSelectorInBackground:withObject:) overrideSEL:@selector(safe_performSelectorInBackground:withObject:)];
        
        
        [[self class] methodSwizzleWithOrigSEL:@selector(performSelector:withObject:afterDelay:inModes:) overrideSEL:@selector(safe_performSelector:withObject:afterDelay:inModes:)];
        [[self class] methodSwizzleWithOrigSEL:@selector(performSelector:withObject:afterDelay:) overrideSEL:@selector(safe_performSelector:withObject:afterDelay:)];
        
        
        [[self class] methodSwizzleWithOrigSEL:@selector(performSelector:target:argument:order:modes:) overrideSEL:@selector(safe_performSelector:target:argument:order:modes:)];
        [[self class] methodSwizzleWithOrigSEL:@selector(cancelPerformSelector:target:argument:) overrideSEL:@selector(safe_cancelPerformSelector:target:argument:)];
    });
}
- (void)safe_performSelector:(SEL)aSelector {
    if ([self respondsToSelector:aSelector]) {
        [self safe_performSelector:aSelector];
    }else {
        NSAssert(NO,nil);
    }
}
- (void)safe_performSelector:(SEL)aSelector withObject:(id)object {
    if ([self respondsToSelector:aSelector]) {
        [self safe_performSelector:aSelector withObject:object];
    }else {
        NSAssert(NO,nil);
    }
}
- (void)safe_performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2 {
    if ([self respondsToSelector:aSelector]) {
        [self safe_performSelector:aSelector withObject:object1 withObject:object2];
    }else {
        NSAssert(NO,nil);
    }
}


- (void)safe_performSelectorOnMainThread:(SEL)aSelector withObject:(nullable id)arg waitUntilDone:(BOOL)wait modes:(nullable NSArray<NSString *> *)array {
    if ([self respondsToSelector:aSelector]) {
        [self safe_performSelectorOnMainThread:aSelector withObject:arg waitUntilDone:wait modes:array];
    }else {
        NSAssert(NO,nil);
    }
}
- (void)safe_performSelectorOnMainThread:(SEL)aSelector withObject:(nullable id)arg waitUntilDone:(BOOL)wait {
    if ([self respondsToSelector:aSelector]) {
        [self safe_performSelectorOnMainThread:aSelector withObject:arg waitUntilDone:wait];
    }else {
        NSAssert(NO,nil);
    }
}
- (void)safe_performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(nullable id)arg waitUntilDone:(BOOL)wait modes:(nullable NSArray<NSString *> *)array {
    if ([self respondsToSelector:aSelector]) {
        [self safe_performSelector:aSelector onThread:thr withObject:arg waitUntilDone:wait modes:array];
    }else {
        NSAssert(NO,nil);
    }
}
- (void)safe_performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(nullable id)arg waitUntilDone:(BOOL)wait {
    if ([self respondsToSelector:aSelector]) {
        [self safe_performSelector:aSelector onThread:thr withObject:arg waitUntilDone:wait];
    }else {
        NSAssert(NO,nil);
    }
}
- (void)safe_performSelectorInBackground:(SEL)aSelector withObject:(nullable id)arg {
    if ([self respondsToSelector:aSelector]) {
        [self safe_performSelectorInBackground:aSelector withObject:arg];
    }else {
        NSAssert(NO,nil);
    }
}


- (void)safe_performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay inModes:(NSArray<NSRunLoopMode> *)modes {
    if ([self respondsToSelector:aSelector]) {
        [self safe_performSelector:aSelector withObject:anArgument afterDelay:delay inModes:modes];
    }else {
        NSAssert(NO,nil);
    }
}
- (void)safe_performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay {
    if ([self respondsToSelector:aSelector]) {
        [self safe_performSelector:aSelector withObject:anArgument afterDelay:delay];
    }else {
        NSAssert(NO,nil);
    }
}

- (void)safe_performSelector:(SEL)aSelector target:(id)target argument:(nullable id)arg order:(NSUInteger)order modes:(NSArray<NSRunLoopMode> *)modes {
    if ([self respondsToSelector:aSelector]) {
        [self safe_performSelector:aSelector target:target argument:arg order:order modes:modes];
    }else {
        NSAssert(NO,nil);
    }
}
- (void)safe_cancelPerformSelector:(SEL)aSelector target:(id)target argument:(nullable id)arg {
    if ([self respondsToSelector:aSelector]) {
        [self safe_cancelPerformSelector:aSelector target:target argument:arg];
    }else {
        NSAssert(NO,nil);
    }
}
#endif
@end


