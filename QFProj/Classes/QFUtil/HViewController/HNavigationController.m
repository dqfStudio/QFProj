//
//  HNavigationController.m
//  QFProj
//
//  Created by dqf on 2018/9/20.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HNavigationController.h"
#import <objc/runtime.h>

@interface HNavigationController () <UIGestureRecognizerDelegate>
@property(nonatomic, strong) NSMutableArray *blackList;
@end

@implementation HNavigationController

#pragma mark - Lazy load
- (NSMutableArray *)blackList {
    if (!_blackList) {
        _blackList = [NSMutableArray array];
    }
    return _blackList;
}

#pragma mark - Public
- (void)addFullScreenPopBlackListItem:(UIViewController *)viewController {
    if (!viewController) {
        return;
    }
    [self.blackList addObject:viewController];
}

- (void)removeFromFullScreenPopBlackList:(UIViewController *)viewController {
    for (UIViewController *vc in self.blackList) {
        if (vc == viewController) {
            [self.blackList removeObject:vc];
        }
    }
}

- (BOOL)popToViewControllerOfClass:(Class)klass animated:(BOOL)animated {
    BOOL success = NO;
    if (klass != NULL) {
        for (UIViewController *vc in self.viewControllers) {
            if ([vc isKindOfClass:klass]) {
                success = YES;
                [self popToViewController:vc animated:animated];
                break;
            }
        }
    }
    return success;
}

- (void)replaceTopViewController:(UIViewController *)vc animated:(BOOL)animated {
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.viewControllers];
    if (vcs.count > 0) {
        [vcs removeLastObject];
        [vcs addObject:vc];
    }
    [self setViewControllers:vcs animated:animated];
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //  这句很核心
    id target = self.interactivePopGestureRecognizer.delegate;
    //  这句很核心
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    //  获取添加系统边缘触发手势的View
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    
    //  创建pan手势 作用范围是全屏
    UIPanGestureRecognizer *fullScreenGes = [[UIPanGestureRecognizer alloc] initWithTarget:target action:handler];
    fullScreenGes.delegate = self;
    [targetView addGestureRecognizer:fullScreenGes];
    
    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
    
    //modalPresentationStyle 设置默认样式为 UIModalPresentationFullScreen
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    //关闭暗黑模式
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
#endif
}

#pragma mark - UIGestureRecognizerDelegate
//  防止导航控制器只有一个rootViewcontroller时触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    // 根据具体控制器对象决定是否开启全屏右滑返回
    for (UIViewController *viewController in self.blackList) {
        if ([self topViewController] == viewController) {
            return NO;
        }
    }
    
    //如果这个push  pop 动画正在执行(私有属性)，不允许手势
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // 解决右滑和UITableView左滑删除的冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    //当前控制器为根控制器，不允许手势
    return self.childViewControllers.count == 1 ? NO : YES;
}

#pragma mark - rotate

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

@end

@implementation UIViewController (HJumper)
- (nullable id)valueForUndefinedKey:(NSString *)key {
    return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    //NSLog(@"-------> forUndefinedKey:%@  value:%@",key,value);
}
- (void)presentViewController:(id)viewControllerToPresent params:(NSDictionary *)params animated:(BOOL)flag completion:(void (^ __nullable)(void))completion {
    /*
    if (params) [viewControllerToPresent autoFill:params map:nil exclusive:NO isDepSearch:YES];
    [self presentViewController:viewControllerToPresent animated:flag completion:completion];
    */
    if ([viewControllerToPresent isKindOfClass:UIViewController.class]) {
        UIViewController *vc = viewControllerToPresent;
        //对该对象赋值属性
        if (params) {
            [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [vc setValue:obj forKey:key];//利用KVC赋值
            }];
        }
        [self presentViewController:vc animated:flag completion:completion];
    }else if ([viewControllerToPresent isKindOfClass:NSString.class]) {
        NSString *controllerName = viewControllerToPresent;
        if (controllerName == nil || controllerName.length == 0) return;
        Class newClass = NSClassFromString(controllerName);
        //创建对象
        id instance = [[newClass alloc] init];
        if ([instance isKindOfClass:UIViewController.class]) {
            //对该对象赋值属性
            if (params) {
                [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    [instance setValue:obj forKey:key];//利用KVC赋值
                }];
            }
            [self presentViewController:instance animated:flag completion:completion];
        }
    }
}
@end

@implementation UINavigationController (HJumper)
- (void)pushViewController:(id)viewController params:(NSDictionary *)params animated:(BOOL)animated {
    /*
    if (params) [viewController autoFill:params map:nil exclusive:NO isDepSearch:YES];
    [self pushViewController:viewController animated:animated];
    */
    if ([viewController isKindOfClass:UIViewController.class]) {
        UIViewController *vc = viewController;
        //对该对象赋值属性
        if (params) {
            [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [vc setValue:obj forKey:key];//利用KVC赋值
            }];
        }
        //避免多个PUSH
        id controller = [self.viewControllers lastObject];
        if (![controller isKindOfClass:vc.class]) {
            [self pushViewController:vc animated:animated];
        }
    }else if ([viewController isKindOfClass:NSString.class]) {
        NSString *controllerName = viewController;
        if (controllerName == nil || controllerName.length == 0) return;
        Class newClass = NSClassFromString(controllerName);
        //创建对象
        id instance = [[newClass alloc] init];
        if ([instance isKindOfClass:UIViewController.class]) {
            //对该对象赋值属性
            if (params) {
                [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    [instance setValue:obj forKey:key];//利用KVC赋值
                }];
            }
            //避免多个PUSH
            id controller = [self.viewControllers lastObject];
            if (![controller isKindOfClass:newClass]) {
                [self pushViewController:instance animated:animated];
            }
        }
    }
}

@end

@implementation UIViewController (HBackHandler)

@end

@implementation UINavigationController (HBackHandler)
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if([self.viewControllers count] < [navigationBar.items count]) return YES;
    BOOL shouldPop = YES;
    UIViewController *vc = [self topViewController];
    if ([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    if (shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    }else {
        for(UIView *subview in [navigationBar subviews]) {
            if (subview.alpha < 1.f) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.f;
                }];
            }
        }
    }
    return NO;
}
@end
