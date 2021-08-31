//
//  HTupleViewMarqueeCell.m
//  QFProj
//
//  Created by dqf on 2020/1/31.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HTupleViewMarqueeCell.h"

@implementation HTupleViewMarqueeCell

- (HMarquee *)marquee {
    if (!_marquee) {
        _marquee = [[HMarquee alloc] initWithFrame:self.bounds speed:HMarqueeSpeedLevelSlow Msg:nil];
        [_marquee changeTapMarqueeAction:^{
            if (self.selectedBlock) {
                self.selectedBlock();
            }
        }];
    }
    return _marquee;
}

// 显示的文字
- (void)setMsg:(NSString *)msg {
    if (_msg != msg) {
        _msg = nil;
        _msg = msg;
        _marquee.msg = msg;
        [self.marquee start];
    }
}

// 背景颜色
- (void)setBgColor:(UIColor *)bgColor {
    if (_bgColor != bgColor) {
        _bgColor = nil;
        _bgColor = bgColor;
        self.marquee.backgroundColor = _bgColor;
    }
}

// 字体颜色
- (void)setTxtColor:(UIColor *)txtColor {
    if (_txtColor != txtColor) {
        _txtColor = nil;
        _txtColor = txtColor;
        self.marquee.txtColor = _txtColor;
    }
}

- (void)relayoutSubviews {
    HLayoutTupleCell(self.marquee)
}

- (void)initUI {
    [self.layoutView addSubview:self.marquee];
}

@end
