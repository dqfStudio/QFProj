//
//  QFCustomCell.m
//  QFTableProject
//
//  Created by dqf on 2017/9/21.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "QFCustomCell.h"

@implementation QFCustomCell

- (void)initUI {
    _m_frame = CGRectZero;
}

- (void)setM_frame:(CGRect)m_frame {
    _m_frame = m_frame;
    [self layoutSubviews];
}

- (void)setM_backgroundColor:(UIColor *)m_backgroundColor {
    _m_backgroundColor = m_backgroundColor;
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (![NSStringFromCGRect(_m_frame) isEqualToString:NSStringFromCGRect(CGRectZero)]) {
        self.textLabel.frame = _m_frame;
    }
    if (_m_backgroundColor) {
        [self.textLabel setBackgroundColor:_m_backgroundColor];
    }
}

@end
