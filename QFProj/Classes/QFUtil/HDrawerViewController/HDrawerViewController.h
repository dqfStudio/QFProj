//
//  HDrawerViewController.h
//  HSideViewController
//
//  Created by liang on 2018/3/22.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HDrawerViewControllerDelegate <NSObject>
@optional
- (void)menuDidAppear;
- (void)menuDidDisappear;
@end

@interface HDrawerViewController : HViewController <NSObject>

- (instancetype)initWithMainViewController:(UIViewController *)mainViewController
                        menuViewController:(UIViewController *)menuViewController;

@property (nonatomic, assign) CGFloat visibleMenuWidth; ///< Default is 300.f.
@property (nonatomic, assign) BOOL canDragMenu; ///< Default is YES.

@property (nonatomic, strong) UIViewController *mainViewController;
@property (nonatomic, strong) UIViewController *menuViewController;

- (void)presentMenuViewController; ///< Show menu page.
- (void)dismissMenuViewController; ///< Hide menu page.

- (void)bind:(id<HDrawerViewControllerDelegate>)delegate;
- (void)unbind:(id<HDrawerViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
