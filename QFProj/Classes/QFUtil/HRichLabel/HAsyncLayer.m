//
//  HAsyncLayer.m
//  HAsyncLayer
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HAsyncLayer.h"
#import <libkern/OSAtomic.h>

@implementation HAsyncLayerDisplayTask
@end


static dispatch_queue_t HAsyncLayerDisplayQueue() {

#define MAX_QUEUE_COUNT 16
    static dispatch_queue_t queues[MAX_QUEUE_COUNT];
    static NSUInteger queueCount = 0;
    static int32_t counter = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queueCount = [NSProcessInfo processInfo].activeProcessorCount;
        
        if (queueCount < 1) {
            queueCount = 1;
        } else if (queueCount > MAX_QUEUE_COUNT) {
            queueCount = MAX_QUEUE_COUNT;
        }
        
        
        for (NSUInteger i = 0; i < queueCount; i++) {
            dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
            queues[i] = dispatch_queue_create("com.simplezero.github.render", attr);
        }
    });
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    int32_t c = OSAtomicIncrement32(&counter);
#pragma clang diagnostic pop
    if (c < 0) c = -c;
    return queues[c % queueCount];
#undef MAX_QUEUE_COUNT
}

@implementation HAsyncLayer {
    int32_t _value;
}

#pragma mark -Override
- (instancetype)init {
    if (self = [super init]) {
        static CGFloat scale;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            scale = [UIScreen mainScreen].scale;
        });
        self.contentsScale = scale;
        _value = 0;
        _displaysAsynchronously = YES;
    }
    return self;
}

- (void)dealloc {
    [self _increase];
}

- (void)setNeedsDisplay {
    [self _cancelAsyncDisplay];
    [super setNeedsDisplay];
}

- (void)display {
    super.contents = super.contents;
    [self _displayAsync:_displaysAsynchronously];
}

#pragma mark -Private
- (int32_t)_increase {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return OSAtomicIncrement32(&_value);
#pragma clang diagnostic pop
}

- (void)_cancelAsyncDisplay {
    [self _increase];
}

- (void)_displayAsync:(BOOL)async {
    __strong id<HAsyncLayerDelegate> delegate = (id)self.delegate;
    HAsyncLayerDisplayTask *task = [delegate newAsyncLayerDisplayTask];
    if (!task.display) {
        if (task.willDisplay) task.willDisplay(self);
        self.contents = nil;
        if (task.didDisplay) task.didDisplay(self, YES);
        return;
    }
    
    CGSize size = self.bounds.size;
    BOOL opaque = self.opaque;
    CGFloat scale = self.contentsScale;
    
    __block CGColorRef bgColor = NULL;
    if (opaque && self.backgroundColor) {
        bgColor = CGColorRetain(self.backgroundColor);
    }
    
    if (async) {
        if (task.willDisplay) task.willDisplay(self);
        int32_t value = _value;
        
        BOOL (^isCancelled)(void) = ^BOOL(){
            return value != self->_value;
        };
        
        dispatch_async(HAsyncLayerDisplayQueue(), ^{
            if (isCancelled()) {
                CGColorRelease(bgColor);
                return;
            }
            
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            if (opaque && context) {
                CGContextSaveGState(context); {
                    bgColor = bgColor ? : [UIColor whiteColor].CGColor;
                    CGContextSetFillColorWithColor(context, bgColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                    CGContextFillPath(context);
                } CGContextRestoreGState(context);
                CGColorRelease(bgColor);
            }
                
            task.display(context, size, isCancelled);
            if (isCancelled()) {
                UIGraphicsEndImageContext();
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didDisplay) task.didDisplay(self, NO);
                });
                return;
            }
            
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            if (isCancelled()) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didDisplay) task.didDisplay(self, NO);
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isCancelled()) {
                    if (task.didDisplay) task.didDisplay(self, NO);
                } else {
                    self.contents = (__bridge id _Nullable)(img.CGImage);
                    if (task.didDisplay) task.didDisplay(self, YES);
                }
            });
        });

    } else {
        [self _increase];
        
        if (task.willDisplay) task.willDisplay(self);
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if (opaque && context) {
            CGContextSaveGState(context); {
                if (opaque) {
                    bgColor = bgColor ? : [UIColor whiteColor].CGColor;
                    CGContextSetFillColorWithColor(context, bgColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height *scale));
                    CGContextFillPath(context);
                }
            } CGContextRestoreGState(context);
            CGColorRelease(bgColor);
        }
        
        task.display(context, size, ^(){return NO;});
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.contents = (__bridge id _Nullable)(img.CGImage);
        if (task.didDisplay) task.didDisplay(self, YES);
    }
}

@end
