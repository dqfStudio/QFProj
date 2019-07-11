//
//  UIView+HSafeMessy.m
//  QFProj
//
//  Created by wind on 2019/7/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "UIView+HSafeMessy.h"
#import <objc/runtime.h>

@interface NSObject (HSafeMessy)

@end

@implementation NSObject (HSafeMessy)
+ (void)methodSwizzleWithOrigSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL {
    Method origMethod = class_getInstanceMethod([self class], origSEL);
    Method overrideMethod= class_getInstanceMethod([self class], overrideSEL);
    if(class_addMethod([self class], origSEL,
                       method_getImplementation(overrideMethod),
                       method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod([self class],overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else {
        method_exchangeImplementations(origMethod,overrideMethod);
    }
}
@end

@implementation UILabel (HSafeMessy)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzleWithOrigSEL:@selector(setText:) overrideSEL:@selector(safeMessy_setText:)];
    });
}
- (void)safeMessy_setText:(NSString *)text {
    NSString *content = nil;
    if ([text isKindOfClass:NSNumber.class]) {
        content = [NSString stringWithFormat:@"%@", text];
    }else if ([text isKindOfClass:NSString.class]) {
        content = text;
    }
    [self safeMessy_setText:content];
}
@end

@implementation UITextView (HSafeMessy)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzleWithOrigSEL:@selector(setText:) overrideSEL:@selector(safeMessy_setText:)];
    });
}
- (void)safeMessy_setText:(NSString *)text {
    NSString *content = nil;
    if ([text isKindOfClass:NSNumber.class]) {
        content = [NSString stringWithFormat:@"%@", text];
    }else if ([text isKindOfClass:NSString.class]) {
        content = text;
    }
    [self safeMessy_setText:content];
}
@end

