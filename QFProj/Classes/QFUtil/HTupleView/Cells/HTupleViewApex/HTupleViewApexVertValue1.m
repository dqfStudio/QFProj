//
//  HTupleViewApexVertValue1.m
//  QFProj
//
//  Created by wind on 2019/9/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewApexVertValue1.h"

@implementation HTupleViewApexVertBase1
- (void)initUI {
    self.imageViewInsets = UITBEdgeInsetsZero;
    self.labelInsets =  UITBEdgeInsetsZero;
    self.detailLabelInsets =  UITBEdgeInsetsZero;
    self.accessoryLabelInsets =  UITBEdgeInsetsZero;
}
@end

@implementation HTupleViewApexVertValue1
- (void)layoutContentView {
    HLayoutTupleCell(self.apexContentView)
}
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        self.needRefreshFrame = YES;
        [self.apexContentView addSubview:_imageView];
    }
    return _imageView;
}
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        self.needRefreshFrame = YES;
        [_label setFont:[UIFont systemFontOfSize:14]];
        [self.apexContentView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        self.needRefreshFrame = YES;
        [_detailLabel setFont:[UIFont systemFontOfSize:14]];
        [self.apexContentView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HLabel *)accessoryLabel {
    if (!_accessoryLabel) {
        _accessoryLabel = [HLabel new];
        self.needRefreshFrame = YES;
        [_accessoryLabel setFont:[UIFont systemFontOfSize:14]];
        [self.apexContentView addSubview:_accessoryLabel];
    }
    return _accessoryLabel;
}
- (void)frameChanged {
    CGRect frame = [self getContentBounds];
    
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
