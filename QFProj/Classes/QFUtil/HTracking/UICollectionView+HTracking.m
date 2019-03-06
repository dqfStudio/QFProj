//
//  UICollectionView+HTracking.m
//  QFProj
//
//  Created by dqf on 2018/7/28.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "UICollectionView+HTracking.h"
#import <objc/message.h>

@implementation UICollectionView (HTracking)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodSwizzleWithOrigSEL:@selector(setDelegate:) overrideSEL:@selector(tracking_setDelegate:)];
    });
}

- (void)tracking_setDelegate:(id<UICollectionViewDelegate>)delegate {
    
    [self tracking_setDelegate:delegate];
    Class class = [delegate class];
    
    if (class_addMethod([delegate class], NSSelectorFromString(@"tracking_didSelectItemAtIndexPath"), (IMP)tracking_didSelectItemAtIndexPath, "v@:@@")) {
        Method dis_originalMethod = class_getInstanceMethod(class, NSSelectorFromString(@"tracking_didSelectItemAtIndexPath"));
        Method dis_swizzledMethod = class_getInstanceMethod(class, @selector(collectionView:didSelectItemAtIndexPath:));
        method_exchangeImplementations(dis_originalMethod, dis_swizzledMethod);
    }
}

void tracking_didSelectItemAtIndexPath(id self, SEL _cmd, id collectionView, id indexpath)
{
    SEL selector = NSSelectorFromString(@"tracking_didSelectItemAtIndexPath");
    ((void(*)(id, SEL,id, id))objc_msgSend)(self, selector, collectionView, indexpath);
    
    NSLog(@"你现在正在点击的是%@页面的第%ld栏第%ld行",NSStringFromClass([self class]),((NSIndexPath *)indexpath).section,((NSIndexPath *)indexpath).row);
}

@end
