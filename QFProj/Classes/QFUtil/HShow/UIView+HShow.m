//
//  UIView+HShow.m
//  HFundation
//
//  Created by dqf on 2018/1/22.
//  Copyright © 2018年 migu. All rights reserved.
//

#import "UIView+HShow.h"
#import <objc/runtime.h>
//#import <ReactiveCocoa/ReactiveCocoa.h>
//#import "AFNetworkReachabilityManager.h"

@interface UIView ()
//@property (nonatomic, strong) RACDisposable *mgDisposableHandler;
@property(nonatomic) UIView *mgLoading;
@property(nonatomic) UIView *mgToast;
@property(nonatomic) UIView *mgSheet;
@property(nonatomic) UIView *mgForm;
@property(nonatomic) UIView *mgAlert;
@end

@implementation UIView (HShow)

//- (MGRequestResultView *)mgLoadError {
//    @synchronized(self) {
//        MGRequestResultView *loadError = [self getAssociatedValueForKey:_cmd];
//        if (!loadError) {
//            loadError = [MGRequestResultView viewFromNib];
//            [loadError setTag:33333333];
//            self.mgLoadError = loadError;
//        }
//        if (loadError && ![self.subviews containsObject:loadError]) {
//            [loadError setHidden:YES];
//            [self addSubview:loadError];
//        }
//        return [self getAssociatedValueForKey:_cmd];
//    }
//}
//- (void)setMgLoadError:(MGRequestResultView *)mgLoadError {
//    [self setAssociateValue:mgLoadError withKey:@selector(mgLoadError)];
//}





- (void)showLoading:(void(^)(id<HLoadingProtocol> make))configBlock {
    if ([self.mgLoading conformsToProtocol:@protocol(HLoadingProtocol)]) {
        if (configBlock) {
//            configBlock(self.mgLoading);
        }
    }
}

- (void)showNoData:(void(^)(id<HNoDataProtocol> make))configBlock {
//    @synchronized(self) {
//        [self removeLoading];
//        if ([self.mgLoadError conformsToProtocol:@protocol(MGNoDataProtocol)]) {
//            if (![self.mgLoadError isLoading]) {
//                [self.mgLoadError start];
//                self.mgLoadError.type = MGRequestResultViewTypeNoData;
//                if (configBlock) {
//                    configBlock(self.mgLoadError);
//                }
//                [self.mgLoadError addObserver];
//                [self.mgLoadError setHidden:NO];
//                [self bringSubviewToFront:self.mgLoadError];
//                [self.mgLoadError end];
//            }
//        }
//    }
}

- (void)showNoNetwork:(void(^)(id<HNoNetworkProtocol> make))configBlock {
//    @synchronized(self) {
//        [self removeLoading];
//        if ([self.mgLoadError conformsToProtocol:@protocol(MGNoNetworkProtocol)]) {
//            if (![self.mgLoadError isLoading]) {
//                [self.mgLoadError start];
//                self.mgLoadError.type = MGRequestResultViewTypeNoNetwork;
//                if (configBlock) {
//                    configBlock(self.mgLoadError);
//                }
//                [self.mgLoadError addObserver];
//                [self.mgLoadError setHidden:NO];
//                [self bringSubviewToFront:self.mgLoadError];
//                [self.mgLoadError end];
//            }
//        }
//    }
}

- (void)showLoadError:(void(^)(id<HLoadErrorProtocol> make))configBlock {
//    @synchronized(self) {
//        [self removeLoading];
//        if ([self.mgLoadError conformsToProtocol:@protocol(MGLoadErrorProtocol)]) {
//            if (![self.mgLoadError isLoading]) {
//                [self.mgLoadError start];
//                if (![AFNetworkReachabilityManager sharedManager].isReachable) {
//                    self.mgLoadError.type = MGRequestResultViewTypeNoNetwork;
//                }else {
//                    self.mgLoadError.type = MGRequestResultViewTypeLoadError;
//                }
//                if (configBlock) {
//                    configBlock(self.mgLoadError);
//                }
//                [self.mgLoadError addObserver];
//                [self.mgLoadError setHidden:NO];
//                [self bringSubviewToFront:self.mgLoadError];
//                [self.mgLoadError end];
//            }
//        }
//    }
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



- (void)removeLoading {
    if ([self.mgLoading conformsToProtocol:@protocol(HLoadingProtocol)]) {
//        id<HLoadingProtocol> loading = self.mgLoading;
    }
}

- (void)removeNoData {
//    [self.mgLoadError removeObserver];
//    [self.mgLoadError removeFromSuperview];
//    [self setMgLoadError:nil];
}

- (void)removeNoNetwork {
//    [self.mgLoadError removeObserver];
//    [self.mgLoadError removeFromSuperview];
//    [self setMgLoadError:nil];
}

- (void)removeLoadError {
//    [self.mgLoadError removeObserver];
//    [self.mgLoadError removeFromSuperview];
//    [self setMgLoadError:nil];
}

- (void)removeSheet {
    if ([self.mgSheet conformsToProtocol:@protocol(HSheetProtocol)]) {
//        id<HSheetProtocol> sheet = self.mgSheet;
        
    }
}

- (void)removeForm {
    if ([self.mgForm conformsToProtocol:@protocol(HFormProtocol)]) {
//        id<HFormProtocol> form = self.mgForm;

    }
}

- (void)removeToast {
    if ([self.mgToast conformsToProtocol:@protocol(HToastProtocol)]) {
//        id<HToastProtocol> toast = self.mgToast;
    }
}

- (void)removeAlert {
    if ([self.mgAlert conformsToProtocol:@protocol(HAlertProtocol)]) {
//        id<HAlertProtocol> alert = self.mgAlert;

    }
}

@end
