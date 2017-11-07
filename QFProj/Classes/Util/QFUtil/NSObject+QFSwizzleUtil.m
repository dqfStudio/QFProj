//
//  NSObject+QFSwizzleUtil.m
//  TestProject
//
//  Created by dqf on 2017/9/28.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSObject+QFSwizzleUtil.h"
#import <objc/runtime.h>

@implementation NSObject (QFSwizzleUtil)

+ (void)methodSwizzleWithOrigSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL {
    Method origMethod = class_getInstanceMethod([self class], origSEL);
    Method overrideMethod= class_getInstanceMethod([self class], overrideSEL);
    if(class_addMethod([self class], origSEL, method_getImplementation(overrideMethod),method_getTypeEncoding(overrideMethod)))
    {
        class_replaceMethod([self class],overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else
    {
        method_exchangeImplementations(origMethod,overrideMethod);
    }
}
- (void)methodSwizzleWithOrigSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL {
    Method origMethod = class_getInstanceMethod([self class], origSEL);
    Method overrideMethod= class_getInstanceMethod([self class], overrideSEL);
    if(class_addMethod([self class], origSEL, method_getImplementation(overrideMethod),method_getTypeEncoding(overrideMethod)))
    {
        class_replaceMethod([self class],overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else
    {
        method_exchangeImplementations(origMethod,overrideMethod);
    }
}
@end


@implementation NSArray (QFSafeUtil)
+ (void)load {
    [objc_getClass("__NSPlaceholderArray") methodSwizzleWithOrigSEL:@selector(initWithObjects:count:) overrideSEL:@selector(safe_initWithObjects:count:)];
    
    [objc_getClass("__NSArrayI") methodSwizzleWithOrigSEL:@selector(objectAtIndex:) overrideSEL:@selector(safe_objectAtIndex:)];
    
    [objc_getClass("__NSArrayM") methodSwizzleWithOrigSEL:@selector(objectAtIndex:) overrideSEL:@selector(safe_objectAtIndex:)];
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
- (id)safe_initWithObjects:(const id [])objects count:(NSUInteger)cnt {
    for (int i=0; i<cnt; i++) {
        if(objects[i] == nil) {
#if DEBUG
            NSAssert(NO,nil);
#endif
            return nil;
        }
    }
    return [self safe_initWithObjects:objects count:cnt];
}
@end

@implementation NSMutableArray (QFSafeUtil)
+ (void)load {
    [objc_getClass("__NSArrayM") methodSwizzleWithOrigSEL:@selector(addObject:) overrideSEL:@selector(safe_addObject:)];
}
- (void)safe_addObject:(id)anObject {
    if(anObject != nil){
        [self safe_addObject:anObject];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
}
@end


@implementation NSDictionary (QFSafeUtil)
+ (void)load {
    [objc_getClass("__NSDictionaryI") methodSwizzleWithOrigSEL:@selector(objectForKey:) overrideSEL:@selector(safe_objectForKey:)];
    
    
    [objc_getClass("__NSDictionaryM") methodSwizzleWithOrigSEL:@selector(objectForKey:) overrideSEL:@selector(safe_objectForKey:)];
}
- (nullable id)safe_objectForKey:(id)aKey {
    if (aKey != nil) {
        return [self objectForKey:aKey];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
    return nil;
}
@end

@implementation NSMutableDictionary (QFSafeUtil)
+ (void)load {
    [objc_getClass("__NSDictionaryM") methodSwizzleWithOrigSEL:@selector(setObject:forKey:) overrideSEL:@selector(safe_setObject:forKey:)];
}
- (void)safe_setObject:(id)anObject forKey:(id)aKey {
    if (aKey != nil) {
        [self setObject:anObject forKey:aKey];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
}
@end
