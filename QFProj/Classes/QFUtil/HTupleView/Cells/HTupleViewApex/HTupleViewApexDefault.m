//
//  HTupleViewApexDefault.m
//  QFProj
//
//  Created by wind on 2019/9/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewApexDefault.h"

@implementation HTupleViewApexDefaultBase
- (void)initUI {
    self.imageViewInsets = UIEdgeInsetsZero;
    self.labelInsets =  UITBEdgeInsetsZero;
    self.detailLabelInsets =  UITBEdgeInsetsZero;
    self.accessoryLabelInsets =  UITBEdgeInsetsZero;
    self.centerLabelInsets = UILREdgeInsetsMake(10, 10);
    self.detailViewInsets = UIEdgeInsetsZero;
}
@end

@implementation HTupleViewApexDefault
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
        [_label setBackgroundColor:UIColor.whiteColor];
        [self.apexContentView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [_detailLabel setBackgroundColor:UIColor.whiteColor];
        self.needRefreshFrame = YES;
        [self.apexContentView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HLabel *)accessoryLabel {
    if (!_accessoryLabel) {
        _accessoryLabel = [HLabel new];
        [_accessoryLabel setBackgroundColor:UIColor.whiteColor];
        self.needRefreshFrame = YES;
        [self.apexContentView addSubview:_accessoryLabel];
    }
    return _accessoryLabel;
}
- (HWebImageView *)detailView {
    if (!_detailView) {
        _detailView = [HWebImageView new];
        self.needRefreshFrame = YES;
        [self.apexContentView addSubview:_detailView];
    }
    return _detailView;
}
- (void)frameChanged {
    CGRect frame = [self getContentBounds];
    
    if (_imageView) {
        CGRect tmpFrame = frame;
        tmpFrame.size.width = CGRectGetHeight(tmpFrame);
        tmpFrame.origin.x += self.imageViewInsets.left;
        tmpFrame.origin.y += self.imageViewInsets.top;
        tmpFrame.size.width -= self.imageViewInsets.left+self.imageViewInsets.right;
        tmpFrame.size.height -= self.imageViewInsets.top+self.imageViewInsets.bottom;
        [_imageView setFrame:tmpFrame];
    }
    
    if (_detailView) {
        CGRect tmpFrame3 = frame;
        tmpFrame3.size.width = CGRectGetHeight(tmpFrame3);
        tmpFrame3.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame3);
        tmpFrame3.origin.x += self.detailViewInsets.left;
        tmpFrame3.origin.y += self.detailViewInsets.top;
        tmpFrame3.size.width -= self.detailViewInsets.left+self.detailViewInsets.right;
        tmpFrame3.size.height -= self.detailViewInsets.top+self.detailViewInsets.bottom;
        [_detailView setFrame:tmpFrame3];
    }
    
    CGRect tmpFrame4 = frame;
    if (_detailLabel && _accessoryLabel) {
        tmpFrame4.size.height = CGRectGetHeight(frame)/3;
    }else if (_detailLabel || _accessoryLabel) {
        tmpFrame4.size.height = CGRectGetHeight(frame)/2;
    }else {
        tmpFrame4.size.height = CGRectGetHeight(frame);
    }
    if (_imageView) {
        tmpFrame4.origin.x = CGRectGetMaxX(_imageView.frame)+self.centerLabelInsets.left;
    }
    
    if (_detailView) {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-CGRectGetMaxX(_imageView.frame)-self.centerLabelInsets.left-self.centerLabelInsets.right;
        }else {
            tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-self.centerLabelInsets.right;
        }
    }else {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetWidth(frame)-CGRectGetMaxX(_imageView.frame)-self.centerLabelInsets.left;
        }else {
            tmpFrame4.size.width = CGRectGetWidth(frame);
        }
    }
    CGRect tmpFrame44 = tmpFrame4;
    
    tmpFrame4.origin.y += self.labelInsets.top;
    tmpFrame4.size.height -= self.labelInsets.top+self.labelInsets.bottom;
    [self.label setFrame:tmpFrame4];
    
    if (_detailLabel) {
        CGRect tmpFrame5 = tmpFrame44;
        tmpFrame5.origin.y += CGRectGetHeight(tmpFrame44);
        tmpFrame5.origin.y += self.detailLabelInsets.top;
        tmpFrame5.size.height -= self.detailLabelInsets.top+self.detailLabelInsets.bottom;
        [_detailLabel setFrame:tmpFrame5];
    }
    
    if (_accessoryLabel) {
        CGRect tmpFrame6 = tmpFrame44;
        if (_detailLabel) {
            tmpFrame6.origin.y += CGRectGetHeight(tmpFrame44);
            tmpFrame6.origin.y += CGRectGetHeight(tmpFrame6);
        }else {
            tmpFrame6.origin.y += CGRectGetHeight(tmpFrame44);
        }
        tmpFrame6.origin.y += self.accessoryLabelInsets.top;
        tmpFrame6.size.height -= self.accessoryLabelInsets.top+self.accessoryLabelInsets.bottom;
        [_accessoryLabel setFrame:tmpFrame6];
    }
}
@end

@interface HTupleViewApexDefault2 ()
@property (nonatomic) HWebImageView *accessoryView;
@end

@implementation HTupleViewApexDefault2
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
        [_label setBackgroundColor:UIColor.whiteColor];
        [self.apexContentView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [_detailLabel setBackgroundColor:UIColor.whiteColor];
        self.needRefreshFrame = YES;
        [self.apexContentView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HLabel *)accessoryLabel {
    if (!_accessoryLabel) {
        _accessoryLabel = [HLabel new];
        [_accessoryLabel setBackgroundColor:UIColor.whiteColor];
        self.needRefreshFrame = YES;
        [self.apexContentView addSubview:_accessoryLabel];
    }
    return _accessoryLabel;
}
- (HWebImageView *)detailView {
    if (!_detailView) {
        _detailView = [HWebImageView new];
        self.needRefreshFrame = YES;
        [self.apexContentView addSubview:_detailView];
    }
    return _detailView;
}
- (HWebImageView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [HWebImageView new];
        [self.apexContentView addSubview:_accessoryView];
    }
    return _accessoryView;
}
- (void)frameChanged {
    CGRect frame = [self getContentBounds];
    
    if (_imageView) {
        CGRect tmpFrame = frame;
        tmpFrame.size.width = CGRectGetHeight(tmpFrame);
        tmpFrame.origin.x += self.imageViewInsets.left;
        tmpFrame.origin.y += self.imageViewInsets.top;
        tmpFrame.size.width -= self.imageViewInsets.left+self.imageViewInsets.right;
        tmpFrame.size.height -= self.imageViewInsets.top+self.imageViewInsets.bottom;
        [_imageView setFrame:tmpFrame];
    }
    
    CGRect tmpFrame2 = CGRectMake(0, 0, 10, 18);
    tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
    tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
    [self.accessoryView setFrame:tmpFrame2];
    [self.accessoryView setImageWithName:@"icon_tuple_arrow_right"];
    
    if (_detailView) {
        CGRect tmpFrame3 = frame;
        tmpFrame3.size.width = CGRectGetHeight(tmpFrame3);
        tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3)-10;
        tmpFrame3.origin.x += self.detailViewInsets.left;
        tmpFrame3.origin.y += self.detailViewInsets.top;
        tmpFrame3.size.width -= self.detailViewInsets.left+self.detailViewInsets.right;
        tmpFrame3.size.height -= self.detailViewInsets.top+self.detailViewInsets.bottom;
        [_detailView setFrame:tmpFrame3];
    }
    
    CGRect tmpFrame4 = frame;
    if (_detailLabel && _accessoryLabel) {
        tmpFrame4.size.height = CGRectGetHeight(frame)/3;
    }else if (_detailLabel || _accessoryLabel) {
        tmpFrame4.size.height = CGRectGetHeight(frame)/2;
    }else {
        tmpFrame4.size.height = CGRectGetHeight(frame);
    }
    if (_imageView) {
        tmpFrame4.origin.x = CGRectGetMaxX(_imageView.frame)+self.centerLabelInsets.left;
    }
    if (_detailView) {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-CGRectGetMaxX(_imageView.frame)-self.centerLabelInsets.left-self.centerLabelInsets.right;
        }else {
            tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-self.centerLabelInsets.right;
        }
    }else {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetMinX(_accessoryView.frame)-CGRectGetMaxX(_imageView.frame)-10-self.centerLabelInsets.left;
        }else {
            tmpFrame4.size.width = CGRectGetMinX(_accessoryView.frame)-10;
        }
    }
    CGRect tmpFrame44 = tmpFrame4;
    
    tmpFrame4.origin.y += self.labelInsets.top;
    tmpFrame4.size.height -= self.labelInsets.top+self.labelInsets.bottom;
    [self.label setFrame:tmpFrame4];
    
    if (_detailLabel) {
        CGRect tmpFrame5 = tmpFrame44;
        tmpFrame5.origin.y += CGRectGetHeight(tmpFrame44);
        tmpFrame5.origin.y += self.detailLabelInsets.top;
        tmpFrame5.size.height -= self.detailLabelInsets.top+self.detailLabelInsets.bottom;
        [_detailLabel setFrame:tmpFrame5];
    }
    
    if (_accessoryLabel) {
        CGRect tmpFrame6 = tmpFrame44;
        if (_detailLabel) {
            tmpFrame6.origin.y += CGRectGetHeight(tmpFrame44);
            tmpFrame6.origin.y += CGRectGetHeight(tmpFrame6);
        }else {
            tmpFrame6.origin.y += CGRectGetHeight(tmpFrame44);
        }
        tmpFrame6.origin.y += self.accessoryLabelInsets.top;
        tmpFrame6.size.height -= self.accessoryLabelInsets.top+self.accessoryLabelInsets.bottom;
        [_accessoryLabel setFrame:tmpFrame6];
    }
}
@end
