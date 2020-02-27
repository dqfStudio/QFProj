//
//  HViewController.h
//  TestProject
//
//  Created by dqf on 2018/4/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIView+HUtil.h"
#import "HWebButtonView.h"
#import "NSObject+HUtil.h"
#import "UIColor+HUtil.h"
#import "UIDevice+HUtil.h"
#import "UIApplication+HUtil.h"
#import "NSObject+HSwizzleUtil.h"
#import "HNavigationController.h"

typedef NS_OPTIONS(NSUInteger, HVCDisappearType) {
    HVCDisappearTypeOther = 0,
    HVCDisappearTypePush,
    HVCDisappearTypePop,
    HVCDisappearTypeDismiss
};

@interface HVCAppearance : NSObject
@property (nonatomic) UIColor *barColor;
@property (nonatomic) UIColor *bgColor;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) UIColor *lightTextColor;
@end

@interface HViewController : UIViewController

@property (nonatomic) UIView *topBar;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) HWebButtonView *leftNaviButton;
@property (nonatomic) HWebButtonView *rightNaviButton;
@property (nonatomic) UIView *topBarLine;

- (CGFloat)topBarHeight;

+ (HVCAppearance *)appearance;

//设置按钮的正常态和点击态,如果要设置正常态和点击态不一样,直接访问leftNaviButton和rightNaviButton设置
- (void)setLeftNaviImage:(UIImage *)image;
- (void)setLeftNaviImageURL:(NSString *)imageURL;
- (void)setRightNaviImage:(UIImage *)image;
- (void)setRightNaviImageURL:(NSString *)imageURL;
/**
 *  设置导航栏左按钮图标
 *
 *  @param normal    普通状态图标
 *  @param highlight 高亮状态图标
 */
- (void)setNaviLeftImage:(UIImage *)normal highlight:(UIImage *)highlight;

/**
 *  设置导航栏右按钮图标
 *
 *  @param normal    普通状态图标
 *  @param highlight 高亮状态图标
 */
- (void)setNaviRightImage:(UIImage *)normal highlight:(UIImage *)highlight;

//设置导航栏按钮文字
- (void)setLeftNaviTitle:(NSString *)title;
- (void)setLeftNaviTitle:(NSString *)title titleColor:(UIColor *)color highlightColor:(UIColor *)highlightcolor;
- (void)setRightNaviTitle:(NSString *)title;
- (void)setRightNaviTitle:(NSString *)title titleColor:(UIColor *)color highlightColor:(UIColor *)highlightcolor;

#pragma 导航按钮事件处理
/**
 *  退出当前页面
 */
- (void)back;

/**
 *  导航左按钮点击,默认是调用back
 *
 *  leftButton 导航左按钮
 */
- (void)leftNaviButtonPressed;

/**
 *  导航右按钮点击,需自己重写
 *
 *  rightButton 右按钮
 */
- (void)rightNaviButtonPressed;

#pragma mark - 状态栏样式订制
//统一iOS6及以上系统控制状态栏隐藏的方式，匀采用代理方式
//控制器想要实现状态栏控制及动画，需要实现以下两个方法，当状态栏状态改性时需要调用-setNeedsStatusBarAppearanceUpdate
//以刷新状态栏状态, 默认实现是显示状态栏和没有动画
- (BOOL)prefersStatusBarHidden;
//是否动态调整status bar 的样式
- (BOOL)autoAdjustStatusBarStyle;
- (UIColor *)preferredStatusBarColor;

#pragma mark - 导航栏控制
//每次改变导航栏状态时，需要调用该方法才能刷新状态栏状态
- (void)setNeedsNavigationBarAppearanceUpdate;
//统一iOS6及以上系统控制导航栏的方式，匀采用代理方式
//控制器想要实现导航栏的隐藏与否，需要实现以下两个方法，当状态栏状态改性时需要调用-setNeedsNavigationBarAppearanceUpdate
//以刷新导航栏状态, 默认实现是显示导航栏和没有动画
- (BOOL)prefersTopBarLineHidden;
- (BOOL)prefersNavigationBarHidden;
- (UIColor *)preferredNaviBarColor;

#pragma mark - 请求控制
//- (void)controlRequest:(HNetworkDAO *)request;

#pragma mark - 内存控制
//需要释放内存
- (void)needReleaseMemory;

#pragma mark - 左滑返回
- (BOOL)popGestureEnabled;
@end

@interface UIViewController (HChildControllerNavigation)
- (void)transitionChildViewControllerWithIndex:(NSUInteger)index;
- (void)pushChildViewController:(UIViewController *)viewController;
- (void)popChildViewController;
@end

@interface UIViewController (HDisappear)
/**
 *  vc消失的类型,需自己重写
 *
 *  type 类型枚举
 */
- (void)vcWillDisappear:(HVCDisappearType)type;
@end

@interface UIViewController (HKeyboard)

/**
 *  将UIViewController的类名作为NibName，使用initWithNibName方法，返回UIViewController对象
 */
+ (instancetype)viewControllerFromNib;

/**
 *  键盘通知
 */
- (void)addKeyboardObserver;
- (void)removeKeyboardObserver;

/**
 *  键盘通知回调事件，主要用于子类重写
 *
 *  @param keyboardRect 键盘rect
 *  @param duration     键盘弹出动画的时间
 */
- (void)keyboardWillShowWithRect:(CGRect)keyboardRect animationDuration:(CGFloat)duration;
- (void)keyboardWillHideWithRect:(CGRect)keyboardRect animationDuration:(CGFloat)duration;

/**
 *  点击背景self.view的时候，关闭键盘
 */
- (void)hideKeyboardWhenTapBackground;

/**
 *  判断当前ViewController是否在顶部显示
 */
- (BOOL)isViewInBackground;

@end

@interface HViewController (HMessy)
//获取window & screen
- (UIWindow *)window;
- (UIScreen *)screen;
//load date
@property (nonatomic) NSMutableArray *sourceArr;
@property (nonatomic) NSMutableDictionary *sourceDict;
@end
