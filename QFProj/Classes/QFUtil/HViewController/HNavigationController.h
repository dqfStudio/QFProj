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

@interface HNavigationController : UINavigationController
- (void)addFullScreenPopBlackListItem:(UIViewController *)viewController;
- (void)removeFromFullScreenPopBlackList:(UIViewController *)viewController;
- (BOOL)popToViewControllerOfClass:(Class)klass animated:(BOOL)animated;
- (void)replaceTopViewController:(UIViewController *)vc animated:(BOOL)animated;
@end

@interface UIViewController (HJumper)
- (void)presentViewController:(UIViewController *)viewControllerToPresent param:(NSDictionary *_Nullable)dict animated:(BOOL)flag completion:(void (^ __nullable)(void))completion;
@end

@interface UINavigationController (HJumper)
- (void)pushViewController:(UIViewController *)viewController param:(NSDictionary *_Nullable)dict animated:(BOOL)animated;
@end


NS_ASSUME_NONNULL_END
