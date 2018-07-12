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
    if (exc && ![self.exclusiveSet containsObject:exc]) {
        [self.exclusiveSet addObject:exc];
        exc();
        [self.exclusiveSet removeObject:exc];
    }
}
- (void)synchronized:(void (^)(void))sync {
    @synchronized(self) {
        sync();
    }
}
@end
