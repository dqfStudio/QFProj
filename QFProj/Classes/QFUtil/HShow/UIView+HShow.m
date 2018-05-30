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
@property(nonatomic) UIView *mgToast;
@property(nonatomic) UIView *mgSheet;
@property(nonatomic) UIView *mgForm;
@property(nonatomic) UIView *mgAlert;
@end

@implementation UIView (HShow)

- (HRequestWaitingView *)mgWaitingView {
    @synchronized(self) {
        HRequestWaitingView *waitingView = [self getAssociatedValueForKey:_cmd];
        if (!waitingView) {
            waitingView = [HRequestWaitingView awakeView];
            self.mgWaitingView = waitingView;
            [waitingView setHidden:YES];
            [self addSubview:waitingView];
        }
        return [self getAssociatedValueForKey:_cmd];
    }
}
- (void)setMgWaitingView:(HRequestWaitingView *)mgWaitingView {
    [self setAssociateValue:mgWaitingView withKey:@selector(mgWaitingView)];
}

- (HRequestResultView *)mgResultView {
    @synchronized(self) {
        HRequestResultView *mgResultView = [self getAssociatedValueForKey:_cmd];
        if (!mgResultView) {
            mgResultView = [HRequestResultView awakeView];
            self.mgResultView = mgResultView;
            [mgResultView setHidden:YES];
            [self addSubview:mgResultView];
        }
        return [self getAssociatedValueForKey:_cmd];
    }
}
- (void)setMgResultView:(HRequestResultView *)mgResultView {
    [self setAssociateValue:mgResultView withKey:@selector(mgResultView)];
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
                self.mgResultView.type = MGRequestResultViewTypeNoData;
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
                self.mgResultView.type = MGRequestResultViewTypeNoNetwork;
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
                    self.mgResultView.type = MGRequestResultViewTypeNoNetwork;
                }else {
                    self.mgResultView.type = MGRequestResultViewTypeLoadError;
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

- (void)showSheet:(void(^)(id<HSheetProtocol> make))configBlock {
    if ([self.mgSheet conformsToProtocol:@protocol(HSheetProtocol)]) {
        if (configBlock) {
//            configBlock(self.mgSheet);
        }
    }
}

- (void)showForm:(void(^)(id<HFormProtocol> make))configBlock {
    if ([self.mgForm conformsToProtocol:@protocol(HFormProtocol)]) {
        if (configBlock) {
//            configBlock(self.mgForm);
        }
    }
}

- (void)showToast:(void(^)(id<HToastProtocol> make))configBlock {
    if ([self.mgToast conformsToProtocol:@protocol(HToastProtocol)]) {
        if (configBlock) {
//            configBlock(self.mgToast);
        }
    }
}

- (void)showAlert:(void(^)(id<HAlertProtocol> make))configBlock {
    if ([self.mgAlert conformsToProtocol:@protocol(HAlertProtocol)]) {
        if (configBlock) {
//            configBlock(self.mgAlert);
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

- (void)removeSheet {
    
}

- (void)removeForm {
    
}

- (void)removeToast {
    
}

- (void)removeAlert {
    
}

@end
