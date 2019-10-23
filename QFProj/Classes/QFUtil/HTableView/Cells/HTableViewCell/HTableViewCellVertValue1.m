//
//  HTableViewCellVertValue1.m
//  QFProj
//
//  Created by wind on 2019/9/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTableViewCellVertValue1.h"

@implementation HTableViewCellVertBase1
- (void)initUI {
    self.needRefreshFrame = YES;
    self.imageViewInsets = UITBEdgeInsetsZero;
    self.labelInsets =  UITBEdgeInsetsZero;
    self.detailLabelInsets =  UITBEdgeInsetsZero;
    self.accessoryLabelInsets =  UITBEdgeInsetsZero;
}
@end

@implementation HTableViewCellVertValue1
@synthesize imageView = _imageView;
- (void)updateLayoutView {
    HLayoutTableCell(self.layoutView)
}
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        [self.layoutView addSubview:_imageView];
    }
    return _imageView;
}
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [_label setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [_detailLabel setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HLabel *)accessoryLabel {
    if (!_accessoryLabel) {
        _accessoryLabel = [HLabel new];
        [_accessoryLabel setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_accessoryLabel];
    }
    return _accessoryLabel;
}

- (HWebImageView *)topView {
    if (!_topView) {
        _topView = HWebImageView.new;
        [self.imageView addSubview:_topView];
    }
    return _topView;
}
- (HLabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [HLabel new];
        [_topLabel setBackgroundColor:UIColor.clearColor];
        [_topLabel setFont:[UIFont systemFontOfSize:14]];
        [self.topView addSubview:_topLabel];
    }
    return _topLabel;
}

- (HWebImageView *)bottomView {
    if (!_bottomView) {
        _bottomView = HWebImageView.new;
        [self.imageView addSubview:_bottomView];
    }
    return _bottomView;
}
- (HLabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [HLabel new];
        [_bottomLabel setBackgroundColor:UIColor.clearColor];
        [_bottomLabel setFont:[UIFont systemFontOfSize:14]];
        [self.bottomView addSubview:_bottomLabel];
    }
    return _bottomLabel;
}
- (void)frameChanged {
    CGRect frame = [self layoutViewBounds];
    
    if (_accessoryLabel) {
        CGRect tmpFrame = frame;
        tmpFrame.size.height = self.accessoryHeight;
        tmpFrame.origin.y += self.accessoryLabelInsets.top;
        tmpFrame.size.height -= self.accessoryLabelInsets.top+self.accessoryLabelInsets.bottom;
        [_accessoryLabel setFrame:tmpFrame];
    }
    
    if (_imageView) {
        CGRect tmpFrame = frame;
        tmpFrame.size.height -= self.labelHeight+self.detailHeight+self.accessoryHeight;
        tmpFrame.origin.y += self.accessoryHeight;
        
        tmpFrame.origin.y += self.imageViewInsets.top;
        tmpFrame.size.height -= self.imageViewInsets.top+self.imageViewInsets.bottom;
        [_imageView setFrame:tmpFrame];
        
        if (self.topHeight > 0) {
            CGRect tmpFrame = frame;
            tmpFrame.size.height = self.topHeight;
            [self.topView setFrame:tmpFrame];
            [self.topLabel setFrame:self.topView.bounds];
        }
        
        if (self.bottomHeight > 0) {
            CGRect tmpFrame = frame;
            tmpFrame.origin.y = _imageView.frame.size.height-self.bottomHeight;
            tmpFrame.size.height = self.bottomHeight;
            [self.bottomView setFrame:tmpFrame];
            [self.bottomLabel setFrame:self.bottomView.bounds];
        }
    }
    
    if (_label) {
        CGRect tmpFrame = frame;
        tmpFrame.size.height = self.labelHeight;
        
        tmpFrame.origin.y = frame.size.height-self.labelHeight-self.detailHeight;
        tmpFrame.origin.y += self.labelInsets.top;
        tmpFrame.size.height -= self.labelInsets.top+self.labelInsets.bottom;
        [_label setFrame:tmpFrame];
    }
    
    if (_detailLabel) {
        CGRect tmpFrame = frame;
        tmpFrame.size.height = self.detailHeight;
        
        tmpFrame.origin.y = frame.size.height-self.detailHeight;
        tmpFrame.origin.y += self.detailLabelInsets.top;
        tmpFrame.size.height -= self.detailLabelInsets.top+self.detailLabelInsets.bottom;
        [_detailLabel setFrame:tmpFrame];
    }
}
@end
