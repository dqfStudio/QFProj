//
//  MGWaitingView.m
//  MGMobileMusic
//
//  Created by 喻平 on 2016/11/28.
//  Copyright © 2016年 migu. All rights reserved.
//

#import "MGWaitingView.h"
#import "QFKit.h"

@interface MGWaitingView ()

@end

@implementation MGWaitingView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateConstraints {
    [self updateUIConstraints];
    [super updateConstraints];
}

- (void)updateUIConstraints {
    if (self.style == MGWaitingViewStyleGray) {
        [self.grayLoadingView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.centerY_yy).offset(self.yOffset);
        }];
    }else {
        [self.whiteLoadingImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.centerY_yy).offset(self.yOffset);
        }];
    }
}

- (void)setYOffset:(CGFloat)yOffset {
    _yOffset = yOffset;
    [self setNeedsUpdateConstraints];
}


- (void)setStyle:(MGWaitingViewStyle)style {
    _style = style;
    if (style == MGWaitingViewStyleGray) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2f];
        if (self.grayLoadingImageView.animationImages.count == 0) {
            NSMutableArray *images = [NSMutableArray array];
            for (int i = 1; i <= 8; i++) {
                NSString *imageName = [NSString stringWithFormat:@"up_loading0%d", i];
                [images addObject:[UIImage imageNamed:imageName]];
            }
            self.grayLoadingImageView.animationImages = images;
            self.grayLoadingImageView.animationDuration = 1.0f;
        }
        self.grayLoadingView.hidden = NO;
        [self.grayLoadingImageView startAnimating];
        
        self.whiteLoadingImageView.hidden = YES;
        [self.whiteLoadingImageView stopAnimating];
    } else if (style == MGWaitingViewStyleWhite) {
        self.backgroundColor = [UIColor whiteColor];
        if (self.whiteLoadingImageView.animationImages.count == 0) {
            NSMutableArray *images = [NSMutableArray array];
            for (int i = 1; i <= 6; i++) {
                NSString *imageName = [NSString stringWithFormat:@"loading0%d", i];
                [images addObject:[UIImage imageNamed:imageName]];
            }
            self.whiteLoadingImageView.animationImages = images;
            self.whiteLoadingImageView.animationDuration = 1.0f;
        }
        self.whiteLoadingImageView.hidden = NO;
        [self.whiteLoadingImageView startAnimating];
        
        self.grayLoadingView.hidden = YES;
        [self.grayLoadingImageView stopAnimating];
    }
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.grayLoadingLabel.text = text.length == 0 ? @"请稍候..." : text;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    NSLog(@"willMoveToSuperview");
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    NSLog(@"willMoveToWindow");
}

@end
