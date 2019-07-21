//
//  UIView+HPrinter.m
//  QFProj
//
//  Created by dqf on 2018/8/7.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "UIView+HPrinter.h"
#import <objc/runtime.h>
#import "NSObject+HExclusive.h"

#if DEBUG

@implementation UIView (HPrinter)

- (void)addString:(NSString *)aString withView:(UIView *)view {
    SEL selector = NSSelectorFromString(@"addSubview:");
    if ([self respondsToSelector:selector]) {
_Pragma("clang diagnostic push")
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
        [self performSelector:selector withObject:view];
_Pragma("clang diagnostic pop")
        [[HPrinterManager share] setObject:aString forKey:[NSString stringWithFormat:@"%p", view]];
    }
}
- (void)logMark {
    [self exclusive:@"logMarkExclusive" block:^(HExclusive stop) {
        [self logAction];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            stop();
        });
    }];
}
- (void)logAction {
    if (![self isSystemClass:self.class]) {
        printf("\nHPrinting-->className:%s", NSStringFromClass(self.class).UTF8String);
        //return;
    }
    NSString *loginfo = [self logInfo];
    if (loginfo) {
        printf("\nHPrinting-->loginfo:%s", loginfo.UTF8String);
        //return;
    }
    if ([self isKindOfClass:UILabel.class]) {
        UILabel *label = (UILabel *)self;
        if (label.text.length > 0 && ![label.text isEqualToString:@""]) {
            printf("\nHPrinting-->label.text:%s", label.text.UTF8String);
        }
    }
    else if ([self isKindOfClass:UITextView.class]) {
        UITextView *textView = (UITextView *)self;
        if (textView.text.length > 0 && ![textView.text isEqualToString:@""]) {
            printf("\nHPrinting-->textView.text:%s", textView.text.UTF8String);
        }
    }
    else if ([self isKindOfClass:UIControl.class]) {
        if ([self isKindOfClass:UIButton.class]) {
            UIButton *btn = (UIButton *)self;
            if (btn.titleLabel.text.length > 0 && ![btn.titleLabel.text isEqualToString:@""]) {
                printf("\nHPrinting-->button.text:%s", btn.titleLabel.text.UTF8String);
            }
            if (btn.allTargets.count > 0) {
                NSObject *objc = [[btn.allTargets allObjects] firstObject];
                printf("\nHPrinting-->button.targets:%s", NSStringFromClass(objc.class).UTF8String);
            }
            if (btn.imageView.image.accessibilityIdentifier) {
                printf("\nHPrinting-->button.image.name:%s", btn.imageView.image.accessibilityIdentifier.UTF8String);
                return;
            }
        }else if ([self isKindOfClass:UIControl.class]) {
            UIControl *control = (UIControl *)self;
            if (control.allTargets.count > 0) {
                NSObject *objc = [[control.allTargets allObjects] firstObject];
                printf("\nHPrinting-->control.targets:%s", NSStringFromClass(objc.class).UTF8String);
            }
        }
    }
    else if ([self isKindOfClass:UIImageView.class]) {
        UIImageView *imageView = (UIImageView *)self;
        if (imageView.image.accessibilityIdentifier) {
            printf("\nHPrinting-->imageView.image.name:%s", imageView.image.accessibilityIdentifier.UTF8String);
        }
        return;
    }
    
    if (self.superview && ![self isSystemClass:self.superview.class]){
        printf("\nHPrinting-->super[1]ClassName:%s", NSStringFromClass(self.superview.class).UTF8String);
    }else if (self.superview.superview && ![self isSystemClass:self.superview.superview.class]){
        printf("\nHPrinting-->super[2]ClassName:%s", NSStringFromClass(self.superview.superview.class).UTF8String);
    }else if (self.superview.superview.superview && ![self isSystemClass:self.superview.superview.superview.class]){
        printf("\nHPrinting-->super[3]ClassName:%s", NSStringFromClass(self.superview.superview.superview.class).UTF8String);
    }
    [self logVC];
}
- (void)logVC {
    id next = [self nextResponder];
    UIViewController *controller = nil;
    while(![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
        if (!next) break;
    }
    if ([next isKindOfClass:[UIViewController class]]) {
        controller = (UIViewController *)next;
        printf("\nHPrinting-->viewController:%s", NSStringFromClass([controller class]).UTF8String);
    }
}
- (NSString *)logInfo {
    NSString *ipString = [NSString stringWithFormat:@"%p", self];
    if ([[HPrinterManager share] containsObject:ipString]) {
        NSString *content = [[HPrinterManager share] objectForKey:ipString];
        if (content) {
            return content;
        }
    }
    return nil;
}
- (BOOL)isSystemClass:(Class)aClass {
    NSBundle *bundle = [NSBundle bundleForClass:aClass];
    if ([bundle isEqual:[NSBundle mainBundle]]) {
        return NO;
    }else {
        return YES;
    }
}

@end

@interface UIImage (HPrinter)

@end

@implementation UIImage (HPrinter)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self classMethodSwizzleWithOrigSEL:@selector(imageNamed:) overrideSEL:@selector(name_imageNamed:)];
    });
}
+ (nullable UIImage *)name_imageNamed:(NSString *)name {
    UIImage *image = [self name_imageNamed:name];
    [image setAccessibilityIdentifier:name];
    return image;
}
@end

#endif
