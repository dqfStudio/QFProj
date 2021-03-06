//
//  UIViewController+YPTab.h
//  YPTabBarController
//
//  Created by 喻平 on 2017/9/19.
//  Copyright © 2017年 YPTabBarController. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPTabItem;
@class YPTabBarController;

@interface UIViewController (YPTab)

@property (nonatomic, strong, readonly) YPTabItem *yp_tabItem;
@property (nonatomic, strong, readonly) YPTabBarController *yp_tabBarController;

@property (nonatomic, copy) NSString *yp_tabItemTitle; // tabItem的标题
@property (nonatomic, strong) UIImage *yp_tabItemImage; // tabItem的图像
@property (nonatomic, strong) UIImage *yp_tabItemSelectedImage; // tabItem的选中图像

/**
 *  ViewController对应的Tab被Select后，执行此方法，此方法为回调方法
 *
 *  @param isFirstTime  是否为第一次被选中
 */
- (void)yp_tabItemDidSelected:(BOOL)isFirstTime;

/**
 *  ViewController对应的Tab被Deselect后，执行此方法，此方法为回调方法
 */
- (void)yp_tabItemDidDeselected;

/**
 *  返回用于显示的View，默认是self.view
 *  当设置headerView的时候，需要把scrollView或者tableView返回
 */
- (UIView *)yp_displayView;

/**
 *  返回是否开启最小ContentHeight
 */
- (BOOL)yp_disableMinContentHeight;

/**
 *  废弃，用yp_tabItemDidSelected:替换
 */
- (void)tabItemDidSelected __deprecated_msg("废弃，用yp_tabItemDidSelected:替换");

/**
 *  废弃，用yp_tabItemDidDeselected替换
 */
- (void)tabItemDidDeselected __deprecated_msg("废弃，用yp_tabItemDidDeselected替换");

@end
