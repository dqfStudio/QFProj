//
//  HTableViewCellHoriValue1.m
//  QFProj
//
//  Created by wind on 2019/9/10.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTableViewCellHoriValue1.h"

#define KArrowSpace 10

@implementation HTableViewCellHoriBase1
- (void)initUI {
    self.imageViewInsets = UIEdgeInsetsZero;
    self.labelInterval = 5;
    self.centralInsets = UILREdgeInsetsMake(10, 10);
    self.detailViewInsets = UIEdgeInsetsZero;
}
@end

@implementation HTableViewCellHoriBase2
- (void)initUI {
    self.imageViewInsets = UIEdgeInsetsZero;
    self.detailLabelInsets = UILREdgeInsetsZero;
    self.labelInsets = UILREdgeInsetsZero;
    self.accessoryLabelInsets = UILREdgeInsetsZero;
    self.centralInsets = UILREdgeInsetsMake(10, 10);
    self.detailViewInsets = UIEdgeInsetsZero;
}
@end

@implementation HTableViewCellHoriBase3
- (void)initUI {
    self.imageViewInsets = UIEdgeInsetsZero;
    self.labelInsets =  UITBEdgeInsetsZero;
    self.detailLabelInsets =  UITBEdgeInsetsZero;
    self.accessoryLabelInsets =  UITBEdgeInsetsZero;
    self.centralInsets = UILREdgeInsetsMake(10, 10);
    self.detailViewInsets = UIEdgeInsetsZero;
}
@end

@interface HTableViewCellHoriValue1 ()
@property (nonatomic) UIView *centralLayoutView;
@property (nonatomic) HWebImageView *accessoryView;
@end

@implementation HTableViewCellHoriValue1
@synthesize imageView = _imageView;
@synthesize accessoryView = _accessoryView;
- (void)relayoutSubviews {
    [self updateSubViews];
}
- (UIView *)centralLayoutView {
    if (!_centralLayoutView) {
        _centralLayoutView = UIView.new;
        [self.layoutView addSubview:_centralLayoutView];
    }
    return _centralLayoutView;
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
        [self.centralLayoutView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [_detailLabel setFont:[UIFont systemFontOfSize:14]];
        [self.centralLayoutView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HWebImageView *)detailView {
    if (!_detailView) {
        _detailView = [HWebImageView new];
        [self.layoutView addSubview:_detailView];
    }
    return _detailView;
}
- (HWebImageView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [HWebImageView new];
        [_accessoryView setImageWithName:@"icon_tuple_arrow_right"];
        [self.layoutView addSubview:_accessoryView];
    }
    return _accessoryView;
}
- (void)updateSubViews {
    CGRect frame = [self layoutViewBounds];
    CGRect tmpFrame1 = frame;
    CGRect tmpFrame2 = CGRectZero;
    CGRect tmpFrame3 = frame;
    CGRect tmpFrame4 = frame;
    
    //计算imageView的坐标
    if (_imageView) {
        tmpFrame1.size.width = CGRectGetHeight(tmpFrame1); //默认宽高相等
        tmpFrame1.origin.x += self.imageViewInsets.left;
        tmpFrame1.origin.y += self.imageViewInsets.top;
        tmpFrame1.size.width -= self.imageViewInsets.left+self.imageViewInsets.right;
        tmpFrame1.size.height -= self.imageViewInsets.top+self.imageViewInsets.bottom;
        [_imageView setFrame:tmpFrame1];
        //计算tmpFrame4的x坐标
        tmpFrame4.origin.x = CGRectGetMaxX(_imageView.frame)+self.centralInsets.left;
    }
    
    //计算accessoryView的坐标
    if (self.showAccessoryArrow) tmpFrame2 = CGRectMake(0, 0, 7, 13);
    tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
    tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
    if (self.showAccessoryArrow) [self.accessoryView setFrame:tmpFrame2];
    
    //计算detailView的坐标
    if (_detailView) {
        tmpFrame3.size.width = CGRectGetHeight(tmpFrame3); //默认宽高相等
        tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3);
        if (self.showAccessoryArrow) tmpFrame3.origin.x -= KArrowSpace;
        
        tmpFrame2.origin.x += self.detailViewInsets.left;
        tmpFrame2.origin.y += self.detailViewInsets.top;
        tmpFrame2.size.width -= self.detailViewInsets.left+self.detailViewInsets.right;
        tmpFrame2.size.height -= self.detailViewInsets.top+self.detailViewInsets.bottom;
        [_detailView setFrame:tmpFrame3];
    }
    
    //计算centralLayoutView的宽度
    if (_detailView) {
        tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-tmpFrame4.origin.x-self.centralInsets.right;
    }else if (_accessoryView) {
        tmpFrame4.size.width = CGRectGetMinX(_accessoryView.frame)-tmpFrame4.origin.x-KArrowSpace;
    }else {
        tmpFrame4.size.width = CGRectGetWidth(frame)-tmpFrame4.origin.x;
    }
    
    //计算centralLayoutView的坐标
    [self.centralLayoutView setFrame:tmpFrame4];
    
    //计算label和detailLabel的坐标
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

@interface HTableViewCellHoriValue2 ()
@property (nonatomic) UIView *centralLayoutView;
@property (nonatomic) HWebImageView *accessoryView;
@end

@implementation HTableViewCellHoriValue2
@synthesize imageView = _imageView;
@synthesize accessoryView = _accessoryView;
- (void)relayoutSubviews {
    [self updateSubViews];
}
- (UIView *)centralLayoutView {
    if (!_centralLayoutView) {
        _centralLayoutView = UIView.new;
        [self.layoutView addSubview:_centralLayoutView];
    }
    return _centralLayoutView;
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
        [self.centralLayoutView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [_detailLabel setFont:[UIFont systemFontOfSize:14]];
        [self.centralLayoutView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HWebImageView *)detailView {
    if (!_detailView) {
        _detailView = [HWebImageView new];
        [self.layoutView addSubview:_detailView];
    }
    return _detailView;
}
- (HWebImageView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [HWebImageView new];
        [_accessoryView setImageWithName:@"icon_tuple_arrow_right"];
        [self.layoutView addSubview:_accessoryView];
    }
    return _accessoryView;
}
- (void)updateSubViews {
    CGRect frame = [self layoutViewBounds];
    CGRect tmpFrame1 = frame;
    CGRect tmpFrame2 = CGRectZero;
    CGRect tmpFrame3 = frame;
    CGRect tmpFrame4 = frame;
    
    //计算imageView的坐标
    if (_imageView) {
        tmpFrame1.size.width = CGRectGetHeight(tmpFrame1); //默认宽高相等
        tmpFrame1.origin.x += self.imageViewInsets.left;
        tmpFrame1.origin.y += self.imageViewInsets.top;
        tmpFrame1.size.width -= self.imageViewInsets.left+self.imageViewInsets.right;
        tmpFrame1.size.height -= self.imageViewInsets.top+self.imageViewInsets.bottom;
        [_imageView setFrame:tmpFrame1];
        //计算tmpFrame4的x坐标
        tmpFrame4.origin.x = CGRectGetMaxX(_imageView.frame)+self.centralInsets.left;
    }
    
    //计算accessoryView的坐标
    if (self.showAccessoryArrow) tmpFrame2 = CGRectMake(0, 0, 7, 13);
    tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
    tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
    if (self.showAccessoryArrow) [self.accessoryView setFrame:tmpFrame2];
    
    //计算detailView的坐标
    if (_detailView) {
        tmpFrame3.size.width = CGRectGetHeight(tmpFrame3); //默认宽高相等
        tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3);
        if (self.showAccessoryArrow) tmpFrame3.origin.x -= KArrowSpace;
        
        tmpFrame2.origin.x += self.detailViewInsets.left;
        tmpFrame2.origin.y += self.detailViewInsets.top;
        tmpFrame2.size.width -= self.detailViewInsets.left+self.detailViewInsets.right;
        tmpFrame2.size.height -= self.detailViewInsets.top+self.detailViewInsets.bottom;
        [_detailView setFrame:tmpFrame3];
    }
    
    //计算centralLayoutView的宽度
    if (_detailView) {
        tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-tmpFrame4.origin.x-self.centralInsets.right;
    }else if (_accessoryView) {
        tmpFrame4.size.width = CGRectGetMinX(_accessoryView.frame)-tmpFrame4.origin.x-KArrowSpace;
    }else {
        tmpFrame4.size.width = CGRectGetWidth(frame)-tmpFrame4.origin.x;
    }
    
    //计算centralLayoutView的坐标
    [self.centralLayoutView setFrame:tmpFrame4];
    
    //计算label和detailLabel的坐标
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

@interface HTableViewCellHoriValue3 ()
@property (nonatomic) UIView *centralLayoutView;
@property (nonatomic) HWebImageView *accessoryView;
@end

@implementation HTableViewCellHoriValue3
@synthesize imageView = _imageView;
@synthesize accessoryView = _accessoryView;
- (void)relayoutSubviews {
    [self updateSubViews];
}
- (UIView *)centralLayoutView {
    if (!_centralLayoutView) {
        _centralLayoutView = UIView.new;
        [self.layoutView addSubview:_centralLayoutView];
    }
    return _centralLayoutView;
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
        [self.centralLayoutView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [_detailLabel setFont:[UIFont systemFontOfSize:14]];
        [self.centralLayoutView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HLabel *)accessoryLabel {
    if (!_accessoryLabel) {
        _accessoryLabel = [HLabel new];
        [_accessoryLabel setTextAlignment:NSTextAlignmentRight];
        [_accessoryLabel setFont:[UIFont systemFontOfSize:14]];
        [self.centralLayoutView addSubview:_accessoryLabel];
    }
    return _accessoryLabel;
}
- (HWebImageView *)detailView {
    if (!_detailView) {
        _detailView = [HWebImageView new];
        [self.layoutView addSubview:_detailView];
    }
    return _detailView;
}
- (HWebImageView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [HWebImageView new];
        [_accessoryView setImageWithName:@"icon_tuple_arrow_right"];
        [self.layoutView addSubview:_accessoryView];
    }
    return _accessoryView;
}
- (void)updateSubViews {
    CGRect frame = [self layoutViewBounds];
    CGRect tmpFrame1 = frame;
    CGRect tmpFrame2 = CGRectZero;
    CGRect tmpFrame3 = frame;
    CGRect tmpFrame4 = frame;
    
    //计算imageView的坐标
    if (_imageView) {
        tmpFrame1.size.width = CGRectGetHeight(tmpFrame1); //默认宽高相等
        tmpFrame1.origin.x += self.imageViewInsets.left;
        tmpFrame1.origin.y += self.imageViewInsets.top;
        tmpFrame1.size.width -= self.imageViewInsets.left+self.imageViewInsets.right;
        tmpFrame1.size.height -= self.imageViewInsets.top+self.imageViewInsets.bottom;
        [_imageView setFrame:tmpFrame1];
        //计算tmpFrame4的x坐标
        tmpFrame4.origin.x = CGRectGetMaxX(_imageView.frame)+self.centralInsets.left;
    }
    
    //计算accessoryView的坐标
    if (self.showAccessoryArrow) tmpFrame2 = CGRectMake(0, 0, 7, 13);
    tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
    tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
    if (self.showAccessoryArrow) [self.accessoryView setFrame:tmpFrame2];
    
    //计算detailView的坐标
    if (_detailView) {
        tmpFrame3.size.width = CGRectGetHeight(tmpFrame3); //默认宽高相等
        tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3);
        if (self.showAccessoryArrow) tmpFrame3.origin.x -= KArrowSpace;
        
        tmpFrame2.origin.x += self.detailViewInsets.left;
        tmpFrame2.origin.y += self.detailViewInsets.top;
        tmpFrame2.size.width -= self.detailViewInsets.left+self.detailViewInsets.right;
        tmpFrame2.size.height -= self.detailViewInsets.top+self.detailViewInsets.bottom;
        [_detailView setFrame:tmpFrame3];
    }
    
    //计算centralLayoutView的宽度
    if (_detailView) {
        tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-tmpFrame4.origin.x-self.centralInsets.right;
    }else if (_accessoryView) {
        tmpFrame4.size.width = CGRectGetMinX(_accessoryView.frame)-tmpFrame4.origin.x-KArrowSpace;
    }else {
        tmpFrame4.size.width = CGRectGetWidth(frame)-tmpFrame4.origin.x;
    }
    
    //计算centralLayoutView的坐标
    [self.centralLayoutView setFrame:tmpFrame4];
    
    //保存centralLayoutView的值
    CGRect tmpFrame5 = self.centralLayoutView.bounds;
    
    //计算detailLabel的坐标
    if (self.detailWidth > 0) {
        CGRect tmpFrame6 = tmpFrame5;
        tmpFrame6.size.width = self.detailWidth;
        tmpFrame6.origin.x += self.detailLabelInsets.left;
        tmpFrame6.size.width -= self.detailLabelInsets.left+self.detailLabelInsets.right;
        [self.detailLabel setFrame:tmpFrame6];
    }
    
    //计算accessoryLabel的坐标
    if (self.accessoryWidth > 0) {
        CGRect tmpFrame7 = tmpFrame5;
        tmpFrame7.origin.x = CGRectGetWidth(tmpFrame5)-self.accessoryWidth;
        tmpFrame7.size.width = self.accessoryWidth;
        tmpFrame7.origin.x += self.accessoryLabelInsets.left;
        tmpFrame7.size.width -= self.accessoryLabelInsets.left+self.accessoryLabelInsets.right;
        [self.accessoryLabel setFrame:tmpFrame7];
    }
    
    //计算label的坐标
    CGRect tmpFrame8 = tmpFrame5;
    tmpFrame8.origin.x = self.detailWidth;
    tmpFrame8.size.width = CGRectGetWidth(tmpFrame5)-self.detailWidth-self.accessoryWidth;
    tmpFrame8.origin.x += self.labelInsets.left;
    tmpFrame8.size.width -= self.labelInsets.left+self.labelInsets.right;
    [self.label setFrame:tmpFrame8];
}
@end

@interface HTableViewCellHoriValue4 ()
@property (nonatomic) HWebImageView *accessoryView;
@end

@implementation HTableViewCellHoriValue4
@synthesize imageView = _imageView;
@synthesize accessoryView = _accessoryView;
- (void)relayoutSubviews {
    [self updateSubViews];
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
- (HWebImageView *)detailView {
    if (!_detailView) {
        _detailView = [HWebImageView new];
        [self.layoutView addSubview:_detailView];
    }
    return _detailView;
}
- (HWebImageView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [HWebImageView new];
        [_accessoryView setImageWithName:@"icon_tuple_arrow_right"];
        [self.layoutView addSubview:_accessoryView];
    }
    return _accessoryView;
}
- (void)updateSubViews {
    CGRect frame = [self layoutViewBounds];
    CGRect tmpFrame1 = frame;
    CGRect tmpFrame2 = CGRectZero;
    CGRect tmpFrame3 = frame;
    CGRect tmpFrame4 = frame;
    
    //计算imageView的坐标
    if (_imageView) {
        tmpFrame1.size.width = CGRectGetHeight(tmpFrame1); //默认宽高相等
        tmpFrame1.origin.x += self.imageViewInsets.left;
        tmpFrame1.origin.y += self.imageViewInsets.top;
        tmpFrame1.size.width -= self.imageViewInsets.left+self.imageViewInsets.right;
        tmpFrame1.size.height -= self.imageViewInsets.top+self.imageViewInsets.bottom;
        [_imageView setFrame:tmpFrame1];
        //计算tmpFrame4的x坐标
        tmpFrame4.origin.x = CGRectGetMaxX(_imageView.frame)+self.centralInsets.left;
    }
    
    //计算accessoryView的坐标
    if (self.showAccessoryArrow) tmpFrame2 = CGRectMake(0, 0, 7, 13);
    tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
    tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
    if (self.showAccessoryArrow) [self.accessoryView setFrame:tmpFrame2];
    
    //计算detailView的坐标
    if (_detailView) {
        tmpFrame3.size.width = CGRectGetHeight(tmpFrame3); //默认宽高相等
        tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3);
        if (self.showAccessoryArrow) tmpFrame3.origin.x -= KArrowSpace;

        tmpFrame3.origin.x += self.detailViewInsets.left;
        tmpFrame3.origin.y += self.detailViewInsets.top;
        tmpFrame3.size.width -= self.detailViewInsets.left+self.detailViewInsets.right;
        tmpFrame3.size.height -= self.detailViewInsets.top+self.detailViewInsets.bottom;
        [_detailView setFrame:tmpFrame3];
    }
    
    //计算label的宽度
    if (_detailView) {
        tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-tmpFrame4.origin.x-self.centralInsets.right;
    }else if (_accessoryView) {
        tmpFrame4.size.width = CGRectGetMinX(_accessoryView.frame)-tmpFrame4.origin.x-KArrowSpace;
    }else {
        tmpFrame4.size.width = CGRectGetWidth(frame)-tmpFrame4.origin.x;
    }
    
    //计算label的高度
    if (_detailLabel && _accessoryLabel) {
        tmpFrame4.size.height = CGRectGetHeight(frame)/3;
    }else if (_detailLabel || _accessoryLabel) {
        tmpFrame4.size.height = CGRectGetHeight(frame)/2;
    }else {
        tmpFrame4.size.height = CGRectGetHeight(frame);
    }
    
    //保存tmpFrame4的值
    CGRect tmpFrame5 = tmpFrame4;
    
    //计算label的坐标
    tmpFrame4.origin.y += self.labelInsets.top;
    tmpFrame4.size.height -= self.labelInsets.top+self.labelInsets.bottom;
    [self.label setFrame:tmpFrame4];
    
    //计算detailLabel的坐标
    if (_detailLabel) {
        CGRect tmpFrame6 = tmpFrame5;
        tmpFrame6.origin.y += CGRectGetHeight(tmpFrame5);
        tmpFrame6.origin.y += self.detailLabelInsets.top;
        tmpFrame6.size.height -= self.detailLabelInsets.top+self.detailLabelInsets.bottom;
        [_detailLabel setFrame:tmpFrame6];
    }
    
    //计算accessoryLabel的坐标
    if (_accessoryLabel) {
        CGRect tmpFrame7 = tmpFrame5;
        tmpFrame7.origin.y += CGRectGetHeight(tmpFrame5);
        if (_detailLabel) tmpFrame7.origin.y += CGRectGetHeight(tmpFrame7);
        
        tmpFrame7.origin.y += self.accessoryLabelInsets.top;
        tmpFrame7.size.height -= self.accessoryLabelInsets.top+self.accessoryLabelInsets.bottom;
        [_accessoryLabel setFrame:tmpFrame7];
    }
}
@end
