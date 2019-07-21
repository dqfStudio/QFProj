
//
//  UIView+HLeaks.m
//  QFProj
//
//  Created by wind on 2019/7/16.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "UIView+HLeaks.h"
#import <objc/message.h>
#import "NSObject+HSwizzleUtil.h"

#if DEBUG
@implementation UIView (HLeaks)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodSwizzleWithOrigSEL:@selector(willMoveToSuperview:) overrideSEL:@selector(leaks_willMoveToSuperview:)];
    });
}
- (void)leaks_willMoveToSuperview:(UIView *)newView {
    if ([self isCustomClass]) {
        if (!newView) {
            [self willDealloc];
        }
    }
}
- (BOOL)isCustomClass {
    NSBundle *mainB = [NSBundle bundleForClass:[self class]];
    if (mainB == [NSBundle mainBundle]) {
        return YES; //自定义类
    }else {
        return NO; //系统类
    }
}
//即将调用dealloc
- (void)willDealloc {
    __weak typeof(self) weakSelf = self;
    //延时2s，留足释放内存时间
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        //这个的原理就是通过给nil发送方法，如果不为空就执行，为nil不执行
        [strongSelf isNotDealloc];
    });
}
//打印没有释放的view
- (void)isNotDealloc {
    NSLog(@"⚠️⚠️⚠️⚠️⚠️⚠️⚠️%@ is not dealloc⚠️⚠️⚠️⚠️⚠️⚠️⚠️", NSStringFromClass([self class]));
}
@end
#endif
