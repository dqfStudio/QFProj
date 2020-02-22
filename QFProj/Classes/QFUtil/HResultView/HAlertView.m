//
//  HAlertView.m
//  QFProj
//
//  Created by dqf on 2018/5/31.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HAlertView.h"

@implementation HToast

@synthesize desc,delay;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delay = 2;
    }
    return self;
}

- (void)wakeup {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    HProgressHUD *hud = [HProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = HProgressHUDModeText;
    hud.labelText = self.desc;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:self.delay];
}

@end

@interface HNaviToast ()
@property (nonatomic) NSString *qDesc;
@property (nonatomic) NSString *qIcon;
@property (nonatomic) NSTimeInterval qDelay;
@property (nonatomic) BOOL setting;
@end

@implementation HNaviToast

@synthesize desc,icon,delay;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delay = 2;
    }
    return self;
}

- (void)wakeup {
    UIImage *image = nil;
    if (self.icon) image = [UIImage imageNamed:self.icon];
    [HNaviToastView showCustomToast:self.desc afterDelay:self.delay icon:image];
}

@end

@implementation HAlert

@synthesize title,msg,cancelTitle;
@synthesize buttonTitles,buttonBlock;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cancelTitle = @"取消";
    }
    return self;
}

- (void)wakeup {
    [UIAlertController showAlertWithTitle:self.title message:self.msg style:UIAlertControllerStyleAlert  cancelButtonTitle:self.cancelTitle otherButtonTitles:self.buttonTitles completion:^(NSInteger buttonIndex) {
        if (self.buttonBlock) {
            self.buttonBlock(buttonIndex);
        }
    }];
}

@end

@implementation HSheet

@synthesize title,msg,cancelTitle;
@synthesize buttonTitles,buttonBlock;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cancelTitle = @"取消";
    }
    return self;
}

- (void)wakeup {
    [UIAlertController showAlertWithTitle:self.title message:self.msg style:UIAlertControllerStyleActionSheet  cancelButtonTitle:self.cancelTitle otherButtonTitles:self.buttonTitles completion:^(NSInteger buttonIndex) {
        if (self.buttonBlock) {
            self.buttonBlock(buttonIndex);
        }
    }];
}

@end

@implementation HForm

@synthesize type,modelArr,rows,rowItems;
@synthesize buttonBlock;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = 0;
    }
    return self;
}

- (void)wakeup {
    switch (self.type) {
        case 0:
            [HFormController formControllerWithModel:self.modelArr numberOfRows:self.rows rowItems:self.rowItems buttonBlock:self.buttonBlock];
            break;
        default:
            break;
    }
}

@end

