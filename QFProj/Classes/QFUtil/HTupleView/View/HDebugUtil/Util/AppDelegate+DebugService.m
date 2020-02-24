//
//  AppDelegate+DebugService.m
//  MGMobileMusic
//
//  Created by dqf on 2017/7/20.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "AppDelegate+DebugService.h"
#import <objc/runtime.h>

@implementation AppDelegate (DebugService)
#if DEBUG
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint location = [[[event allTouches] anyObject] locationInView:self.window];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    if (CGRectContainsPoint(statusBarFrame, location)) {
        [self showDebugView];
    }
}
#endif
- (UIWindow *)rootView {
    return [UIApplication sharedApplication].delegate.window;
}
- (CGRect)originFrame {
    return CGRectMake(0, -CGRectGetHeight(self.screenFrame), CGRectGetWidth(self.screenFrame), CGRectGetHeight(self.screenFrame));
}
- (CGRect)newFrame {
    return self.screenFrame;
}
- (CGRect)screenFrame {
    return [UIScreen mainScreen].bounds;
}
- (HDebugView *)debugView {
    HDebugView *debugView = objc_getAssociatedObject(self, _cmd);
    if (!debugView) {
        debugView = [[HDebugView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [debugView.lineView addTarget:self action:@selector(hideDebugView) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(self, @selector(debugView), debugView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return debugView;
}
- (void)hideDebugView {
    if (self.debugView.superview) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.debugView setFrame:self.originFrame];
            [self.debugView removeFromSuperview];
        }];
    }else {
        [self showDebugView];
    }
}
- (void)showDebugView {
    if (!self.debugView.superview) {
        [self.debugView setFrame:self.originFrame];
        [UIView animateWithDuration:0.3 animations:^{
            [self.debugView setFrame:self.newFrame];
            [self.rootView addSubview:self.debugView];
        }];
    }else {
        [self hideDebugView];
    }
}

@end
