//
//  HTransaction.m
//  HAsyncLayer
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HTransaction.h"

@interface HTransaction ()
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL selector;
@end

static NSMutableSet *transactionSet = nil;

static void HRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    if (transactionSet.count == 0) return;
    NSSet *transactions = transactionSet;
    transactionSet = [NSMutableSet new];
    [transactions enumerateObjectsUsingBlock:^(HTransaction *  _Nonnull transaction, BOOL * _Nonnull stop) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [transaction.target performSelector:transaction.selector];
#pragma clang diagnostic pop
    }];
}


static void HTransactionSetup() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transactionSet = [NSMutableSet new];
        CFRunLoopRef runLoop = CFRunLoopGetMain();
        CFRunLoopObserverRef observer;
        observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopBeforeWaiting | kCFRunLoopExit, true, 0xFFFFFF,HRunLoopObserverCallBack, NULL);
        CFRunLoopAddObserver(runLoop, observer, kCFRunLoopCommonModes);
        CFRelease(observer);
    });
}

@implementation HTransaction

+ (instancetype)transactionWithTarget:(id)target selector:(SEL)selector {
    HTransaction *transaction = [HTransaction new];
    transaction.target = target;
    transaction.selector = selector;
    return transaction;
}

- (void)commit {
    if (!_target || !_selector) return;
    HTransactionSetup();
    [transactionSet addObject:self];
}

- (NSUInteger)hash {
    long v1 = (long)((void *)_selector);
    long v2 = (long)_target;
    return v1 ^ v2;
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isMemberOfClass:self.class]) return NO;
    HTransaction *other = object;
    return other.selector == _selector && other.target == _target;
}

@end






