//
//  HMainController5.m
//  QFProj
//
//  Created by wind on 2019/9/26.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HMainController5.h"

@interface HMainController5 ()

@end

@implementation HMainController5

//- (void)back {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"中间"];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [self setTabBarFrame:CGRectMake(0, UIDevice.topBarHeight, screenSize.width, 50)
        contentViewFrame:CGRectMake(0, 50, screenSize.width, screenSize.height - 50)];
    
    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = [UIColor redColor];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:16];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:17];
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.indicatorScrollFollowContent = YES;
    self.tabBar.indicatorColor = [UIColor redColor];
    
    [self.tabBar setBackgroundColor:[UIColor grayColor]];
    [self.tabBar setIndicatorWidth:screenSize.width/3 marginTop:50-3 marginBottom:0 tapSwitchAnimated:NO];
    [self.tabBar setScrollEnabledAndItemWidth:screenSize.width/3];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, UIDevice.topBarHeight + 50, screenSize.width, 1)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:line];
    
    [self.tabContentView setBackgroundColor:[UIColor grayColor]];
    [self.tabContentView setContentScrollEnabled:YES tapSwitchAnimated:NO];
    self.tabContentView.loadViewOfChildContollerWhileAppear = YES;
    
    [self initViewControllers];
}

- (void)initViewControllers {
    
    UIViewController *controller1 = [[UIViewController alloc] init];
    [controller1.view setBackgroundColor:UIColor.redColor];
    controller1.yp_tabItemTitle = @"第一个";
    
    UIViewController *controller2 = [[UIViewController alloc] init];
    [controller2.view setBackgroundColor:UIColor.greenColor];
    controller2.yp_tabItemTitle = @"第二个";
    
    UIViewController *controller3 = [[UIViewController alloc] init];
    [controller3.view setBackgroundColor:UIColor.blueColor];
    controller3.yp_tabItemTitle = @"第三个";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, nil];
}

@end
