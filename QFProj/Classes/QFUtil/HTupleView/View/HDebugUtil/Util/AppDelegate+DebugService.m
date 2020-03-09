//
//  AppDelegate+DebugService.m
//  MGMobileMusic
//
//  Created by dqf on 2017/7/20.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "AppDelegate+DebugService.h"
#import "NSObject+HSwizzleUtil.h"
#import <objc/runtime.h>

@implementation AppDelegate (DebugService)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodSwizzleWithOrigSEL:@selector(application:didFinishLaunchingWithOptions:) overrideSEL:@selector(debug_application:didFinishLaunchingWithOptions:)];
    });
}
- (BOOL)debug_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self loadFolatingball];
    return [self debug_application:application didFinishLaunchingWithOptions:launchOptions];
}
#if DEBUG
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    CGPoint location = [[[event allTouches] anyObject] locationInView:self.window];
//    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
//    if (CGRectContainsPoint(statusBarFrame, location)) {
//        [self showDebugView];
//    }
//}
#endif
- (void)loadFolatingball {
    #if DEBUG
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.rootView addSubview:self.folatingball];
    });
    #endif
}
- (JhtFloatingBall *)folatingball {
    JhtFloatingBall *folatingball = objc_getAssociatedObject(self, _cmd);
    if (!folatingball) {
        UIImage *suspendedBallImage = [UIImage imageNamed:@"JhtFloatingBallIcon"];
        folatingball = [[JhtFloatingBall alloc] initWithFrame:CGRectMake(UIScreen.width-65, UIScreen.height/2-65/2, 65, 65)];
        folatingball.image = suspendedBallImage;
        folatingball.stayAlpha = 0.6;
        folatingball.delegate = self;
        objc_setAssociatedObject(self, @selector(folatingball), folatingball, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return folatingball;
}
- (UIWindow *)rootView {
    return [UIApplication sharedApplication].delegate.window;
}
- (CGRect)originFrame {
    return CGRectMake(0,
                      -CGRectGetHeight(self.screenFrame),
                      CGRectGetWidth(self.screenFrame),
                      CGRectGetHeight(self.screenFrame));
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
            [self.rootView bringSubviewToFront:self.folatingball];
        }];
    }else {
        [self hideDebugView];
    }
}

#pragma mark - JhtFloatingBallDelegate
- (void)tapFloatingBall {
    [self showDebugView];
}

@end
