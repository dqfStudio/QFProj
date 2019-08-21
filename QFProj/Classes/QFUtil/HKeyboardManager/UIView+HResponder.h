//
//  UIView+HResponder.h
//  HResponseChain
//
//  Created by GuangquanYu on 10/4/18.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HResponder)

@property(nonatomic, copy) NSString *hTagString;

- (BOOL)h_isCanBecomeFirstResponder;

- (NSArray*)h_responderSiblings;

- (NSArray*)h_responderChildViews;


- (UIViewController*)hh_viewController;

- (UIViewController *)h_topMostController;

- (NSMutableArray*)h_findSonViewByClass:(Class)type mutableArray:(NSMutableArray *)sonViews isMember:(BOOL)isMember;


- (UIView *)h_findFatherViewByClass:(Class)type isMember:(BOOL)isMember;

- (NSMutableArray*)h_findFatherViewByClass:(Class)type mutableArray:(NSMutableArray *)fatherViews isMember:(BOOL)isMember;

- (NSInteger)h_depth;

@end

@interface UIWindow (HResponder2)
+ (UIWindow *)h_getWindow;

+ (UIViewController *)h_getWindowRootVC;

+ (UIViewController *)h_getRootViewController;

+ (UIViewController*)h_topMostControllerForStack;

+ (UINavigationController *)h_topMostNavigationController;

+ (UIViewController*)h_currentNavigationViewController;

+ (UIViewController*)h_currentViewController;

@end
