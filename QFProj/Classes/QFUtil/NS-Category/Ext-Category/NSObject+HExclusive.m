//
//  NSObject+HExclusive.m
//  TestProject
//
//  Created by dqf on 2018/7/12.
//  Copyright © 2018年 socool. All rights reserved.
//

#import "NSObject+HExclusive.h"
#import <objc/runtime.h>

@interface NSObject ()
@property (nonatomic) NSMutableSet *exclusiveSet;
@end

@implementation NSObject (HExclusive)
- (NSMutableSet *)exclusiveSet {
    NSMutableSet *set = objc_getAssociatedObject(self, _cmd);
    if (!set) {
        set = NSMutableSet.new;
        [self setExclusiveSet:set];
    }
    return set;
}
- (void)setExclusiveSet:(NSMutableSet *)exclusiveSet {
    objc_setAssociatedObject(self, @selector(exclusiveSet), exclusiveSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)exclusive:(void (^)(void))exc {
    NSString *classString = NSStringFromClass(self.class);
    NSString *cmdString = NSStringFromSelector(_cmd);
    NSString *excString = [classString stringByAppendingString:cmdString];
    if (![self.exclusiveSet containsObject:excString]) {
        [self.exclusiveSet addObject:excString];
        exc();
        [self.exclusiveSet removeObject:excString];
    }
}
- (void)exclusive:(NSString * _Nonnull)exc block:(void (^)(HExclusive stop))block {
    NSString *classString = NSStringFromClass(self.class);
    NSString *cmdString = NSStringFromSelector(_cmd);
    NSString *excString = [[classString stringByAppendingString:cmdString] stringByAppendingString:exc];
    if (![self.exclusiveSet containsObject:excString]) {
        [self.exclusiveSet addObject:excString];
        HExclusive exclusive = ^ {
            [self.exclusiveSet removeObject:excString];
        };
        block(exclusive);
    }
}
- (void)synchronized:(void (^)(void))sync {
    @synchronized(self) {
        sync();
    }
}
@end
