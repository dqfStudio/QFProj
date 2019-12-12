//
//  HMainController5.m
//  QFProj
//
//  Created by dqf on 2019/9/26.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HMainController5.h"

static const CGFloat kTabBarHeight = 50;

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
    [self setTitle:@"table展示"];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;

    [self setTabBarFrame:CGRectMake(0, UIDevice.topBarHeight, screenSize.width, kTabBarHeight)
        contentViewFrame:CGRectMake(0, kTabBarHeight, screenSize.width, screenSize.height - kTabBarHeight)];

    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = [UIColor redColor];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:16];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:17];

    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.indicatorScrollFollowContent = YES;
    self.tabBar.indicatorColor = [UIColor redColor];

    [self.tabBar setBackgroundColor:[UIColor grayColor]];
    [self.tabBar setIndicatorWidth:screenSize.width/3 marginTop:kTabBarHeight-3 marginBottom:0 tapSwitchAnimated:NO];
    [self.tabBar setScrollEnabledAndItemWidth:screenSize.width/3];

    [self.tabBar addBottomLineViewWithColor:[UIColor blackColor]];

    [self.tabContentView setBackgroundColor:[UIColor grayColor]];
    [self.tabContentView setContentScrollEnabled:YES tapSwitchAnimated:NO];
    self.tabContentView.loadViewOfChildContollerWhileAppear = YES;

    [self initViewControllers];
}

- (void)initViewControllers {
    
    HMainController6 *controller1 = [[HMainController6 alloc] init];
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
