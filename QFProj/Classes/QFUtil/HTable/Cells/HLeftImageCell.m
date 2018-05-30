//
//  HLeftImageCell.m
//  MGMobileMusic
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HLeftImageCell.h"

UIKIT_STATIC_INLINE CGFloat HCellEdgeWidth(HCellEdgeInsets edge) {
    return edge.left + edge.width + edge.right;
}

@implementation HLeftImageCell

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.backgroundColor = [UIColor clearColor];
    }
    return _leftImageView;
}

- (void)setLeftImageEdgeInsets:(HCellEdgeInsets)leftImageEdgeInsets {
    if (!HCellEdgeEqualToEdge(_leftImageEdgeInsets, leftImageEdgeInsets)) {
        _leftImageEdgeInsets = leftImageEdgeInsets;
        CGRect frame = CGRectZero;
        frame.size.width = leftImageEdgeInsets.width;
        frame.size.height = leftImageEdgeInsets.height;
        [self.imageView setFrame:frame];
        [self.leftImageView setFrame:frame];
        [self layoutSubviews];
    }
}

- (void)setFilletedCorner:(BOOL)filletedCorner {
    if (_filletedCorner != filletedCorner) {
        _filletedCorner = filletedCorner;
        [self layoutSubviews];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.leftImageView) {

        //调整leftImageView的坐标
        CGRect tmpFrame = self.imageView.frame;
        tmpFrame.origin.x = self.leftImageEdgeInsets.left;
        tmpFrame.origin.y = self.frame.size.height/2-tmpFrame.size.height/2;
        if (!CGRectEqualToRect(self.leftImageView.frame, tmpFrame)) {
            self.leftImageView.frame = tmpFrame;
        }
        
        //设置leftImageView为圆角
        if (self.filletedCorner) {
            self.leftImageView.layer.masksToBounds = YES;
            self.leftImageView.layer.cornerRadius = self.leftImageView.frame.size.width/2;
        }
        
        //隐藏系统的imageView
        [self.imageView setImage:nil];
        [self.imageView setHidden:YES];
        
        //调整textLabel的坐标
        tmpFrame = self.textLabel.frame;
        tmpFrame.origin.x = HCellEdgeWidth(self.leftImageEdgeInsets);
        if (!CGRectEqualToRect(self.textLabel.frame, tmpFrame)) {
            self.textLabel.frame = tmpFrame;
        }
        
        //调整detailTextLabel的坐标
        tmpFrame = self.detailTextLabel.frame;
        tmpFrame.origin.x = HCellEdgeWidth(self.leftImageEdgeInsets);
        if (!CGRectEqualToRect(self.detailTextLabel.frame, tmpFrame)) {
            self.detailTextLabel.frame = tmpFrame;
        }
    }
}

- (void)initUI {
    [self addSubview:self.leftImageView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end

