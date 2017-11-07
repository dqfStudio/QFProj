//
//  NSObject+QFSafeNotify.m
//  TestProject
//
//  Created by dqf on 2017/9/30.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSObject+QFSafeNotify.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface NSObject (QFNotify)
@property (nonatomic, strong) NSMutableArray *observers;
@end

@implementation NSObject (QFSafeNotify)

- (NSMutableArray *)observers {
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, [NSMutableArray new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setObservers:(NSMutableArray *)observers {
    objc_setAssociatedObject(self, @selector(observers), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)registerNoti:(NSString *)name callback:(void(^)(NSNotification * note))callback {
    if (name == nil) return;
    NSObject *observer = [[NSNotificationCenter defaultCenter] addObserverForName:name object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (callback) {
            callback(note);
        }
    }];
    if (observer) {
        if ([self.observers containsObject:observer]) [self.observers removeObject:observer];
        [self.observers addObject:observer];
    }
}

- (void)postNoti:(NSString *)name {
    if (name == nil) return;
    [self postNoti:name object:nil];
}

- (void)postNoti:(NSString *)name object:(id)anObject {
    if (name == nil) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:anObject];
}

@end
