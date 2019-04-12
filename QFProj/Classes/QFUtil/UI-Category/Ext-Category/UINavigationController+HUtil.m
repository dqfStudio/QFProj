//
//  UINavigationController+HUtil.m
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 hisun. All rights reserved.
//

#import "UINavigationController+HUtil.h"

@implementation UINavigationController (HUtil)
- (BOOL)popToViewControllerOfClass:(Class)klass animated:(BOOL)animated {
    BOOL success = NO;
    if (klass != NULL) {
        for (UIViewController *vc in self.viewControllers) {
            if ([vc isKindOfClass:klass]) {
                success = YES;
                [self popToViewController:vc animated:animated];
                break;
            }
        }
    }
    return success;
}
- (void)replaceTopViewController:(UIViewController *)vc animated:(BOOL)animated {
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.viewControllers];
    if (vcs.count > 0) {
        [vcs removeLastObject];
        [vcs addObject:vc];
    }
    [self setViewControllers:vcs animated:animated];
}
@end
