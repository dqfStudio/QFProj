//
//  HShowView.m
//  QFProj
//
//  Created by dqf on 2018/5/31.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HShowView.h"

@implementation HShowView

@end

@interface HToast ()
@property (nonatomic) NSString *qDesc;
@property (nonatomic) NSTimeInterval qDelay;
@property (nonatomic) BOOL setting;
@end

@implementation HToast

- (instancetype)init {
    self = [super init];
    if (self) {
        self.qDelay = 2;
    }
    return self;
}

- (void)setDesc:(NSString *)desc {
    self.qDesc = desc;
}
- (void)setDelay:(NSTimeInterval)delay {
    self.qDelay = delay;
}

- (BOOL)isLoading {
    //是否在设置中
    return self.setting;
}

- (void)start {
    //开始设置
    self.setting = YES;
}

- (void)end {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = self.qDesc;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:self.qDelay];
    //结束设置
    self.setting = NO;
}

@end

@interface HNaviToast ()
@property (nonatomic) NSString *qDesc;
@property (nonatomic) NSString *qIcon;
@property (nonatomic) NSTimeInterval qDelay;
@property (nonatomic) BOOL setting;
@end

@implementation HNaviToast

- (instancetype)init {
    self = [super init];
    if (self) {
        self.qDelay = 2;
    }
    return self;
}

- (void)setDesc:(NSString *)desc {
    self.qDesc = desc;
}
- (void)setIcon:(NSString *)name {
    self.qIcon = name;
}
- (void)setDelay:(NSTimeInterval)delay {
    self.qDelay = delay;
}

- (BOOL)isLoading {
    //是否在设置中
    return self.setting;
}

- (void)start {
    //开始设置
    self.setting = YES;
}

- (void)end {
    UIImage *image = nil;
    if (self.qIcon) image = [UIImage imageNamed:self.qIcon];
    [HNaviToastView showCustomToast:self.qDesc afterDelay:self.qDelay icon:image];
    //结束设置
    self.setting = NO;
}

@end

typedef void (^ButtonBlock)(NSInteger buttonIndex);

@interface HAlert ()
@property (nonatomic, copy) NSString *qDesc;
@property (nonatomic, copy) NSString *qMsg;
@property (nonatomic, copy) NSString *qCancelDesc;
@property (nonatomic, copy) NSArray *qButtonTitles;
@property (nonatomic, copy) ButtonBlock buttonBlock;
@property (nonatomic) BOOL setting;
@end

@implementation HAlert

- (instancetype)init {
    self = [super init];
    if (self) {
        self.qCancelDesc = @"确定";
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.qDesc = title;
}
- (void)setMsg:(NSString *)msg {
    self.qMsg = msg;
}
- (void)setCancelTitle:(NSString *)title {
    self.qCancelDesc = title;
}
- (void)setButtonTitles:(NSArray *)titles {
    self.qButtonTitles = titles;
}
- (void)setCompletionBlock:(void (^)(NSInteger buttonIndex))completionBlock {
    self.buttonBlock = completionBlock;
}

- (BOOL)isLoading {
    //是否在设置中
    return self.setting;
}

- (void)start {
    //开始设置
    self.setting = YES;
}

- (void)end {
    [UIAlertController showAlertWithTitle:self.qDesc message:self.qMsg cancelButtonTitle:self.qCancelDesc otherButtonTitles:self.qButtonTitles completion:^(NSInteger buttonIndex) {
        if (self.buttonBlock) {
            self.buttonBlock(buttonIndex);
        }
    }];
    //结束设置
    self.setting = NO;
}

@end

