//
//  UIView+HShow.m
//  HFundation
//
//  Created by dqf on 2018/1/22.
//  Copyright © 2018年 migu. All rights reserved.
//

#import "UIView+HShow.h"
#import <objc/runtime.h>
#import "AFNetworkReachabilityManager.h"

@interface UIView ()
@property(nonatomic) HWaitingView *mgWaitingView;
//@property(nonatomic) HRequestResultView *mgResultView;
@property(nonatomic) HNaviToast *mgNaviToast;
@property(nonatomic) HToast *mgToast;
@property(nonatomic) HAlert *mgAlert;
@property(nonatomic) HSheet *mgSheet;
@property(nonatomic) HForm *mgForm;
@end

@implementation UIView (HShow)

- (HWaitingView *)mgWaitingView {
    @synchronized(self) {
        HWaitingView *waitingView = [self getAssociatedValueForKey:_cmd];
        if (!waitingView) {
            waitingView = [[HWaitingView alloc] initWithFrame:self.frame];            
            self.mgWaitingView = waitingView;
            [waitingView setHidden:YES];
            [self addSubview:waitingView];
        }
        return [self getAssociatedValueForKey:_cmd];
    }
}
- (void)setMgWaitingView:(HWaitingView *)mgWaitingView {
    [self setAssociateValue:mgWaitingView withKey:@selector(mgWaitingView)];
}

- (HResultView *)mgResultView {
    @synchronized(self) {
        HResultView *mgResultView = [self getAssociatedValueForKey:_cmd];
        if (!mgResultView) {
            mgResultView = [[HResultView alloc] initWithFrame:self.frame];
            self.mgResultView = mgResultView;
            [mgResultView setHidden:YES];
            [self addSubview:mgResultView];
        }
        return [self getAssociatedValueForKey:_cmd];
    }
}
- (void)setMgResultView:(HResultView *)mgResultView {
    [self setAssociateValue:mgResultView withKey:@selector(mgResultView)];
}

- (HNaviToast *)mgNaviToast {
    @synchronized(self) {
        HNaviToast *naviToast = [self getAssociatedValueForKey:_cmd];
        if (!naviToast) self.mgNaviToast = [HNaviToast new];
        return [self getAssociatedValueForKey:_cmd];
    }
}
- (void)setMgNaviToast:(HNaviToast *)mgNaviToast {
    [self setAssociateValue:mgNaviToast withKey:@selector(mgNaviToast)];
}

- (HToast *)mgToast {
    @synchronized(self) {
        HToast *toast = [self getAssociatedValueForKey:_cmd];
        if (!toast) self.mgToast = [HToast new];
        return [self getAssociatedValueForKey:_cmd];
    }
}
- (void)setMgToast:(HToast *)mgToast {
    [self setAssociateValue:mgToast withKey:@selector(mgToast)];
}

- (HAlert *)mgAlert {
    @synchronized(self) {
        HAlert *alert = [self getAssociatedValueForKey:_cmd];
        if (!alert) self.mgAlert = [HAlert new];
        return [self getAssociatedValueForKey:_cmd];
    }
}
- (void)setMgAlert:(HAlert *)mgAlert {
    [self setAssociateValue:mgAlert withKey:@selector(mgAlert)];
}

- (HSheet *)mgSheet {
    @synchronized(self) {
        HSheet *sheet = [self getAssociatedValueForKey:_cmd];
        if (!sheet) self.mgSheet = [HSheet new];
        return [self getAssociatedValueForKey:_cmd];
    }
}
- (void)setMgSheet:(HSheet *)mgSheet {
    [self setAssociateValue:mgSheet withKey:@selector(mgSheet)];
}

- (HForm *)mgForm {
    @synchronized(self) {
        HForm *form = [self getAssociatedValueForKey:_cmd];
        if (!form) self.mgForm = [HForm new];
        return [self getAssociatedValueForKey:_cmd];
    }
}
- (void)setMgForm:(HForm *)mgForm {
    [self setAssociateValue:mgForm withKey:@selector(mgForm)];
}




- (void)showWaiting:(void(^)(id<HWaitingProtocol> make))configBlock {
    @synchronized(self) {
        [self removeLoadError];
        if ([self.mgWaitingView conformsToProtocol:@protocol(HWaitingProtocol)]) {
            if (![self.mgWaitingView isLoading]) {
                [self.mgWaitingView start];
                if (configBlock) {
                    configBlock(self.mgWaitingView);
                }
                [self.mgWaitingView setHidden:NO];
                [self bringSubviewToFront:self.mgWaitingView];
                [self.mgWaitingView end];
            }
        }
    }
}

- (void)showNoData:(void(^)(id<HNoDataProtocol> make))configBlock {
    @synchronized(self) {
        [self removeWaiting];
        if ([self.mgResultView conformsToProtocol:@protocol(HNoDataProtocol)]) {
            if (![self.mgResultView isLoading]) {
                [self.mgResultView start];
//                self.mgResultView.type = MGRequestResultViewTypeNoData;
                if (configBlock) {
                    configBlock(self.mgResultView);
                }
                [self.mgResultView setHidden:NO];
                [self bringSubviewToFront:self.mgResultView];
                [self.mgResultView end];
            }
        }
    }
}

- (void)showNoNetwork:(void(^)(id<HNoNetworkProtocol> make))configBlock {
    @synchronized(self) {
        [self removeWaiting];
        if ([self.mgResultView conformsToProtocol:@protocol(HNoNetworkProtocol)]) {
            if (![self.mgResultView isLoading]) {
                [self.mgResultView start];
//                self.mgResultView.type = MGRequestResultViewTypeNoNetwork;
                if (configBlock) {
                    configBlock(self.mgResultView);
                }
                [self.mgResultView setHidden:NO];
                [self bringSubviewToFront:self.mgResultView];
                [self.mgResultView end];
            }
        }
    }
}

- (void)showLoadError:(void(^)(id<HLoadErrorProtocol> make))configBlock {
    @synchronized(self) {
        [self removeWaiting];
        if ([self.mgResultView conformsToProtocol:@protocol(HLoadErrorProtocol)]) {
            if (![self.mgResultView isLoading]) {
                [self.mgResultView start];
                if (![AFNetworkReachabilityManager sharedManager].isReachable) {
//                    self.mgResultView.type = MGRequestResultViewTypeNoNetwork;
                }else {
//                    self.mgResultView.type = MGRequestResultViewTypeLoadError;
                }
                if (configBlock) {
                    configBlock(self.mgResultView);
                }
                [self.mgResultView setHidden:NO];
                [self bringSubviewToFront:self.mgResultView];
                [self.mgResultView end];
            }
        }
    }
}

- (void)showAlert:(void(^)(id<HAlertProtocol> make))configBlock {
    @synchronized(self) {
        if ([self.mgAlert conformsToProtocol:@protocol(HAlertProtocol)]) {
            if (![self.mgAlert isLoading]) {
                [self.mgAlert start];
                if (configBlock) {
                    configBlock(self.mgAlert);
                }
                [self.mgAlert end];
            }
        }
    }
}

- (void)showSheet:(void(^)(id<HSheetProtocol> make))configBlock {
    @synchronized(self) {
        if ([self.mgSheet conformsToProtocol:@protocol(HSheetProtocol)]) {
            if (![self.mgSheet isLoading]) {
                [self.mgSheet start];
                if (configBlock) {
                    configBlock(self.mgSheet);
                }
                [self.mgSheet end];
            }
        }
    }
}

- (void)showForm:(void(^)(id<HFormProtocol> make))configBlock {
    @synchronized(self) {
        if ([self.mgForm conformsToProtocol:@protocol(HFormProtocol)]) {
            if (![self.mgForm isLoading]) {
                [self.mgForm start];
                if (configBlock) {
                    configBlock(self.mgForm);
                }
                [self.mgForm end];
            }
        }
    }
}

- (void)showToast:(void(^)(id<HToastProtocol> make))configBlock {
    @synchronized(self) {
        if ([self.mgToast conformsToProtocol:@protocol(HToastProtocol)]) {
            if (![self.mgToast isLoading]) {
                [self.mgToast start];
                if (configBlock) {
                    configBlock(self.mgToast);
                }
                [self.mgToast end];
            }
        }
    }
}

- (void)showNaviToast:(void(^)(id<HNaviToastProtocol> make))configBlock {
    @synchronized(self) {
        if ([self.mgNaviToast conformsToProtocol:@protocol(HNaviToastProtocol)]) {
            if (![self.mgNaviToast isLoading]) {
                [self.mgNaviToast start];
                if (configBlock) {
                    configBlock(self.mgNaviToast);
                }
                [self.mgNaviToast end];
            }
        }
    }
}



- (void)removeWaiting {
    [self.mgWaitingView removeFromSuperview];
    [self setMgWaitingView:nil];
}

- (void)removeNoData {
    [self.mgResultView removeFromSuperview];
    [self setMgResultView:nil];
}

- (void)removeNoNetwork {
    [self.mgResultView removeFromSuperview];
    [self setMgResultView:nil];
}

- (void)removeLoadError {
    [self.mgResultView removeFromSuperview];
    [self setMgResultView:nil];
}

@end
