//
//  HTupleViewCellHoriValue1.m
//  QFProj
//
//  Created by wind on 2019/9/10.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCellHoriValue1.h"

#define KArrowSpace 10

@implementation HTupleViewCellHoriBase1
- (void)initUI {
    self.needRefreshFrame = YES;
    self.imageViewInsets = UIEdgeInsetsZero;
    self.labelInterval = 5;
    self.centerAreaInsets = UILREdgeInsetsMake(10, 10);
    self.detailViewInsets = UIEdgeInsetsZero;
}
@end

@implementation HTupleViewCellHoriBase2
- (void)initUI {
    self.needRefreshFrame = YES;
    self.imageViewInsets = UIEdgeInsetsZero;
    self.detailLabelInsets = UILREdgeInsetsZero;
    self.labelInsets = UILREdgeInsetsZero;
    self.accessoryLabelInsets = UILREdgeInsetsZero;
    self.centerAreaInsets = UILREdgeInsetsMake(10, 10);
    self.detailViewInsets = UIEdgeInsetsZero;
}
@end

@implementation HTupleViewCellHoriBase3
- (void)initUI {
    self.needRefreshFrame = YES;
    self.imageViewInsets = UIEdgeInsetsZero;
    self.labelInsets =  UITBEdgeInsetsZero;
    self.detailLabelInsets =  UITBEdgeInsetsZero;
    self.accessoryLabelInsets =  UITBEdgeInsetsZero;
    self.centerAreaInsets = UILREdgeInsetsMake(10, 10);
    self.detailViewInsets = UIEdgeInsetsZero;
}
@end

@interface HTupleViewCellHoriValue1 ()
@property (nonatomic) UIView *containerView;
@property (nonatomic) HWebImageView *accessoryView;
@end

@implementation HTupleViewCellHoriValue1
- (void)layoutContentView {
    HLayoutTupleCell(self.edgeInsetsView)
}
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = UIView.new;
        [self.edgeInsetsView addSubview:_containerView];
    }
    return _containerView;
}
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        [self.edgeInsetsView addSubview:_imageView];
    }
    return _imageView;
}
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [_label setFont:[UIFont systemFontOfSize:14]];
        [self.containerView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [_detailLabel setFont:[UIFont systemFontOfSize:14]];
        [self.containerView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HWebImageView *)detailView {
    if (!_detailView) {
        _detailView = [HWebImageView new];
        [self.edgeInsetsView addSubview:_detailView];
    }
    return _detailView;
}
- (HWebImageView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [HWebImageView new];
        [self.edgeInsetsView addSubview:_accessoryView];
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
    
    CGRect tmpFrame2 = CGRectZero;
    if (self.showAccessoryArrow) {
        tmpFrame2 = CGRectMake(0, 0, 7, 13);
        tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
        tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
        [self.accessoryView setFrame:tmpFrame2];
        [self.accessoryView setImageWithName:@"icon_tuple_arrow_right"];
    }else {
        tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
        tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
    }
    
    if (_detailView) {
        CGRect tmpFrame3 = frame;
        tmpFrame3.size.width = CGRectGetHeight(tmpFrame3);
        if (self.showAccessoryArrow) {
            tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3)-KArrowSpace;
        }else {
            tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3);
        }
        tmpFrame2.origin.x += self.detailViewInsets.left;
        tmpFrame2.origin.y += self.detailViewInsets.top;
        tmpFrame2.size.width -= self.detailViewInsets.left+self.detailViewInsets.right;
        tmpFrame2.size.height -= self.detailViewInsets.top+self.detailViewInsets.bottom;
        [_detailView setFrame:tmpFrame3];
    }
    
    CGRect tmpFrame4 = frame;
    if (_imageView) {
        tmpFrame4.origin.x = CGRectGetMaxX(_imageView.frame)+self.centerAreaInsets.left;
    }
    if (_detailView) {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-CGRectGetMaxX(_imageView.frame)-self.centerAreaInsets.left-self.centerAreaInsets.right;
        }else {
            tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-self.centerAreaInsets.right;
        }
    }else if (_accessoryView) {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetMinX(_accessoryView.frame)-CGRectGetMaxX(_imageView.frame)-KArrowSpace-self.centerAreaInsets.left;
        }else {
            tmpFrame4.size.width = CGRectGetMinX(_accessoryView.frame)-KArrowSpace;
        }
    }else {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetWidth(frame)-CGRectGetMaxX(_imageView.frame)-self.centerAreaInsets.left;
        }else {
            tmpFrame4.size.width = CGRectGetWidth(frame);
        }
    }
    [self.containerView setFrame:tmpFrame4];
    
    if (self.label.text.length > 0 && self.detailLabel.text.length > 0) {
        NSInteger wordWidth = 20; //默认为20
        wordWidth = self.detailLabel.intrinsicContentSize.width/self.detailLabel.text.length;
        if (wordWidth < 20) wordWidth += wordWidth;
        if (self.label.intrinsicContentSize.width >= tmpFrame4.size.width - self.labelInterval - wordWidth) {
            [self.label setFrame:CGRectMake(0, 0, tmpFrame4.size.width, tmpFrame4.size.height)];
            [self.detailLabel setFrame:CGRectZero];
        }else {
            [self.label setFrame:CGRectMake(0, 0, self.label.intrinsicContentSize.width, tmpFrame4.size.height)];
            [self.detailLabel setFrame:CGRectMake(self.label.intrinsicContentSize.width+self.labelInterval, 0,
                                                  tmpFrame4.size.width-self.label.intrinsicContentSize.width-self.labelInterval,
                                                  tmpFrame4.size.height)];
        }
    }else if (self.detailLabel.text.length > 0) {
        [self.detailLabel setFrame:CGRectMake(0, 0, tmpFrame4.size.width, tmpFrame4.size.height)];
        [self.label setFrame:CGRectZero];
    }else {
        [self.label setFrame:CGRectMake(0, 0, tmpFrame4.size.width, tmpFrame4.size.height)];
        [self.detailLabel setFrame:CGRectZero];
    }
}
@end

@interface HTupleViewCellHoriValue2 ()
@property (nonatomic) UIView *containerView;
@property (nonatomic) HWebImageView *accessoryView;
@end

@implementation HTupleViewCellHoriValue2
- (void)layoutContentView {
    HLayoutTupleCell(self.edgeInsetsView)
}
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = UIView.new;
        [self.edgeInsetsView addSubview:_containerView];
    }
    return _containerView;
}
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        [self.edgeInsetsView addSubview:_imageView];
    }
    return _imageView;
}
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [_label setFont:[UIFont systemFontOfSize:14]];
        [self.containerView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [_detailLabel setFont:[UIFont systemFontOfSize:14]];
        [self.containerView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HWebImageView *)detailView {
    if (!_detailView) {
        _detailView = [HWebImageView new];
        [self.edgeInsetsView addSubview:_detailView];
    }
    return _detailView;
}
- (HWebImageView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [HWebImageView new];
        [self.edgeInsetsView addSubview:_accessoryView];
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
    
    CGRect tmpFrame2 = CGRectZero;
    if (self.showAccessoryArrow) {
        tmpFrame2 = CGRectMake(0, 0, 7, 13);
        tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
        tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
        [self.accessoryView setFrame:tmpFrame2];
        [self.accessoryView setImageWithName:@"icon_tuple_arrow_right"];
    }else {
        tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
        tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
    }
    
    if (_detailView) {
        CGRect tmpFrame3 = frame;
        tmpFrame3.size.width = CGRectGetHeight(tmpFrame3);
        if (self.showAccessoryArrow) {
            tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3)-KArrowSpace;
        }else {
            tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3);
        }
        tmpFrame2.origin.x += self.detailViewInsets.left;
        tmpFrame2.origin.y += self.detailViewInsets.top;
        tmpFrame2.size.width -= self.detailViewInsets.left+self.detailViewInsets.right;
        tmpFrame2.size.height -= self.detailViewInsets.top+self.detailViewInsets.bottom;
        [_detailView setFrame:tmpFrame3];
    }
    
    CGRect tmpFrame4 = frame;
    if (_imageView) {
        tmpFrame4.origin.x = CGRectGetMaxX(_imageView.frame)+self.centerAreaInsets.left;
    }
    if (_detailView) {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-CGRectGetMaxX(_imageView.frame)-self.centerAreaInsets.left-self.centerAreaInsets.right;
        }else {
            tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-self.centerAreaInsets.right;
        }
    }else if (_accessoryView) {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetMinX(_accessoryView.frame)-CGRectGetMaxX(_imageView.frame)-KArrowSpace-self.centerAreaInsets.left;
        }else {
            tmpFrame4.size.width = CGRectGetMinX(_accessoryView.frame)-KArrowSpace;
        }
    }else {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetWidth(frame)-CGRectGetMaxX(_imageView.frame)-self.centerAreaInsets.left;
        }else {
            tmpFrame4.size.width = CGRectGetWidth(frame);
        }
    }
    [self.containerView setFrame:tmpFrame4];
    
    if (self.label.text.length > 0 && self.detailLabel.text.length > 0) {
        NSInteger wordWidth = 20; //默认为20
        wordWidth = self.detailLabel.intrinsicContentSize.width/self.detailLabel.text.length;
        if (wordWidth < 20) wordWidth += wordWidth;
        if (self.detailLabel.intrinsicContentSize.width >= tmpFrame4.size.width - self.labelInterval - wordWidth) {
            [self.detailLabel setFrame:CGRectMake(0, 0, tmpFrame4.size.width, tmpFrame4.size.height)];
            [self.label setFrame:CGRectZero];
        }else {
            [self.label setFrame:CGRectMake(0, 0,
                                            tmpFrame4.size.width-self.detailLabel.intrinsicContentSize.width-self.labelInterval,
                                            tmpFrame4.size.height)];
            [self.detailLabel setFrame:CGRectMake(tmpFrame4.size.width-self.detailLabel.intrinsicContentSize.width, 0,
                                                  self.detailLabel.intrinsicContentSize.width,
                                                  tmpFrame4.size.height)];
        }
    }else if (self.detailLabel.text.length > 0) {
        [self.detailLabel setFrame:CGRectMake(0, 0, tmpFrame4.size.width, tmpFrame4.size.height)];
        [self.label setFrame:CGRectZero];
    }else {
        [self.label setFrame:CGRectMake(0, 0, tmpFrame4.size.width, tmpFrame4.size.height)];
        [self.detailLabel setFrame:CGRectZero];
    }
}
@end

@interface HTupleViewCellHoriValue3 ()
@property (nonatomic) UIView *containerView;
@property (nonatomic) HWebImageView *accessoryView;
@end

@implementation HTupleViewCellHoriValue3
- (void)layoutContentView {
    HLayoutTupleCell(self.edgeInsetsView)
}
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = UIView.new;
        [self.edgeInsetsView addSubview:_containerView];
    }
    return _containerView;
}
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        [self.edgeInsetsView addSubview:_imageView];
    }
    return _imageView;
}
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [_label setFont:[UIFont systemFontOfSize:14]];
        [self.containerView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [_detailLabel setFont:[UIFont systemFontOfSize:14]];
        [self.containerView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HLabel *)accessoryLabel {
    if (!_accessoryLabel) {
        _accessoryLabel = [HLabel new];
        [_accessoryLabel setTextAlignment:NSTextAlignmentRight];
        [_accessoryLabel setFont:[UIFont systemFontOfSize:14]];
        [self.containerView addSubview:_accessoryLabel];
    }
    return _accessoryLabel;
}
- (HWebImageView *)detailView {
    if (!_detailView) {
        _detailView = [HWebImageView new];
        [self.edgeInsetsView addSubview:_detailView];
    }
    return _detailView;
}
- (HWebImageView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [HWebImageView new];
        [self.edgeInsetsView addSubview:_accessoryView];
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
    
    CGRect tmpFrame2 = CGRectZero;
    if (self.showAccessoryArrow) {
        tmpFrame2 = CGRectMake(0, 0, 7, 13);
        tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
        tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
        [self.accessoryView setFrame:tmpFrame2];
        [self.accessoryView setImageWithName:@"icon_tuple_arrow_right"];
    }else {
        tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
        tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
    }
    
    if (_detailView) {
        CGRect tmpFrame3 = frame;
        tmpFrame3.size.width = CGRectGetHeight(tmpFrame3);
        if (self.showAccessoryArrow) {
            tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3)-KArrowSpace;
        }else {
            tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3);
        }
        tmpFrame2.origin.x += self.detailViewInsets.left;
        tmpFrame2.origin.y += self.detailViewInsets.top;
        tmpFrame2.size.width -= self.detailViewInsets.left+self.detailViewInsets.right;
        tmpFrame2.size.height -= self.detailViewInsets.top+self.detailViewInsets.bottom;
        [_detailView setFrame:tmpFrame3];
    }
    
    CGRect tmpFrame4 = frame;
    if (_imageView) {
        tmpFrame4.origin.x = CGRectGetMaxX(_imageView.frame)+self.centerAreaInsets.left;
    }
    if (_detailView) {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-CGRectGetMaxX(_imageView.frame)-self.centerAreaInsets.left-self.centerAreaInsets.right;
        }else {
            tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-self.centerAreaInsets.right;
        }
    }else if (_accessoryView) {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetMinX(_accessoryView.frame)-CGRectGetMaxX(_imageView.frame)-KArrowSpace-self.centerAreaInsets.left;
        }else {
            tmpFrame4.size.width = CGRectGetMinX(_accessoryView.frame)-KArrowSpace;
        }
    }else {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetWidth(frame)-CGRectGetMaxX(_imageView.frame)-self.centerAreaInsets.left;
        }else {
            tmpFrame4.size.width = CGRectGetWidth(frame);
        }
    }
    [self.containerView setFrame:tmpFrame4];
    
    CGRect tmpFrame5 = self.containerView.bounds;
    
    if (self.detailWidth > 0) {
        CGRect tmpFrame6 = tmpFrame5;
        tmpFrame6.size.width = self.detailWidth;
        tmpFrame6.origin.x += self.detailLabelInsets.left;
        tmpFrame6.size.width -= self.detailLabelInsets.left+self.detailLabelInsets.right;
        [self.detailLabel setFrame:tmpFrame6];
    }
    
    if (self.accessoryWidth > 0) {
        CGRect tmpFrame7 = tmpFrame5;
        tmpFrame7.origin.x = CGRectGetWidth(tmpFrame5)-self.accessoryWidth;
        tmpFrame7.size.width = self.accessoryWidth;
        tmpFrame7.origin.x += self.accessoryLabelInsets.left;
        tmpFrame7.size.width -= self.accessoryLabelInsets.left+self.accessoryLabelInsets.right;
        [self.accessoryLabel setFrame:tmpFrame7];
    }
    
    CGRect tmpFrame8 = tmpFrame5;
    tmpFrame8.origin.x = self.detailWidth;
    tmpFrame8.size.width = CGRectGetWidth(tmpFrame5)-self.detailWidth-self.accessoryWidth;
    tmpFrame8.origin.x += self.labelInsets.left;
    tmpFrame8.size.width -= self.labelInsets.left+self.labelInsets.right;
    [self.label setFrame:tmpFrame8];
}
@end

@interface HTupleViewCellHoriValue4 ()
@property (nonatomic) HWebImageView *accessoryView;
@end

@implementation HTupleViewCellHoriValue4
- (void)layoutContentView {
    HLayoutTupleCell(self.edgeInsetsView)
}
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        [self.edgeInsetsView addSubview:_imageView];
    }
    return _imageView;
}
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [_label setFont:[UIFont systemFontOfSize:14]];
        [self.edgeInsetsView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [_detailLabel setFont:[UIFont systemFontOfSize:14]];
        [self.edgeInsetsView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HLabel *)accessoryLabel {
    if (!_accessoryLabel) {
        _accessoryLabel = [HLabel new];
        [_accessoryLabel setFont:[UIFont systemFontOfSize:14]];
        [self.edgeInsetsView addSubview:_accessoryLabel];
    }
    return _accessoryLabel;
}
- (HWebImageView *)detailView {
    if (!_detailView) {
        _detailView = [HWebImageView new];
        [self.edgeInsetsView addSubview:_detailView];
    }
    return _detailView;
}
- (HWebImageView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [HWebImageView new];
        [self.edgeInsetsView addSubview:_accessoryView];
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
    
    CGRect tmpFrame2 = CGRectZero;
    if (self.showAccessoryArrow) {
        tmpFrame2 = CGRectMake(0, 0, 7, 13);
        tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
        tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
        [self.accessoryView setFrame:tmpFrame2];
        [self.accessoryView setImageWithName:@"icon_tuple_arrow_right"];
    }else {
        tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
        tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
    }
    
    if (_detailView) {
        CGRect tmpFrame3 = frame;
        tmpFrame3.size.width = CGRectGetHeight(tmpFrame3);
        if (self.showAccessoryArrow) {
            tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3)-KArrowSpace;
        }else {
            tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3);
        }
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
        tmpFrame4.origin.x = CGRectGetMaxX(_imageView.frame)+self.centerAreaInsets.left;
    }
    if (_detailView) {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-CGRectGetMaxX(_imageView.frame)-self.centerAreaInsets.left-self.centerAreaInsets.right;
        }else {
            tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-self.centerAreaInsets.right;
        }
    }else if (_accessoryView) {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetMinX(_accessoryView.frame)-CGRectGetMaxX(_imageView.frame)-KArrowSpace-self.centerAreaInsets.left;
        }else {
            tmpFrame4.size.width = CGRectGetMinX(_accessoryView.frame)-KArrowSpace;
        }
    }else {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetWidth(frame)-CGRectGetMaxX(_imageView.frame)-self.centerAreaInsets.left;
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
