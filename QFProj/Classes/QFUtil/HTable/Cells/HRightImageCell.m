//
//  HRightImageCell.m
//  MGMobileMusic
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HRightImageCell.h"

@interface HRightImageCell ()
@property (nonatomic) CGSize  rightImageSize;
@end

@implementation HRightImageCell

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        [_rightImageView setBackgroundColor:[UIColor clearColor]];
    }
    return _rightImageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGSizeEqualToSize(_rightImageSize, CGSizeZero)) {
        if (self.accessoryType != UITableViewCellAccessoryNone) {
            //调整textLabel的坐标
            CGRect tmpFrame = self.textLabel.frame;
            tmpFrame.size.width -= self.frame.size.width - self.rightImageView.frame.origin.x;
            self.textLabel.frame = tmpFrame;
            
            //调整detailTextLabel的坐标
            tmpFrame = self.detailTextLabel.frame;
            tmpFrame.size.width -= self.frame.size.width - self.rightImageView.frame.origin.x;
            self.detailTextLabel.frame = tmpFrame;
        }
    }
}

- (void)initUI {
    //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setRightImageAttribute {
    if (!CGSizeEqualToSize(_rightImageSize, CGSizeZero)) {
        if (self.accessoryType != UITableViewCellAccessoryNone) {
            [self.rightImageView setFrame:CGRectMake(CGRectGetWidth(self.frame)-35-_rightImageSize.width, self.frame.size.height/2-_rightImageSize.height/2, _rightImageSize.width, _rightImageSize.height)];
            [self addSubview:self.rightImageView];
        }else {
            self.accessoryView = self.rightImageView;
        }
    }
}

- (void)resetRightImageViewSize:(CGSize)size {
    if (!CGSizeEqualToSize(_rightImageSize, size)) {
        _rightImageSize = size;
        CGRect frame = CGRectZero;
        frame.size = size;
        [self.rightImageView setFrame:frame];
        //[self.rightImageView.layer setCornerRadius:size.width/2];
        //[self.rightImageView.layer setMasksToBounds:YES];
        [self setRightImageAttribute];
        [self layoutSubviews];
    }
}

@end

