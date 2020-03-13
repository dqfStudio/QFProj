//
//  UIView+HAlert.m
//  HFundation
//
//  Created by dqf on 2018/1/22.
//  Copyright © 2018年 migu. All rights reserved.
//

#import "UIView+HAlert.h"
#import <objc/runtime.h>
#import "AFNetworkReachabilityManager.h"

@interface UIView ()
@property(nonatomic) HWaitingView *hWaitingView;
@property(nonatomic) HResultView *hResultView;
@property(nonatomic) HNaviToast *hNaviToast;
@property(nonatomic) HToast *hToast;
@property(nonatomic) HAlert *hAlert;
@property(nonatomic) HSheet *hSheet;
@property(nonatomic) HForm *hForm;
@end

@implementation UIView (HAlert)

- (HWaitingView *)hWaitingView {
    @synchronized(self) {
        HWaitingView *waitingView = [self getAssociatedValueForKey:_cmd];
        if (!waitingView) {
            waitingView = [[HWaitingView alloc] initWithFrame:self.frame];
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
            resultView = [[HResultView alloc] initWithFrame:self.frame];
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

- (HNaviToast *)hNaviToast {
    @synchronized(self) {
        HNaviToast *naviToast = [self getAssociatedValueForKey:_cmd];
        if (!naviToast) self.hNaviToast = [HNaviToast new];
        return naviToast;
    }
}
- (void)setHNaviToast:(HNaviToast *)hNaviToast {
    [self setAssociateValue:hNaviToast withKey:@selector(hNaviToast)];
}

- (HToast *)hToast {
    @synchronized(self) {
        HToast *toast = [self getAssociatedValueForKey:_cmd];
        if (!toast) self.hToast = [HToast new];
        return toast;
    }
}
- (void)setHToast:(HToast *)hToast {
    [self setAssociateValue:hToast withKey:@selector(hToast)];
}

- (HAlert *)hAlert {
    @synchronized(self) {
        HAlert *alert = [self getAssociatedValueForKey:_cmd];
        if (!alert) self.hAlert = [HAlert new];
        return alert;
    }
}
- (void)setHAlert:(HAlert *)hAlert {
    [self setAssociateValue:hAlert withKey:@selector(hAlert)];
}

- (HSheet *)hSheet {
    @synchronized(self) {
        HSheet *sheet = [self getAssociatedValueForKey:_cmd];
        if (!sheet) self.hSheet = [HSheet new];
        return sheet;
    }
}
- (void)setHSheet:(HSheet *)hSheet {
    [self setAssociateValue:hSheet withKey:@selector(hSheet)];
}

- (HForm *)hForm {
    @synchronized(self) {
        HForm *form = [self getAssociatedValueForKey:_cmd];
        if (!form) self.hForm = [HForm new];
        return form;
    }
}
- (void)setHForm:(HForm *)hForm {
    [self setAssociateValue:hForm withKey:@selector(hForm)];
}




- (void)showWaiting:(void(^)(id<HWaitingProtocol> make))configBlock {
    @synchronized(self) {
        [self removeResult];
        if ([self.hWaitingView conformsToProtocol:@protocol(HWaitingProtocol)]) {
            if (!self.hWaitingView.isLoading) {
                self.hWaitingView.isLoading = YES;
                if (configBlock) {
                    configBlock(self.hWaitingView);
                }
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Wundeclared-selector"
                [self.hWaitingView performSelector:@selector(wakeup)];
                #pragma clang diagnostic pop
                [self bringSubviewToFront:self.hWaitingView];
            }
        }
    }
}

- (void)showResult:(void(^)(id<HResultProtocol> make))configBlock {
    @synchronized(self) {
        [self removeWaiting];
        if ([self.hResultView conformsToProtocol:@protocol(HResultProtocol)]) {
            if (!self.hResultView.isLoading) {
                self.hResultView.isLoading = YES;
                if (configBlock) {
                    configBlock(self.hResultView);
                }
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Wundeclared-selector"
                [self.hResultView performSelector:@selector(wakeup)];
                #pragma clang diagnostic pop
                [self bringSubviewToFront:self.hResultView];
            }
        }
    }
}

- (void)showAlert:(void(^)(id<HAlertProtocol> make))configBlock {
    @synchronized(self) {
        if ([self.hAlert conformsToProtocol:@protocol(HAlertProtocol)]) {
            if (configBlock) {
                configBlock(self.hAlert);
            }
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wundeclared-selector"
            [self.hAlert performSelector:@selector(wakeup)];
            #pragma clang diagnostic pop
        }
    }
}

- (void)showSheet:(void(^)(id<HSheetProtocol> make))configBlock {
    @synchronized(self) {
        if ([self.hSheet conformsToProtocol:@protocol(HSheetProtocol)]) {
            if (configBlock) {
                configBlock(self.hSheet);
            }
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wundeclared-selector"
            [self.hSheet performSelector:@selector(wakeup)];
            #pragma clang diagnostic pop
        }
    }
}

- (void)showForm:(void(^)(id<HFormProtocol> make))configBlock {
    @synchronized(self) {
        if ([self.hForm conformsToProtocol:@protocol(HFormProtocol)]) {
            if (configBlock) {
                configBlock(self.hForm);
            }
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wundeclared-selector"
            [self.hForm performSelector:@selector(wakeup)];
            #pragma clang diagnostic pop
        }
    }
}

- (void)showToast:(void(^)(id<HToastProtocol> make))configBlock {
    @synchronized(self) {
        if ([self.hToast conformsToProtocol:@protocol(HToastProtocol)]) {
            if (configBlock) {
                configBlock(self.hToast);
            }
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wundeclared-selector"
            [self.hToast performSelector:@selector(wakeup)];
            #pragma clang diagnostic pop
        }
    }
}

- (void)showNaviToast:(void(^)(id<HNaviToastProtocol> make))configBlock {
    @synchronized(self) {
        if ([self.hNaviToast conformsToProtocol:@protocol(HNaviToastProtocol)]) {
            if (configBlock) {
                configBlock(self.hNaviToast);
            }
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wundeclared-selector"
            [self.hNaviToast performSelector:@selector(wakeup)];
            #pragma clang diagnostic pop
        }
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
