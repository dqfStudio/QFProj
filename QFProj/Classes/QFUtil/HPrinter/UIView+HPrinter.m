//
//  UIView+HPrinter.m
//  QFProj
//
//  Created by dqf on 2018/8/7.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "UIView+HPrinter.h"
#import <objc/runtime.h>

@implementation UIView (HPrinter)

#if DEBUG
+ (void)load {
    if (self == UIView.class) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self replaceClass:[self class] originalSelector:@selector(addSubview:) withCustomSelector:@selector(custom_addSubview:)];
        });
    }
}

+ (void)replaceClass:(Class)class originalSelector:(SEL)originalSelector withCustomSelector:(SEL)customSelector {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, customSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            customSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

- (void)custom_addSubview:(UIView *)view {
    [self custom_addSubview:view];
    [[HPrinterManager share] setView:view];
}
#endif

@end
