//
//  HVCDisappear.m
//  HProjectModel1
//
//  Created by dqf on 2019/7/17.
//  Copyright © 2019 dqf. All rights reserved.
//

#import "UIViewController+HDisappear.h"

@implementation UIViewController (HDisappear)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodSwizzleWithOrigSEL:@selector(dismissViewControllerAnimated:completion:) overrideSEL:@selector(disappear_dismissViewControllerAnimated:completion:)];
    });
}
- (void)disappear_dismissViewControllerAnimated:(BOOL)flag completion:(void (^ __nullable)(void))completion {
    [self disappear_dismissViewControllerAnimated:flag completion:completion];
    if (self.navigationController.viewControllers.count > 0) {
        NSArray *viewControllers = self.navigationController.viewControllers;
        for (long i=viewControllers.count-1; i>=0; i--) {
            UIViewController *vc = viewControllers[i];
            [vc vcWillDisappear:HVCDisappearTypeDismiss];
        }
    }else {
        [self vcWillDisappear:HVCDisappearTypeDismiss];
    }
}
- (void)vcWillDisappear:(HVCDisappearType)type {}
@end


@implementation UINavigationController (HDisappear)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodSwizzleWithOrigSEL:@selector(popViewControllerAnimated:) overrideSEL:@selector(disappear_popViewControllerAnimated:)];
        [[self class] methodSwizzleWithOrigSEL:@selector(pushViewController:animated:) overrideSEL:@selector(disappear_pushViewController:animated:)];
    });
}
- (UIViewController *)disappear_popViewControllerAnimated:(BOOL)animated {
    UIViewController *popVC = [self disappear_popViewControllerAnimated:animated];
    if ([popVC isKindOfClass:UIViewController.class]) [popVC vcWillDisappear:HVCDisappearTypePop];
    return popVC;
}
- (void)disappear_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self.topViewController isKindOfClass:UIViewController.class]) {
        [self.topViewController vcWillDisappear:HVCDisappearTypePush];
    }
    [self disappear_pushViewController:viewController animated:animated];
}
@end
