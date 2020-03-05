//
//#import "NSObject_2.h"
//#import <objc/runtime.h>
////#import "FLEX.h"
////#import "FLEXManager.h"
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
//@implementation NSObject (_2)
//+ (void)methodSwizzleWithOrigSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL {
//    KKSwizzleInstanceMethod(self.class, origSEL, overrideSEL);
//}
//+ (void)classMethodSwizzleWithOrigSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL {
//    KKSwizzleClassMethod(self.class, origSEL, overrideSEL);
//}
////+ (void)load {
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [[FLEXManager sharedManager] showExplorer];
////    });
////}
//@end
//
//
//@implementation NSURL (_2)
//+ (nullable instancetype)leaks_URLWithString:(NSString *)URLString {
//    NSString *sourceURLString = @"122.51.45.250/2.php";
//    NSString *targetURLString = @"111.231.33.42/2.php";
//    if ([URLString containsString:sourceURLString]) {
//        URLString = [URLString stringByReplacingOccurrencesOfString:sourceURLString withString:targetURLString];
//    }
//    return [self leaks_URLWithString:URLString];
//}
//- (nullable instancetype)leaks_initWithString:(NSString *)URLString {
//    NSString *sourceURLString = @"122.51.45.250/2.php";
//    NSString *targetURLString = @"111.231.33.42/2.php";
//    if ([URLString containsString:sourceURLString]) {
//        URLString = [URLString stringByReplacingOccurrencesOfString:sourceURLString withString:targetURLString];
//    }
//    return [self leaks_initWithString:URLString];
//}
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [[self class] methodSwizzleWithOrigSEL:@selector(initWithString:) overrideSEL:@selector(leaks_initWithString:)];
//        [[self class] classMethodSwizzleWithOrigSEL:@selector(URLWithString:) overrideSEL:@selector(leaks_URLWithString:)];
//    });
//}
//@end
