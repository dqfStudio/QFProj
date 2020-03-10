//
//  HNavigationController.h
//  QFProj
//
//  Created by dqf on 2018/9/20.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+HAutoFill.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HBackHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
- (BOOL)navigationShouldPopOnBackButton;
@end

@interface HNavigationController : UINavigationController
- (void)addFullScreenPopBlackListItem:(UIViewController *)viewController;
- (void)removeFromFullScreenPopBlackList:(UIViewController *)viewController;
@end

@interface UIViewController (HJumper)
//viewControllerToPresent可为UIViewController实例或类名
- (void)presentAlertController:(id)viewControllerToPresent animated:(BOOL)flag completion:(void (^ __nullable)(void))completion;
- (void)presentAlertController:(id)viewControllerToPresent params:(NSDictionary *_Nullable)params animated:(BOOL)flag completion:(void (^ __nullable)(void))completion;
- (void)presentViewController:(id)viewControllerToPresent params:(NSDictionary *_Nullable)params animated:(BOOL)flag completion:(void (^ __nullable)(void))completion;
@end

@interface UINavigationController (HJumper)
//viewController可为UIViewController实例或类名
- (void)pushViewController:(id)viewController params:(NSDictionary *_Nullable)params animated:(BOOL)animated;
//viewController可为UIViewController实例或类名
- (void)popToViewController:(id)viewController params:(NSDictionary *_Nullable)params animated:(BOOL)animated;
- (BOOL)popToViewControllerOfClass:(Class)cls animated:(BOOL)animated;
- (void)replaceTopViewController:(UIViewController *)vc animated:(BOOL)animated;
- (id)getViewController:(NSString *)controllerName;
- (void)resetViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;
- (void)resetViewControllers:(NSArray *)viewControllers;//animated default is NO.
@end

@interface UIViewController (HBackHandler) <HBackHandlerProtocol>

@end


NS_ASSUME_NONNULL_END
