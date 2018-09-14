//
//  HTabBarController.m
//  QFProj
//
//  Created by dqf on 2018/8/29.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTabBarController.h"
#import "ViewController.h"
#import "HLoginController.h"
#import "GViewController.h"

@interface HTabBarController ()

@end

@implementation HTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat bottom = [self.parentViewController isKindOfClass:[UINavigationController class]] ? 0 : 50;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (screenSize.height == 812) {
        [self setTabBarFrame:CGRectMake(0, 44, screenSize.width, 44)
            contentViewFrame:CGRectMake(0, 88, screenSize.width, screenSize.height - 88 - bottom - 34)];
    } else {
        [self setTabBarFrame:CGRectMake(0, 20, screenSize.width, 44)
            contentViewFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64 - bottom )];
    }
    
    
    self.tabBar.itemTitleColor = [UIColor lightGrayColor];
    self.tabBar.itemTitleSelectedColor = [UIColor redColor];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:17];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:22];
    self.tabBar.leadingSpace = 20;
    self.tabBar.trailingSpace = 20;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.indicatorScrollFollowContent = YES;
    self.tabBar.indicatorColor = [UIColor redColor];
    
    [self.tabBar setIndicatorWidth:40 marginTop:40 marginBottom:0 tapSwitchAnimated:NO];
    
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:40];
    
    
    [self.tabContentView setContentScrollEnabled:YES tapSwitchAnimated:NO];
    self.tabContentView.loadViewOfChildContollerWhileAppear = YES;
    
    [self initViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initViewControllers {
//    HLoginController *controller1 = [[HLoginController alloc] init];
//    controller1.yp_tabItemTitle = @"title1";
    
    GViewController *controller2 = [[GViewController alloc] init];
    controller2.yp_tabItemTitle = @"title2";
    
//    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, nil];
    self.viewControllers = [NSMutableArray arrayWithObjects:controller2, nil];
}

@end
