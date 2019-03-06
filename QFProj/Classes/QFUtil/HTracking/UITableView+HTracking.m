//
//  UITableView+HTracking.m
//  QFProj
//
//  Created by dqf on 2018/7/28.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "UITableView+HTracking.h"
#import <objc/message.h>

@implementation UITableView (HTracking)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodSwizzleWithOrigSEL:@selector(setDelegate:) overrideSEL:@selector(tracking_setDelegate:)];
    });
}

- (void)tracking_setDelegate:(id<UITableViewDelegate>)delegate {
    [self tracking_setDelegate:delegate];
    Class class = [delegate class];
    // 在代理人这先添加用于实现统计的方法，然后和交换原先的点击方法
    if (class_addMethod(class, NSSelectorFromString(@"tracking_didSelectRowAtIndexPath"), (IMP)tracking_didSelectRowAtIndexPath, "v@:@@")) {
        Method dis_originalMethod = class_getInstanceMethod(class, NSSelectorFromString(@"tracking_didSelectRowAtIndexPath"));
        Method dis_swizzledMethod = class_getInstanceMethod(class, @selector(tableView:didSelectRowAtIndexPath:));
        method_exchangeImplementations(dis_originalMethod, dis_swizzledMethod);
    }
}

void tracking_didSelectRowAtIndexPath(id self, SEL _cmd, id tableView, id indexpath)
{
    SEL selector = NSSelectorFromString(@"tracking_didSelectRowAtIndexPath");
    ((void(*)(id, SEL,id, id))objc_msgSend)(self, selector, tableView, indexpath);

    NSLog(@"你现在正在点击的是%@页面的第%ld栏第%ld行",NSStringFromClass([self class]),((NSIndexPath *)indexpath).section,((NSIndexPath *)indexpath).row);
}

@end

