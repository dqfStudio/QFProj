//
//  UIViewController+HLeaks.m
//  QFProj
//
//  Created by wind on 2019/7/16.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "UIViewController+HLeaks.h"
#import "NSObject+HSwizzleUtil.h"
#import <objc/message.h>

#if DEBUG
const char* leaksKey;

@implementation UIViewController (HLeaks)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodSwizzleWithOrigSEL:@selector(viewWillAppear:) overrideSEL:@selector(leaks_viewWillAppear:)];
        [[self class] methodSwizzleWithOrigSEL:@selector(viewWillDisappear:) overrideSEL:@selector(leaks_viewWillDisappear:)];
        [[self class] methodSwizzleWithOrigSEL:@selector(dismissViewControllerAnimated:completion:) overrideSEL:@selector(leaks_dismissViewControllerAnimated:completion:)];
    });
}
- (void)leaks_viewWillAppear:(BOOL)animated {
    [self leaks_viewWillAppear:animated];
    objc_setAssociatedObject(self, &leaksKey, @(NO), OBJC_ASSOCIATION_ASSIGN);
}
- (void)leaks_viewWillDisappear:(BOOL)animated {
    [self leaks_viewWillDisappear:animated];
    if ([objc_getAssociatedObject(self, &leaksKey) boolValue]) {
        [self willDealloc];
    }
}
- (void)leaks_dismissViewControllerAnimated:(BOOL)flag completion:(void (^ __nullable)(void))completion {
    [self leaks_dismissViewControllerAnimated:flag completion:completion];
    [self willDealloc];
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
//打印没有释放的vc
- (void)isNotDealloc {
    printf("\nHPrinting-->⚠️⚠️⚠️⚠️⚠️⚠️⚠️%s is not dealloc⚠️⚠️⚠️⚠️⚠️⚠️⚠️", NSStringFromClass([self class]).UTF8String);
}
@end
#endif
