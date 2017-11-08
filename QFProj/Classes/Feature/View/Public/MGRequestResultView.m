//
//  MGRequestResultView.m
//  MGMobileMusic
//
//  Created by 喻平 on 2016/12/5.
//  Copyright © 2016年 migu. All rights reserved.
//

#import "MGRequestResultView.h"
#import "QFKit.h"

@interface MGRequestResultView ()

@end

@implementation MGRequestResultView

- (void)setType:(MGRequestResultViewType)type {
    _type = type;
    self.title = nil;
    if (type == MGRequestResultViewTypeNoData) {
        self.activeImageView.image = [UIImage imageNamed:@"icon_load_nothing"];
        self.title = @"这里空空如也~";
    } else if (type == MGRequestResultViewTypeLoadError) {
        self.activeImageView.image = [UIImage imageNamed:@"icon_no_network"];
        self.title = @"加载失败";
    }  else if (type == MGRequestResultViewTypeNoNetwork) {
        self.activeImageView.image = [UIImage imageNamed:@"icon_no_network"];
        self.title = @"网络已断开";
    }
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleLabel.text = title;
}

- (void)updateConstraints {
    [self updateUIConstraints];
    [super updateConstraints];
}

- (void)updateUIConstraints {
    [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.centerY_yy).offset(self.yOffset);
    }];
 
}

- (void)setYOffset:(CGFloat)yOffset {
    _yOffset = yOffset;
    [self setNeedsUpdateConstraints];
}

@end
