//
//  UIWindow+HPrinter.m
//  QFProj
//
//  Created by dqf on 2018/8/7.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "UIWindow+HPrinter.h"

@implementation UIWindow (HPrinter)

#if DEBUG
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 判断自己能否接收事件
    if(self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01){
        return nil;
    }
    // 触摸点在不在自己身上
    if ([self pointInside:point withEvent:event] == NO) {
        return nil;
    }
    // 从后往前遍历自己的子控件(重复前面的两个步骤)
    int count = (int)self.subviews.count;
    for (int i = count -1; i >= 0; i--) {
        UIView *childV = self.subviews[i];
        // point必须得要跟childV相同的坐标系.
        // 把point转换childV坐标系上面的点
        CGPoint childP = [self convertPoint:point toView:childV];
        UIView *fitView = [childV hitTest:childP withEvent:event];
        if (fitView) {
            [self printInfoWithView:fitView];
            return fitView;
        }
    }
    // 如果没有符合条件的子控件，那么就自己最适合处理
    [self printInfoWithView:self];
    return self;
}

- (void)printInfoWithView:(UIView *)view {
    if ([view isKindOfClass:UIView.class]) {
        NSString *ipString = [NSString stringWithFormat:@"%p", view];
        if ([[HPrinterManager share] containsObject:ipString]) {
            NSString *content = [[HPrinterManager share] objectForKey:ipString];
            if (content) {
                NSLog(@"printInfoWithView:%@",content);
            }
        }
    }
}
#endif

@end
