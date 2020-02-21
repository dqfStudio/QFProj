//
//  UINavigationController+HUtil.h
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (HUtil)
- (BOOL)popToViewControllerOfClass:(Class)klass animated:(BOOL)animated;
- (void)replaceTopViewController:(UIViewController *)vc animated:(BOOL)animated;
@end
