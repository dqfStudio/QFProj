//
//  HDebugUtil.m
//  TestProject
//
//  Created by dqf on 2017/7/19.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "HDebugUtil.h"
#import "AppDelegate.h"
#import "HDebugView.h"

@interface HDebugUtil ()
@property (nonatomic, strong) HDebugView *debugView;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, assign) CGRect newFrame;
@end

@implementation HDebugUtil

+ (HDebugUtil *)share {
    static HDebugUtil *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        //初始化单利
        [self initInstance];
    }
    return self;
}

- (void)initInstance {
    
}

- (UIWindow *)rootView {
    return [UIApplication sharedApplication].delegate.window;
}

- (CGRect)originFrame {
    return CGRectMake(0, -CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
}

- (CGRect)newFrame {
    return [UIScreen mainScreen].bounds;
}

- (HDebugView *)debugView {
    if (!_debugView) {
        _debugView = [[HDebugView alloc] initWithFrame:self.newFrame];
        [_debugView.lineView addTarget:self action:@selector(hideDebugView) forControlEvents:UIControlEventTouchUpInside];
        [_debugView setTag:0];
        [[self rootView] addSubview:_debugView];
        [[self rootView] sendSubviewToBack:_debugView];
    }
    return _debugView;
}

- (void)hideDebugView {
    if (self.debugView.tag == 1) {
        [self.debugView setTag:0];
        [UIView animateWithDuration:0.3 animations:^{
            [self.debugView setFrame:self.originFrame];
            [[self rootView] sendSubviewToBack:self.debugView];
        }];        
    }else if (self.debugView.tag == 0) {
        [self showDebugView];
    }
}

- (void)showDebugView {
    if (self.debugView.tag == 0) {
        [self.debugView setTag:1];
        [self.debugView setFrame:self.originFrame];
        [UIView animateWithDuration:0.3 animations:^{
            [self.debugView setFrame:self.newFrame];
            [[self rootView] bringSubviewToFront:self.debugView];
        }];
    }else if (self.debugView.tag == 1) {
        [self hideDebugView];
    }
}

@end
