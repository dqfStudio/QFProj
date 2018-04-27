//
//  NSObject+HUtil.m
//  TestProject
//
//  Created by dqf on 2017/9/27.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSObject+HUtil.h"
#import <objc/runtime.h>

@implementation NSObject (HUtil)

// property list
- (NSArray *)ppList {
    return [NSObject ppListOfClass:self.class];
}

// property list of some class
+ (NSArray *)ppListOfClass:(Class)theClass {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    unsigned int count, i;
    objc_property_t *properties = class_copyPropertyList(theClass, &count);
    if (count) {
        for (i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString *key = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            if ([key isEqualToString:@"hash"]) continue;
            else if ([key isEqualToString:@"superclass"]) continue;
            else if ([key isEqualToString:@"description"]) continue;
            else if ([key isEqualToString:@"debugDescription"]) continue;
            [list addObject:key];
        }
    }
    free(properties);
    return list;
}

// property list of some class , it will iterate search
+ (NSArray *)depPPListOfClass:(Class)theClass {
    NSMutableArray *depPPlist = [NSMutableArray new];
    while (theClass != [NSObject class]) {
        NSArray *pplist = [NSObject ppListOfClass:theClass];
        [depPPlist addObjectsFromArray:pplist];
        theClass = class_getSuperclass(theClass);
    }
    return depPPlist;
}

+ (BOOL)isSystemClass:(Class)aClass {
    NSBundle *bundle = [NSBundle bundleForClass:aClass];
    if ([bundle isEqual:[NSBundle mainBundle]]) {
        return NO;
    }else {
        return YES;
    }
}

- (BOOL)isSystemClass:(Class)aClass {
    NSBundle *bundle = [NSBundle bundleForClass:aClass];
    if ([bundle isEqual:[NSBundle mainBundle]]) {
        return NO;
    }else {
        return YES;
    }
}

+ (Class)seekToSystemClass:(Class)aClass {
    
    NSBundle *bundle = [NSBundle bundleForClass:aClass];
    if ([bundle isEqual:[NSBundle mainBundle]]) {
        if (aClass.superclass) {
            return [self seekToSystemClass:aClass.superclass.class];
        }
    }else {
        return aClass;
    }
    
    return nil;
}

- (Class)seekToSystemClass:(Class)aClass {
    
    NSBundle *bundle = [NSBundle bundleForClass:aClass];
    if ([bundle isEqual:[NSBundle mainBundle]]) {
        if (aClass.superclass) {
            return [self seekToSystemClass:aClass.superclass.class];
        }
    }else {
        return aClass;
    }
    
    return nil;
}

@end
