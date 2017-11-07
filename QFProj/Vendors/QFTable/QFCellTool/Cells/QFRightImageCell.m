//
//  QFRightImageCell.m
//  MGMobileMusic
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "QFRightImageCell.h"

@implementation QFRightImageCell

- (UIImageView *)rightImage {
    if (!_rightImage) {
        _rightImage = [[UIImageView alloc] init];
        [_rightImage.layer setCornerRadius:25];
        [_rightImage.layer setMasksToBounds:YES];
    }
    return _rightImage;
}

- (void)initUI {
    
    [self addSubview:self.rightImage];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.rightImage setFrame:CGRectMake(CGRectGetWidth(self.frame)-35-50, 15, 50, 50)];
}

@end

