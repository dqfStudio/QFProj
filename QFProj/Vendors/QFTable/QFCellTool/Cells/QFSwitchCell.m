//
//  QFSwitchCell.m
//  MGMobileMusic
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "QFSwitchCell.h"

@interface QFSwitchCell ()
@property (nonatomic, strong) UISwitch *switchButton;
@end

@implementation QFSwitchCell

- (UISwitch *)switchButton {
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] init];
        [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchButton;
}

- (void)initUI {
    [self addSubview:self.switchButton];
}

- (void)switchAction:(UISwitch *)sender {
    if (self.callback) {
        self.callback(sender);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.switchButton.center = CGPointMake(CGRectGetWidth(self.frame)-CGRectGetWidth(self.switchButton.frame), CGRectGetHeight(self.frame)/2);
}

@end
