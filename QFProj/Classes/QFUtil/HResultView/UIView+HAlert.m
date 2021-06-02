//
//  UIView+HAlert.m
//  HFundation
//
//  Created by dqf on 2018/1/22.
//  Copyright © 2018年 migu. All rights reserved.
//

#import "UIView+HAlert.h"
#import <objc/runtime.h>

@interface UIView ()
@property(nonatomic) HWaitingView *hWaitingView;
@property(nonatomic) HResultView *hResultView;
@end

@implementation UIView (HAlert)

- (HWaitingView *)hWaitingView {
    @synchronized(self) {
        HWaitingView *waitingView = [self getAssociatedValueForKey:_cmd];
        if (!waitingView) {
            waitingView = [[HWaitingView alloc] initWithFrame:self.bounds];
            ALWAYS_CENTER(waitingView);
            self.hWaitingView = waitingView;
            [self addSubview:waitingView];
        }
        return waitingView;
    }
}
- (void)setHWaitingView:(HWaitingView *)hWaitingView {
    [self setAssociateValue:hWaitingView withKey:@selector(hWaitingView)];
}

- (HResultView *)hResultView {
    @synchronized(self) {
        HResultView *resultView = [self getAssociatedValueForKey:_cmd];
        if (!resultView) {
            resultView = [[HResultView alloc] initWithFrame:self.bounds];
            ALWAYS_CENTER(resultView);
            self.hResultView = resultView;
            [self addSubview:resultView];
        }
        return resultView;
    }
}
- (void)setHResultView:(HResultView *)hResultView {
    [self setAssociateValue:hResultView withKey:@selector(hResultView)];
}



- (void)showWaiting:(void(^)(HWaitingTransition *make))block {
    @synchronized(self) {
        [self removeResult];
        if (!self.hWaitingView.superview) {
            HWaitingTransition *make = HWaitingTransition.new;
            if (block) block(make);
            self.hWaitingView.make = make;
        }
        [self bringSubviewToFront:self.hWaitingView];
    }
}
- (void)showResult:(void(^)(HResultTransition *make))block {
    @synchronized(self) {
        [self removeWaiting];
        if (!self.hResultView.superview) {
            HResultTransition *make = HResultTransition.new;
            if (block) block(make);
            self.hResultView.make = make;
        }
        [self bringSubviewToFront:self.hResultView];
    }
}



- (void)removeWaiting {
    [self.hWaitingView removeFromSuperview];
    [self setHWaitingView:nil];
}
- (void)removeResult {
    [self.hResultView removeFromSuperview];
    [self setHResultView:nil];
}

@end
