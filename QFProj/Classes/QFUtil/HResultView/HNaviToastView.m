//
//  HNaviToastView.m
//  QFProj
//
//  Created by dqf on 2018/5/30.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HNaviToastView.h"
#import "Masonry.h"
#import "UIColor+HUtil.h"
#import "HCommonDefine.h"

@interface HNaviToastView ()
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *icon;
@property (nonatomic) BOOL removeFromSuperViewOnHide;
@end

@implementation HNaviToastView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self addGestures];
        self.removeFromSuperViewOnHide = NO;
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.icon];
    [self refreshUI];
}

- (void)refreshUI {
    if (!self.icon.hidden) {
        [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(10);
            make.bottom.mas_equalTo(self).offset(-14);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.icon);
            make.left.mas_equalTo(self.icon.mas_right).offset(6);
            make.right.mas_equalTo(self).offset(10);
        }];
    }else {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self).offset(10);
            make.bottom.mas_equalTo(self).offset(-10);
        }];
    }
}

- (void)addGestures {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipped)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeGesture];
}

- (void)tapped {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self hide:YES];
}

- (void)swipped {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self hide:YES];
}


- (void)show:(BOOL)animated {
    CGRect frame = self.frame;
    frame.origin.y += frame.size.height;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = frame;
        }];
    }else {
        self.frame = frame;
    }
}

- (void)hide:(BOOL)animated {
    CGRect frame = self.frame;
    frame.origin.y -= frame.size.height;
    if (animated) {
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = frame;
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
            if (self.removeFromSuperViewOnHide) {
                [self removeFromSuperview];
            }
        }];
    }else {
        self.frame = frame;
    }
}

- (void)hideDelayed:(NSNumber *)animated {
    [self hide:[animated boolValue]];
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)interval {
    [self performSelector:@selector(hideDelayed:)
               withObject:[NSNumber numberWithBool:animated]
               afterDelay:interval];
}

#pragma mark --getters&setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithHex:0x5e5e5e];
    }
    return _titleLabel;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _icon;
}

- (void)setIconImage:(UIImage *)iconImage {
    self.icon.image = iconImage;
    self.icon.hidden = !iconImage;
    [self refreshUI];
}

#pragma mark --Class methods
+ (NSArray<HNaviToastView *> *)allToastForView:(UIView *)view {
    NSMutableArray *toastViews = [NSMutableArray array];
    NSArray *subViews = view.subviews;
    for (UIView *aView in subViews) {
        if ([aView isKindOfClass:[self class]]) {
            [toastViews addObject:aView];
        }
    }
    return toastViews;
}
+ (void)hideAllToastForView:(UIView *)view animated:(BOOL)animated {
    NSArray<HNaviToastView *> *toastViews = [self allToastForView:view];
    for (HNaviToastView *toastView in toastViews) {
        toastView.removeFromSuperViewOnHide = YES;
        [toastView hide:animated];
    }
}
+ (instancetype)customToastAddedTo:(UIView *)view animated:(BOOL)animated {
    HNaviToastView *toastView = [self showToastAddedTo:view animated:animated];
    toastView.titleLabel.textColor = [UIColor colorWithHex:0x5e5e5e];
    toastView.backgroundColor = [UIColor whiteColor];
    toastView.icon.image = [UIImage imageNamed:@"mgf_icon_toast_success"];
    toastView.layer.shadowColor = [UIColor blackColor].CGColor;
    toastView.layer.shadowOffset = CGSizeMake(0, 2);
    toastView.layer.shadowRadius = 4;
    toastView.layer.shadowOpacity = 0.1;
    return toastView;
}
+ (instancetype)showToastAddedTo:(UIView *)view animated:(BOOL)animated {
    CGFloat width = view.bounds.size.width;
    HNaviToastView *toastView = [[HNaviToastView alloc] initWithFrame:CGRectMake(0, -UIDevice.topBarHeight, width, UIDevice.topBarHeight)];
    toastView.removeFromSuperViewOnHide = YES;
    [view addSubview:toastView];
    [toastView show:animated];
    return toastView;
}

+ (instancetype)showCustomToast:(NSString *)string afterDelay:(NSTimeInterval)delay icon:(UIImage *)icon {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [HNaviToastView hideAllToastForView:window animated:NO];
    HNaviToastView *toastView = [HNaviToastView customToastAddedTo:window animated:YES];
    toastView.titleLabel.text = string;
    toastView.iconImage = icon;
    [toastView hide:YES afterDelay:delay];
    return toastView;
}

//以下为错误提示框
+ (instancetype)errorToastAddedTo:(UIView *)view animated:(BOOL)animated {
    HNaviToastView *toastView = [self showToastAddedTo:view animated:animated];
    toastView.titleLabel.textColor = [UIColor colorWithHex:0xfb2f2f];
    toastView.backgroundColor = [UIColor colorWithHex:0xfeecec];
    toastView.icon.image = [UIImage imageNamed:@"mgf_icon_toast_error"];
    return toastView;
}

+ (instancetype)showErrorToast:(NSString *)string afterDelay:(NSTimeInterval)delay icon:(UIImage *)icon {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [HNaviToastView hideAllToastForView:window animated:NO];
    HNaviToastView *toastView = [HNaviToastView errorToastAddedTo:window animated:YES];
    toastView.titleLabel.text = string;
    toastView.iconImage = icon;
    [toastView hide:YES afterDelay:delay];
    return toastView;
}

@end
