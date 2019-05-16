//
//  HTextDebugOption.m
//
//  Created by ibireme on 15/4/8.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "HTextDebugOption.h"
#import "HTextWeakProxy.h"
#import <libkern/OSAtomic.h>
#import <pthread.h>

static pthread_mutex_t _hSharedDebugLock;
static CFMutableSetRef _hSharedDebugTargets = nil;
static HTextDebugOption *_hSharedDebugOption = nil;

static const void* _hSharedDebugSetRetain(CFAllocatorRef allocator, const void *value) {
    return value;
}

static void _hSharedDebugSetRelease(CFAllocatorRef allocator, const void *value) {
}

void _hSharedDebugSetFunction(const void *value, void *context) {
    id<HTextDebugTarget> target = (__bridge id<HTextDebugTarget>)(value);
    [target setDebugOption:_hSharedDebugOption];
}

static void _initHSharedDebug() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pthread_mutex_init(&_hSharedDebugLock, NULL);
        CFSetCallBacks callbacks = kCFTypeSetCallBacks;
        callbacks.retain = _hSharedDebugSetRetain;
        callbacks.release = _hSharedDebugSetRelease;
        _hSharedDebugTargets = CFSetCreateMutable(CFAllocatorGetDefault(), 0, &callbacks);
    });
}

static void _setHSharedDebugOption(HTextDebugOption *option) {
    _initHSharedDebug();
    pthread_mutex_lock(&_hSharedDebugLock);
    _hSharedDebugOption = option.copy;
    CFSetApplyFunction(_hSharedDebugTargets, _hSharedDebugSetFunction, NULL);
    pthread_mutex_unlock(&_hSharedDebugLock);
}

static HTextDebugOption *_getHSharedDebugOption() {
    _initHSharedDebug();
    pthread_mutex_lock(&_hSharedDebugLock);
    HTextDebugOption *op = _hSharedDebugOption;
    pthread_mutex_unlock(&_hSharedDebugLock);
    return op;
}

static void _addHDebugTarget(id<HTextDebugTarget> target) {
    _initHSharedDebug();
    pthread_mutex_lock(&_hSharedDebugLock);
    CFSetAddValue(_hSharedDebugTargets, (__bridge const void *)(target));
    pthread_mutex_unlock(&_hSharedDebugLock);
}

static void _removeHDebugTarget(id<HTextDebugTarget> target) {
    _initHSharedDebug();
    pthread_mutex_lock(&_hSharedDebugLock);
    CFSetRemoveValue(_hSharedDebugTargets, (__bridge const void *)(target));
    pthread_mutex_unlock(&_hSharedDebugLock);
}


@implementation HTextDebugOption

- (id)copyWithZone:(NSZone *)zone {
    HTextDebugOption *op = [self.class new];
    op.baselineColor = self.baselineColor;
    op.CTFrameBorderColor = self.CTFrameBorderColor;
    op.CTFrameFillColor = self.CTFrameFillColor;
    op.CTLineBorderColor = self.CTLineBorderColor;
    op.CTLineFillColor = self.CTLineFillColor;
    op.CTLineNumberColor = self.CTLineNumberColor;
    op.CTRunBorderColor = self.CTRunBorderColor;
    op.CTRunFillColor = self.CTRunFillColor;
    op.CTRunNumberColor = self.CTRunNumberColor;
    op.CGGlyphBorderColor = self.CGGlyphBorderColor;
    op.CGGlyphFillColor = self.CGGlyphFillColor;
    return op;
}

- (BOOL)needDrawDebug {
    if (self.baselineColor ||
        self.CTFrameBorderColor ||
        self.CTFrameFillColor ||
        self.CTLineBorderColor ||
        self.CTLineFillColor ||
        self.CTLineNumberColor ||
        self.CTRunBorderColor ||
        self.CTRunFillColor ||
        self.CTRunNumberColor ||
        self.CGGlyphBorderColor ||
        self.CGGlyphFillColor) return YES;
    return NO;
}

- (void)clear {
    self.baselineColor = nil;
    self.CTFrameBorderColor = nil;
    self.CTFrameFillColor = nil;
    self.CTLineBorderColor = nil;
    self.CTLineFillColor = nil;
    self.CTLineNumberColor = nil;
    self.CTRunBorderColor = nil;
    self.CTRunFillColor = nil;
    self.CTRunNumberColor = nil;
    self.CGGlyphBorderColor = nil;
    self.CGGlyphFillColor = nil;
}

+ (void)addDebugTarget:(id<HTextDebugTarget>)target {
    if (target) _addHDebugTarget(target);
}

+ (void)removeDebugTarget:(id<HTextDebugTarget>)target {
    if (target) _removeHDebugTarget(target);
}

+ (HTextDebugOption *)sharedDebugOption {
    return _getHSharedDebugOption();
}

+ (void)setSharedDebugOption:(HTextDebugOption *)option {
    NSAssert([NSThread isMainThread], @"This method must be called on the main thread");
    _setHSharedDebugOption(option);
}

@end

