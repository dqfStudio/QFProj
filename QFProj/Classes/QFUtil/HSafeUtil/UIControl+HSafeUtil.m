//
//  UIControl+HSafeUtil.m
//  HProj
//
//  Created by dqf on 2017/9/30.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "UIControl+HSafeUtil.h"

#define KDefaultInterval 0.5  //默认时间间隔

@interface UIControl()
@property (nonatomic, assign) BOOL isIgnoreEvent;
@end

@implementation UIControl (HSafeUtil)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodSwizzleWithOrigSEL:@selector(sendAction:to:forEvent:) overrideSEL:@selector(safe_sendAction:to:forEvent:)];
    });
}

- (void)safe_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    self.timeInterval = self.timeInterval == 0 ? KDefaultInterval: self.timeInterval;
    
    if (self.isIgnoreEvent) return;
    else if (self.timeInterval > 0) {
        [self performSelector:@selector(resetState) withObject:nil afterDelay:self.timeInterval];
    }
    
    self.isIgnoreEvent = YES;
    [self safe_sendAction:action to:target forEvent:event];
    
}

- (NSTimeInterval)timeInterval {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent {
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isIgnoreEvent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)resetState {
    [self setIsIgnoreEvent:NO];
}

@end
