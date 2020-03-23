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
/*
 *会影响到UISlider滑动事件的检测
 */
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [[self class] methodSwizzleWithOrigSEL:@selector(sendAction:to:forEvent:) overrideSEL:@selector(safe_sendAction:to:forEvent:)];
//    });
//}
- (void)safe_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    self.timeInterval = self.timeInterval == 0 ? KDefaultInterval: self.timeInterval;
    
    if (self.isIgnoreEvent) return;
    else if (self.timeInterval > 0) {
        [self performSelector:@selector(resetState) withObject:nil afterDelay:self.timeInterval];
    }
    
    self.isIgnoreEvent = YES;
    [self safe_sendAction:action to:target forEvent:event];
    
}
- (void)resetState {
    [self setIsIgnoreEvent:NO];
}


- (NSTimeInterval)timeInterval {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}
- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)isIgnoreEvent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent {
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIEdgeInsets)touchAreaInsets {
    return [objc_getAssociatedObject(self, @selector(touchAreaInsets)) UIEdgeInsetsValue];
}
- (void)setTouchAreaInsets:(UIEdgeInsets)touchAreaInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//let the min respond area is 44*44
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    //额外热区
    if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.touchAreaInsets)) {
        bounds = CGRectMake(bounds.origin.x - self.touchAreaInsets.left,
                            bounds.origin.y - self.touchAreaInsets.top,
                            bounds.size.width + self.touchAreaInsets.left + self.touchAreaInsets.right,
                            bounds.size.height + self.touchAreaInsets.top + self.touchAreaInsets.bottom);
    }
    //响应区域不小于44*44
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
