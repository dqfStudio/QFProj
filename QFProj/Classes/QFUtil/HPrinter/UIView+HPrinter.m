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

@implementation UIView (HPrinter)

#if DEBUG
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
        NSLog(@"className:%@", NSStringFromClass(self.class));
        return;
    }
    NSString *loginfo = [self logInfo];
    if (loginfo) {
        NSLog(@"loginfo:%@", loginfo);
        return;
    }
    if ([self isKindOfClass:UILabel.class]) {
        UILabel *label = (UILabel *)self;
        if (label.text.length > 0 && ![label.text isEqualToString:@""]) {
            NSLog(@"label.text:%@", label.text);
        }
    }
    else if ([self isKindOfClass:UITextView.class]) {
        UITextView *textView = (UITextView *)self;
        if (textView.text.length > 0 && ![textView.text isEqualToString:@""]) {
            NSLog(@"textView.text:%@", textView.text);
        }
    }
    else if ([self isKindOfClass:UIButton.class] || [self isKindOfClass:UIControl.class]) {
        if ([self isKindOfClass:UIButton.class]) {
            UIButton *btn = (UIButton *)self;
            if (btn.titleLabel.text.length > 0 && ![btn.titleLabel.text isEqualToString:@""]) {
                NSLog(@"button.text:%@", btn.titleLabel.text);
            }
            if (btn.allTargets.count > 0) {
                NSObject *objc = [[btn.allTargets allObjects] firstObject];
                NSLog(@"button.targets:%@", NSStringFromClass(objc.class));
            }
            if (btn.imageView.image.accessibilityIdentifier) {
                NSLog(@"button.image.name:%@", btn.imageView.image.accessibilityIdentifier);
                return;
            }
        }else if ([self isKindOfClass:UIControl.class]) {
            UIControl *control = (UIControl *)self;
            if (control.allTargets.count > 0) {
                NSObject *objc = [[control.allTargets allObjects] firstObject];
                NSLog(@"control.targets:%@", NSStringFromClass(objc.class));
            }
        }
    }
    else if ([self isKindOfClass:UIImageView.class]) {
        UIImageView *imageView = (UIImageView *)self;
        if (imageView.image.accessibilityIdentifier) {
            NSLog(@"imageView.image.name:%@", imageView.image.accessibilityIdentifier);
        }
        return;
    }
    
    if (self.superview && ![self isSystemClass:self.superview.class]){
        NSLog(@"super[1]ClassName:%@", NSStringFromClass(self.superview.class));
    }else if (self.superview.superview && ![self isSystemClass:self.superview.superview.class]){
        NSLog(@"super[2]ClassName:%@", NSStringFromClass(self.superview.superview.class));
    }else if (self.superview.superview.superview && ![self isSystemClass:self.superview.superview.superview.class]){
        NSLog(@"super[3]ClassName:%@", NSStringFromClass(self.superview.superview.superview.class));
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
        NSLog(@"viewController:%@",NSStringFromClass([controller class]));
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
#endif

@end

