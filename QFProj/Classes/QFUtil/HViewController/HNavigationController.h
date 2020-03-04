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
- (BOOL)popToViewControllerOfClass:(Class)klass animated:(BOOL)animated;
- (void)replaceTopViewController:(UIViewController *)vc animated:(BOOL)animated;
@end

@interface UIViewController (HJumper)
//viewControllerToPresent可为UIViewController实例或类名
- (void)presentViewController:(id)viewControllerToPresent params:(NSDictionary *_Nullable)params animated:(BOOL)flag completion:(void (^ __nullable)(void))completion;
@end

@interface UINavigationController (HJumper)
//viewController可为UIViewController实例或类名
- (void)pushViewController:(id)viewController params:(NSDictionary *_Nullable)params animated:(BOOL)animated;
@end

@interface UIViewController (HBackHandler) <HBackHandlerProtocol>

@end


NS_ASSUME_NONNULL_END
