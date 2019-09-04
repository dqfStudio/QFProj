//
//  HMenuController.m
//  QFProj
//
//  Created by wind on 2019/9/4.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HMenuController.h"

static const CGFloat kTabBarHeight = 50;

@interface HMenuController ()

@end

@implementation HMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.topBar setHidden:YES];
    
    [self initViewControllers];
    [self setupFrameOfTabBarAndContentView];
}


- (void)setupFrameOfTabBarAndContentView {
    // 设置默认的tabBar的frame和contentViewFrame
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGFloat contentViewY = 0;
    CGFloat tabBarY = screenSize.height - kTabBarHeight;
    tabBarY -= UIDevice.bottomBarHeight;
    
    CGFloat contentViewHeight = tabBarY;
    // 如果parentViewController为UINavigationController及其子类
    if ([self.parentViewController isKindOfClass:[UINavigationController class]] &&
        !self.navigationController.navigationBarHidden &&
        !self.navigationController.navigationBar.hidden) {
        
        CGFloat navMaxY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        if (!self.navigationController.navigationBar.translucent ||
            self.edgesForExtendedLayout == UIRectEdgeNone ||
            self.edgesForExtendedLayout == UIRectEdgeTop) {
            tabBarY = screenSize.height - kTabBarHeight - navMaxY;
            contentViewHeight = tabBarY;
        } else {
            contentViewY = navMaxY;
            contentViewHeight = screenSize.height - kTabBarHeight - contentViewY;
        }
    }
    
    [self setTabBarFrame:CGRectMake(0, tabBarY, screenSize.width, kTabBarHeight)
        contentViewFrame:CGRectMake(0, contentViewY, screenSize.width, contentViewHeight)];
    
    self.tabBar.itemTitleColor = [UIColor colorWithString:@"#535353"];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithString:@"#CFA359"];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:14];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:14];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar addBottomViewWithColor:[UIColor whiteColor]];
    
    //加间隔线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.width, 1)];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [self.tabBar addSubview:lineView];
}

- (void)initViewControllers {
    
    HMainController1 *mainVC1= HMainController1.new;
    mainVC1.yp_tabItemTitle = @"第一页";
    mainVC1.yp_tabItemImage = [UIImage imageNamed:@"di_index"];
    mainVC1.yp_tabItemSelectedImage = [UIImage imageNamed:@"di_index_h"];
    
    
    HMainController2 *mainVC2 = HMainController2.new;
    mainVC2.yp_tabItemTitle = @"第二页";
    mainVC2.yp_tabItemImage = [UIImage imageNamed:@"di_index"];
    mainVC2.yp_tabItemSelectedImage = [UIImage imageNamed:@"di_index_h"];
    
    
    HMainController3 *mainVC3 = HMainController3.new;
    mainVC3.yp_tabItemTitle = @"第三页";
    mainVC3.yp_tabItemImage = [UIImage imageNamed:@"di_index"];
    mainVC3.yp_tabItemSelectedImage = [UIImage imageNamed:@"di_index_h"];
    
    
    HMainController4 *mainVC4 = HMainController4.new;
    mainVC4.yp_tabItemTitle = @"第四页";
    mainVC4.yp_tabItemImage = [UIImage imageNamed:@"di_index"];
    mainVC4.yp_tabItemSelectedImage = [UIImage imageNamed:@"di_index_h"];
    
    self.viewControllers = [NSMutableArray arrayWithObjects:mainVC1, mainVC2, mainVC3, mainVC4, nil];
}

@end
