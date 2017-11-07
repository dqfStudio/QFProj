//
//  QFLogoCell.m
//  MGMobileMusic
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "QFLogoCell.h"

@implementation QFLogoCell

- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [[UIImageView alloc] init];
        [_logoView setBackgroundColor:[UIColor clearColor]];
    }
    return _logoView;
}

- (UILabel *)infolabel {
    if (!_infolabel) {
        _infolabel = [[UILabel alloc] init];
        [_infolabel setBackgroundColor:[UIColor clearColor]];
        [_infolabel setTextAlignment:NSTextAlignmentCenter];
        [_infolabel setTextColor:[UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1.0]];
        [_infolabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _infolabel;
}

- (void)initUI {
    [self addSubview:self.logoView];
    [self addSubview:self.infolabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.logoView setFrame:CGRectMake(CGRectGetWidth(self.frame)/2-40, 20, 80, 80)];
    [self.infolabel setFrame:CGRectMake(CGRectGetWidth(self.frame)/2-40, CGRectGetMinY(self.logoView.frame)+CGRectGetHeight(self.logoView.frame), 80, 20)];
}

@end
