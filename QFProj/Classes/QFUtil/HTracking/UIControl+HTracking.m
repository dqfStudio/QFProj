//
//  UIControl+HTracking.m
//  QFProj
//
//  Created by dqf on 2018/7/28.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "UIControl+HTracking.h"

@implementation UIControl (HTracking)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodSwizzleWithOrigSEL:@selector(sendAction:to:forEvent:) overrideSEL:@selector(tracking_sendAction:to:forEvent:)];
    });
}
- (void)tracking_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [self tracking_sendAction:action to:target forEvent:event];
    printf("HPrinting-->你现在点击的是%s\n",[NSString stringWithFormat:@"%@_%@_%ld", NSStringFromClass([target class]), NSStringFromSelector(action), self.tag].UTF8String);
}
@end
