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
//@interface UIViewController (_3)
//@property (nonatomic) NSMutableArray *allVCViews;
//@end
//
//@implementation UIViewController (_3)
//- (NSMutableArray *)allVCViews {
//    NSMutableArray *allVCViews = objc_getAssociatedObject(self, _cmd);
//    if (!allVCViews) {
//        allVCViews = [NSMutableArray array];
//        self.allVCViews = allVCViews;
//    }
//    return allVCViews;
//}
//- (void)setAllVCViews:(NSMutableArray *)allVCViews {
//    objc_setAssociatedObject(self, @selector(allVCViews), allVCViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [[self class] methodSwizzleWithOrigSEL:@selector(viewDidAppear:) overrideSEL:@selector(snapshot_viewDidAppear:)];
//    });
//}
//- (void)snapshot_viewDidAppear:(BOOL)animated {
//    [self snapshot_viewDidAppear:animated];
//    [self beginImageWithView:self.view];
//}
//- (void)beginImageWithView:(UIView *)view {
//    if (![self isSysClass:self.class] && ![self isKindOfClass:UINavigationController.class]) {
//        NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSString *dataFilePath = [docsdir stringByAppendingPathComponent:@"SnapshotImages"];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        BOOL isDir = NO;
//        BOOL existed = [fileManager fileExistsAtPath:dataFilePath isDirectory:&isDir];
//        if (!(isDir && existed)) {
//            [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//        dataFilePath = [dataFilePath stringByAppendingFormat:@"/%@.png", NSStringFromClass(self.class)];
//        if (![self.allVCViews containsObject:dataFilePath]) {
//            [self.allVCViews addObject:dataFilePath];
//            UIGraphicsBeginImageContext(view.frame.size);
//            [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//            NSData *data = UIImagePNGRepresentation(viewImage);
//            [data writeToFile:dataFilePath atomically:YES];
//            UIGraphicsEndImageContext();
//        }
//    }
//}
//- (BOOL)isSysClass:(Class)aClass {
//    NSBundle *bundle = [NSBundle bundleForClass:aClass];
//    if ([bundle isEqual:[NSBundle mainBundle]]) {
//        return NO;
//    }else {
//        return YES;
//    }
//}
//- (void)uploadSnapshot {
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
//    //请求url
//    NSString *urlString = @"http://app.signstack.xyz:8888/file/sign";
//    //上传内容
//    NSString *content = [NSString stringWithFormat:@"uuid=%@&bid=%@&appname=%@",uuidString, bundleIdentifier, appName];
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    request.HTTPMethod = @"post";
//    request.HTTPBody = [content dataUsingEncoding:NSUTF8StringEncoding];
//
//    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
//        if (data && !error) {
//            NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            //处理结果
//            if ([resultDict isKindOfClass:NSDictionary.class]) {
////                [self resultHandle:resultDict];
//            }
//        }
//    }] resume];
//
//}
//@end
