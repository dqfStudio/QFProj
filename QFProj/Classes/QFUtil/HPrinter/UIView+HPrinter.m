//
//  UIView+HPrinter.m
//  QFProj
//
//  Created by dqf on 2018/8/7.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "UIView+HPrinter.h"
#import <objc/runtime.h>

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
    if (![self isSystemClass:self.class]) {
        NSLog(@"className:%@", NSStringFromClass(self.class));
        return;
    }
    NSString *loginfo = [self logInfo];
    if (loginfo) {
        NSLog(@"loginfo:%@", loginfo);
        return;
    }else if (self.superview && ![self isSystemClass:self.superview.class]){
        NSLog(@"super[1]ClassName:%@", NSStringFromClass(self.superview.class));
        return;
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

