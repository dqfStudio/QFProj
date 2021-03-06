//
//  HTabBarController.m
//  QFProj
//
//  Created by dqf on 2018/9/17.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HTabBarController.h"

@interface HTabBarController ()

@end

@implementation HTabBarController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    _tabContentView = [[YPTabContentView alloc] init];
    _tabContentView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tabContentView];
    [self.view addSubview:self.tabBar];
}

- (void)setTabBarFrame:(CGRect)tabBarFrame contentViewFrame:(CGRect)contentViewFrame {
    if (self.tabContentView.headerView) {
        return;
    }
    self.tabBar.frame = tabBarFrame;
    self.tabContentView.frame = contentViewFrame;
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers {
    self.tabContentView.viewControllers = viewControllers;
}

- (NSArray<UIViewController *> *)viewControllers {
    return self.tabContentView.viewControllers;
}

- (YPTabBar *)tabBar {
    return self.tabContentView.tabBar;
}

#pragma mark - rotate

- (BOOL)shouldAutorotate {
    UIViewController *controller = self.tabContentView.selectedController;
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)controller;
        return navi.topViewController.shouldAutorotate;
    }else {
        return controller.shouldAutorotate;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *controller = self.tabContentView.selectedController;
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)controller;
        return navi.topViewController.supportedInterfaceOrientations;
    }else {
        return controller.supportedInterfaceOrientations;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    UIViewController *controller = self.tabContentView.selectedController;
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)controller;
        return navi.topViewController.preferredInterfaceOrientationForPresentation;
    }else {
        return controller.preferredInterfaceOrientationForPresentation;
    }
}

@end
