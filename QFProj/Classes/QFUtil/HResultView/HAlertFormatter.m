//
//  HAlertFormatter.m
//  QFProj
//
//  Created by Wind on 2021/6/2.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HAlertFormatter.h"

@implementation HWaitingTransition
- (instancetype)init {
    self = [super init];
    if (self) {
        _style = 2;
    }
    return self;
}
@end

@implementation HResultTransition
- (instancetype)init {
    self = [super init];
    if (self) {
        _style = 0;
    }
    return self;
}
@end

@implementation HToastTransition
- (instancetype)init {
    self = [super init];
    if (self) {
        _delay = 2.f;
        _inView = [[UIApplication sharedApplication] keyWindow];
    }
    return self;
}
@end

@implementation HProgressHUD (HAlert)
+ (void)showToast:(void(^)(HToastTransition *make))block {
    @synchronized(self) {
        HToastTransition *make = HToastTransition.new;
        if (block) block(make);
        HProgressHUD *hud = [HProgressHUD showHUDAddedTo:make.inView animated:YES];
        hud.mode = HProgressHUDModeText;
        hud.labelText = make.desc;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:make.delay];
    }
}
@end
