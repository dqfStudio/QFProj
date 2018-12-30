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
- (void)exclusive:(NSString * _Nonnull)exc block:(void (^)(HExclusive stop))block {
    NSString *excString = [[NSString stringWithFormat:@"%p", self] stringByAppendingString:exc];
    if (![self.exclusiveSet containsObject:excString]) {
        [self.exclusiveSet addObject:excString];
        HExclusive exclusive = ^ {
            if ([self.exclusiveSet containsObject:excString]) {
                [self.exclusiveSet removeObject:excString];
            }
        };
        block(exclusive);
    }
}
- (void)removeExclusive:(NSString * _Nonnull)exc {
    NSString *excString = [[NSString stringWithFormat:@"%p", self] stringByAppendingString:exc];
    if ([self.exclusiveSet containsObject:excString]) {
        [self.exclusiveSet removeObject:excString];
    }
}
- (void)synchronized:(void (^)(void))sync {
    @synchronized(self) {
        sync();
    }
}
@end


@implementation UIView (HExclusive)

- (void)exclusiveOtherTouch {
    [self setExclusiveTouch:YES];
}
+ (void)exclusiveOtherTouch {
    [[UIView appearance] setExclusiveTouch:YES];
}
@end

@interface UIView ()
@property (nonatomic) NSMutableSet *idSet;
@end

@implementation UIView (HMark)

- (NSMutableSet *)idSet {
    NSMutableSet *set = objc_getAssociatedObject(self, _cmd);
    if (!set) {
        set = NSMutableSet.new;
        [self setIdSet:set];
    }
    return set;
}
- (void)setIdSet:(NSMutableSet *)idSet {
    objc_setAssociatedObject(self, @selector(idSet), idSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)containsId:(NSString *)anId {
    return [self.idSet containsObject:anId];
}
- (void)addId:(NSString *)anId {
    if (![self.idSet containsObject:anId]) {
        [self.idSet addObject:anId];
    }
}
- (void)removeId:(NSString *)anId {
    if ([self.idSet containsObject:anId]) {
        [self.idSet removeObject:anId];
    }
}

@end


@interface NSObject ()
@property (nonatomic) NSMutableDictionary *segStatueDict;
@end

@implementation NSObject (HState)
- (NSString *)segAlias {
    NSString *alias = objc_getAssociatedObject(self, _cmd);
    if (!alias) {
        alias = NSString.new;
        [self setSegAlias:alias];
    }
    return alias;
}
- (void)setSegAlias:(NSString *)segAlias {
    objc_setAssociatedObject(self, @selector(segAlias), segAlias, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)segStatue {
    NSNumber *statue = objc_getAssociatedObject(self, _cmd);
    if (!statue) {
        return 0;
    }
    return statue.integerValue;
}
- (void)setSegStatue:(NSInteger)segStatue {
    objc_setAssociatedObject(self, @selector(segStatue), @(segStatue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)segStatues {
    return self.segStatueDict.allKeys.count;
}
- (NSMutableDictionary *)segStatueDict {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (!dict) {
        dict = NSMutableDictionary.new;
        [self setSegStatueDict:dict];
    }
    return dict;
}
- (void)setSegStatueDict:(NSMutableDictionary *)segStatueDict {
    objc_setAssociatedObject(self, @selector(segStatueDict), segStatueDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setObject:(id)anObject forSegStatue:(NSInteger)segStatue {
    NSString *key = [NSString stringWithFormat:@"%ld", (long)segStatue];
    [self.segStatueDict setObject:anObject forKey:key];
}
- (nullable id)objectForSegStatue:(NSInteger)segStatue {
    NSString *key = [NSString stringWithFormat:@"%ld", (long)segStatue];
    return [self.segStatueDict objectForKey:key];
}
- (void)removeObjectForSegStatue:(NSInteger)segStatue {
    NSString *key = [NSString stringWithFormat:@"%ld", (long)segStatue];
    if ([self.segStatueDict.allKeys containsObject:key]) {
        [self.segStatueDict removeObjectForKey:key];
    }
}
- (BOOL)containObjectOfSegAlias {
    if ([self.segStatueDict.allKeys containsObject:@"0"]) {
        return YES;
    }
    return NO;
}
- (void)clearSegStatue {
    [self setSegStatue:0];
    if (self.segStatueDict.count > 0) {
        [self.segStatueDict removeAllObjects];
    }
}
@end
