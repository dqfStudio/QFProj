//
//  HMainController4.m
//  QFProj
//
//  Created by wind on 2019/9/4.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HMainController4.h"

#define KSidebar 80

@interface HMainController4 ()

@end

@implementation HMainController4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.leftNaviButton setHidden:YES];
    [self setTitle:@"第四页"];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 0, KSidebar, screenSize.height)
    contentViewFrame:CGRectMake(KSidebar, 0, screenSize.width - KSidebar, screenSize.height)];
    
    self.tabBar.itemTitleColor = [UIColor colorWithString:@"#535353"];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithString:@"#CFA359"];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:17];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:17];
    
    self.tabBar.leadingSpace = UIDevice.topBarHeight;
    if (screenSize.height == 568) {
        self.tabBar.trailingSpace = screenSize.height-UIDevice.topBarHeight-2*40;
    }else {
        self.tabBar.trailingSpace = screenSize.height-UIDevice.topBarHeight-2*45;
    }
    
    [self.tabBar layoutTabItemsVertical];
    [self.tabBar setItemSeparatorColor:[UIColor redColor] leading:0 trailing:0];
    [self.tabBar setBackgroundColor:[UIColor lightGrayColor]];
    
    self.tabBar.indicatorColor = [UIColor colorWithString:@"#efeff4"];
    
    [self.tabContentView setDelegate:self];
    
    [self initViewControllers];
}

- (void)initViewControllers {
    UIViewController *controller1 = [[UIViewController alloc] init];
    [controller1.view setBackgroundColor:UIColor.greenColor];
    controller1.yp_tabItemTitle = @"第一个";
    
    UIViewController *controller2 = [[UIViewController alloc] init];
    [controller2.view setBackgroundColor:UIColor.redColor];
    controller2.yp_tabItemTitle = @"第二个";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, nil];
}

@end
