//
//  HTabBarController.h
//  QFProj
//
//  Created by dqf on 2018/9/17.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HViewController.h"
#import "YPTabBar.h"
#import "YPTabContentView.h"
#import "YPTabBar+HSubView.h"

@interface HTabBarController : HViewController <YPTabContentViewDelegate>

@property (nonatomic, strong, readonly) YPTabBar *tabBar;

@property (nonatomic, strong, readonly) YPTabContentView *tabContentView;

@property (nonatomic, copy) NSArray <UIViewController *> *viewControllers;

/**
 *  设置tabBar和contentView的frame，
 *  默认是tabBar在底部，contentView填充其余空间
 *  如果设置了headerView，此方法不生效
 */
- (void)setTabBarFrame:(CGRect)tabBarFrame contentViewFrame:(CGRect)contentViewFrame;

@end
