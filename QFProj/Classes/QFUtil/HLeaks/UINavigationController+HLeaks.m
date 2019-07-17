//
//  UINavigationController+HLeaks.m
//  QFProj
//
//  Created by wind on 2019/7/16.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "UINavigationController+HLeaks.h"
#import "NSObject+HSwizzleUtil.h"
#import <objc/message.h>

#if DEBUG
extern const char* leaksKey;

@implementation UINavigationController (HLeaks)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodSwizzleWithOrigSEL:@selector(popViewControllerAnimated:) overrideSEL:@selector(leaks_popViewControllerAnimated:)];
    });
}
- (UIViewController *)leaks_popViewControllerAnimated:(BOOL)animated {
    UIViewController *popVC = [self leaks_popViewControllerAnimated:animated];
    if (popVC) objc_setAssociatedObject(popVC, &leaksKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return popVC;
}
@end
#endif
