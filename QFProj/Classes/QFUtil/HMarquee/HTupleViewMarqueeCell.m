//
//  HTupleViewMarqueeCell.m
//  QFProj
//
//  Created by wind on 2020/1/31.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HTupleViewMarqueeCell.h"
#import "HMarquee.h"

#define KCellHeight 40

@interface HTupleViewMarqueeCell ()
@property (nonatomic) HMarquee *marquee;
@end

@implementation HTupleViewMarqueeCell

- (HMarquee *)marquee {
    if (!_marquee) {
        _marquee = [[HMarquee alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, KCellHeight) speed:HMarqueeSpeedLevelMediumSlow Msg:nil];
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
    CGRect frame = self.layoutViewFrame;
    frame.size.height = KCellHeight;
    [self.marquee setFrame:frame];
}

- (void)initUI {
    [self addSubview:self.marquee];
}

@end
