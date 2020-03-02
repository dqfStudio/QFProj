//
//#import "UINavigationController+HIntercept.h"
//#import <objc/runtime.h>
//
//void HInterceptSwizzleInstanceMethod(Class cls, SEL origSEL, SEL overrideSEL) {
//    if (!cls) return;
//    /* if current class not exist selector, then get super */
//    Method originalMethod = class_getInstanceMethod(cls, origSEL);
//    Method swizzledMethod = class_getInstanceMethod(cls, overrideSEL);
//
//    /* add selector if not exist, implement append with method */
//    if (class_addMethod(cls,
//                        origSEL,
//                        method_getImplementation(swizzledMethod),
//                        method_getTypeEncoding(swizzledMethod)) ) {
//        /* replace class instance method, added if selector not exist */
//        /* for class cluster , it always add new selector here */
//        class_replaceMethod(cls,
//                            overrideSEL,
//                            method_getImplementation(originalMethod),
//                            method_getTypeEncoding(originalMethod));
//
//    }else {
//        /* swizzleMethod maybe belong to super */
//        class_replaceMethod(cls,
//                            overrideSEL,
//                            class_replaceMethod(cls,
//                                                origSEL,
//                                                method_getImplementation(swizzledMethod),
//                                                method_getTypeEncoding(swizzledMethod)),
//                            method_getTypeEncoding(originalMethod));
//    }
//}
//
//@implementation NSObject (HIntercept)
//+ (void)interceptMethodSwizzleWithOrigSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL {
//    HInterceptSwizzleInstanceMethod(self.class, origSEL, overrideSEL);
//}
//@end
//
//
//@implementation UINavigationController (HIntercept)
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [[self class] interceptMethodSwizzleWithOrigSEL:@selector(pushViewController:animated:) overrideSEL:@selector(intercept_pushViewController:animated:)];
//    });
//}
//- (void)intercept_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if ([viewController isKindOfClass:HUIViewController.class]) {
//        if ([viewController isKindOfClass:UIAlertController.class]) return;
//        #pragma clang diagnostic push
//        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        [viewController performSelector:NSSelectorFromString(@"viewDidLoad")];
//        [viewController performSelector:NSSelectorFromString(@"viewWillAppear:")];
//
//        //[viewController performSelector:NSSelectorFromString(@"updateViewConstraints")];
//
//        [viewController performSelector:NSSelectorFromString(@"viewWillLayoutSubviews:")];
//        [viewController performSelector:NSSelectorFromString(@"viewDidLayoutSubviews:")];
//
//        [viewController performSelector:NSSelectorFromString(@"viewDidAppear:")];
//
//        //[viewController performSelector:NSSelectorFromString(@"viewWillDisappear:")];
//        //[viewController performSelector:NSSelectorFromString(@"viewDidDisappear:")];
//        #pragma clang diagnostic pop
//    }else {
//        [self intercept_pushViewController:viewController animated:animated];
//    }
//}
//@end
//
//@implementation UIViewController (HIntercept)
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [[self class] interceptMethodSwizzleWithOrigSEL:@selector(presentViewController:animated:completion:) overrideSEL:@selector(intercept_presentViewController:animated:completion:)];
//    });
//}
//- (void)intercept_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^ __nullable)(void))completion {
//    if ([viewControllerToPresent isKindOfClass:HUIViewController.class]) {
//        if ([viewControllerToPresent isKindOfClass:UIAlertController.class]) return;
//        #pragma clang diagnostic push
//        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        [viewControllerToPresent performSelector:NSSelectorFromString(@"viewDidLoad")];
//        [viewControllerToPresent performSelector:NSSelectorFromString(@"viewWillAppear:")];
//
//        //[viewControllerToPresent performSelector:NSSelectorFromString(@"updateViewConstraints")];
//
//        [viewControllerToPresent performSelector:NSSelectorFromString(@"viewWillLayoutSubviews:")];
//        [viewControllerToPresent performSelector:NSSelectorFromString(@"viewDidLayoutSubviews:")];
//
//        [viewControllerToPresent performSelector:NSSelectorFromString(@"viewDidAppear:")];
//
//        //[viewControllerToPresent performSelector:NSSelectorFromString(@"viewWillDisappear:")];
//        //[viewControllerToPresent performSelector:NSSelectorFromString(@"viewDidDisappear:")];
//        #pragma clang diagnostic pop
//    }else {
//        [self intercept_presentViewController:viewControllerToPresent animated:flag completion:completion];
//    }
//}
//@end
//
//@implementation UIAlertView (HIntercept)
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [[self class] interceptMethodSwizzleWithOrigSEL:@selector(show) overrideSEL:@selector(intercept_show)];
//    });
//}
//- (void)intercept_show { }
//@end
//
//@implementation HUIViewController (HIntercept)
////- (UIView *)view {
////    return nil;
////}
//- (UIView *)view {
//    UIView *view = objc_getAssociatedObject(self, _cmd);
//    if (!view) {
//        self.view = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
//    }
//    return view;
//}
//- (void)setView:(UIView *)view {
//    objc_setAssociatedObject(self, @selector(view), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
////操作过程
//- (void)fdsfdsaf {
//    SEL selector1 = NSSelectorFromString(@"tableView:didSelectRowAtIndexPath:");
//    if ([self respondsToSelector:selector1]) {
//        for (int i=0; i< 5; i++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            #pragma clang diagnostic push
//            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//            [self performSelector:selector1 withObject:nil withObject:indexPath];
//            #pragma clang diagnostic pop
//        }
//    }
//
//    SEL selector2 = NSSelectorFromString(@"collectionView:didSelectItemAtIndexPath:");
//    if ([self respondsToSelector:selector2]) {
//        for (int i=0; i< 5; i++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            #pragma clang diagnostic push
//            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//            [self performSelector:selector2 withObject:nil withObject:indexPath];
//            #pragma clang diagnostic pop
//        }
//    }
//}
//@end
//
////该类为要拦截处理的类
//@implementation HUIViewController
//
//@end
