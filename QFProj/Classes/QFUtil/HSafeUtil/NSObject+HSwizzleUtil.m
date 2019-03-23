//
//  NSObject+HSwizzleUtil.m
//  TestProject
//
//  Created by dqf on 2017/9/28.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSObject+HSwizzleUtil.h"

void HSwizzleClassMethod(Class cls, SEL origSEL, SEL overrideSEL) {
    if (!cls) return;
    Method originalMethod = class_getClassMethod(cls, origSEL);
    Method swizzledMethod = class_getClassMethod(cls, overrideSEL);
    
    Class metacls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    if (class_addMethod(metacls,
                        origSEL,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /* swizzing super class method, added if not exist */
        class_replaceMethod(metacls,
                            overrideSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    }else {
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(metacls,
                            overrideSEL,
                            class_replaceMethod(metacls,
                                                origSEL,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
}

void HSwizzleInstanceMethod(Class cls, SEL origSEL, SEL overrideSEL) {
    if (!cls) return;
    /* if current class not exist selector, then get super*/
    Method originalMethod = class_getInstanceMethod(cls, origSEL);
    Method swizzledMethod = class_getInstanceMethod(cls, overrideSEL);
    
    /* add selector if not exist, implement append with method */
    if (class_addMethod(cls,
                        origSEL,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /* replace class instance method, added if selector not exist */
        /* for class cluster , it always add new selector here */
        class_replaceMethod(cls,
                            overrideSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    }else {
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(cls,
                            overrideSEL,
                            class_replaceMethod(cls,
                                                origSEL,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
}

void HSwizzleClassMethodNames(NSArray *classNames, SEL origSEL, SEL overrideSEL) {
    if (classNames.count == 0) return;
    for (NSString *className in classNames) {
        HSwizzleClassMethod(NSClassFromString(className), origSEL, overrideSEL);
    }
}

void HSwizzleInstanceMethodNames(NSArray *classNames, SEL origSEL, SEL overrideSEL) {
    if (classNames.count == 0) return;
    for (NSString *className in classNames) {
        HSwizzleInstanceMethod(NSClassFromString(className), origSEL, overrideSEL);
    }
}

@implementation NSObject (HSwizzleUtil)
//+ (void)methodSwizzleWithOrigSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL {
//    Method origMethod = class_getInstanceMethod([self class], origSEL);
//    Method overrideMethod= class_getInstanceMethod([self class], overrideSEL);
//    if(class_addMethod([self class], origSEL,
//                       method_getImplementation(overrideMethod),
//                       method_getTypeEncoding(overrideMethod))) {
//        class_replaceMethod([self class],overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
//    }else {
//        method_exchangeImplementations(origMethod,overrideMethod);
//    }
//}
//+ (void)classMethodSwizzleWithOrigSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL {
//    Method origMethod = class_getClassMethod(self, origSEL);
//    Method overrideMethod= class_getClassMethod(self, overrideSEL);
//    Class metaClass = object_getClass(self);
//    if(class_addMethod(metaClass, origSEL,
//                       method_getImplementation(overrideMethod),
//                       method_getTypeEncoding(overrideMethod))) {
//        class_replaceMethod(metaClass,overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
//    }else {
//        method_exchangeImplementations(origMethod,overrideMethod);
//    }
//}
+ (void)methodSwizzleWithOrigSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL {
    HSwizzleInstanceMethod(self.class, origSEL, overrideSEL);
}
+ (void)classMethodSwizzleWithOrigSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL {
    HSwizzleClassMethod(self.class, origSEL, overrideSEL);
}
@end
