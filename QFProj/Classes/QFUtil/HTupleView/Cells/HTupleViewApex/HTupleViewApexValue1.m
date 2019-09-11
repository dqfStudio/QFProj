//
//  HTupleViewApexValue1.m
//  QFProj
//
//  Created by wind on 2019/9/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewApexValue1.h"

@interface HTupleViewApexValue1 ()
@property (nonatomic) UIView *_cellContentView;
@end

@implementation HTupleViewApexValue1
- (void)layoutContentView {
    HLayoutTupleCell(self.cellContentView)
}
- (void)setLeftWidth:(CGFloat)leftWidth {
    if (_leftWidth != leftWidth) {
        _leftWidth = leftWidth;
        [self frameChanged];
    }
}
- (void)setRightWidth:(CGFloat)rightWidth {
    if (_rightWidth != rightWidth) {
        _rightWidth = rightWidth;
        [self frameChanged];
    }
}
- (UIView *)_cellContentView {
    if (!__cellContentView) {
        __cellContentView = UIView.new;
        [self.cellContentView addSubview:__cellContentView];
    }
    return __cellContentView;
}
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        [self frameChanged];
        [self.cellContentView addSubview:_imageView];
    }
    return _imageView;
}
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [self._cellContentView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [self._cellContentView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HLabel *)accessoryLabel {
    if (!_accessoryLabel) {
        _accessoryLabel = [HLabel new];
        [self._cellContentView addSubview:_accessoryLabel];
    }
    return _accessoryLabel;
}
- (HWebImageView *)detailView {
    if (!_detailView) {
        _detailView = [HWebImageView new];
        [self frameChanged];
        [self.cellContentView addSubview:_detailView];
    }
    return _detailView;
}
- (void)frameChanged {
    CGRect frame = [self getContentBounds];
    
    if (_imageView) {
        CGRect tmpFrame = frame;
        tmpFrame.size.width = CGRectGetHeight(tmpFrame);
        [_imageView setFrame:tmpFrame];
    }
    
    if (_detailView) {
        CGRect tmpFrame2 = frame;
        tmpFrame2.size.width = CGRectGetHeight(tmpFrame2);
        tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
        [_detailView setFrame:tmpFrame2];
    }
    
    CGRect tmpFrame3 = frame;
    if (_imageView) {
        tmpFrame3.origin.x = CGRectGetMaxX(_imageView.frame)+10;
    }
    if (_detailView) {
        if (_imageView) {
            tmpFrame3.size.width = CGRectGetMinX(_detailView.frame)-CGRectGetMaxX(_imageView.frame)-10-10;
        }else {
            tmpFrame3.size.width = CGRectGetMinX(_detailView.frame)-10;
        }
    }else {
        if (_imageView) {
            tmpFrame3.size.width = CGRectGetWidth(frame)-CGRectGetMaxX(_imageView.frame)-10;
        }else {
            tmpFrame3.size.width = CGRectGetWidth(frame);
        }
    }
    [self._cellContentView setFrame:tmpFrame3];
    
    CGRect tmpFrame4 = self._cellContentView.bounds;
    
    if (self.leftWidth > 0) {
        CGRect tmpFrame5 = tmpFrame4;
        tmpFrame5.size.width = self.leftWidth;
        [self.detailLabel setFrame:tmpFrame5];
    }
    
    if (self.rightWidth > 0) {
        CGRect tmpFrame6 = tmpFrame4;
        tmpFrame6.origin.x = CGRectGetWidth(tmpFrame4)-self.rightWidth;
        tmpFrame6.size.width = self.rightWidth;
        [self.accessoryLabel setFrame:tmpFrame6];
    }
    
    CGRect tmpFrame7 = tmpFrame4;
    if (self.leftWidth > 0) {
        tmpFrame7.origin.x += CGRectGetMaxX(tmpFrame4)+10;
    }
    tmpFrame7.origin.x = self.leftWidth;
    tmpFrame7.size.width = CGRectGetWidth(tmpFrame4)-self.leftWidth-self.rightWidth;
    [self.label setFrame:tmpFrame7];
}
@end

@interface HTupleViewApexValue2 ()
@property (nonatomic) UIView *_cellContentView;
@property (nonatomic) HWebImageView *accessoryView;
@end

@implementation HTupleViewApexValue2
- (void)layoutContentView {
    HLayoutTupleCell(self.cellContentView)
}
- (void)setLeftWidth:(CGFloat)leftWidth {
    if (_leftWidth != leftWidth) {
        _leftWidth = leftWidth;
        [self frameChanged];
    }
}
- (void)setRightWidth:(CGFloat)rightWidth {
    if (_rightWidth != rightWidth) {
        _rightWidth = rightWidth;
        [self frameChanged];
    }
}
- (UIView *)_cellContentView {
    if (!__cellContentView) {
        __cellContentView = UIView.new;
        [self.cellContentView addSubview:__cellContentView];
    }
    return __cellContentView;
}
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        [self frameChanged];
        [self.cellContentView addSubview:_imageView];
    }
    return _imageView;
}
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [self._cellContentView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [self._cellContentView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HLabel *)accessoryLabel {
    if (!_accessoryLabel) {
        _accessoryLabel = [HLabel new];
        [self._cellContentView addSubview:_accessoryLabel];
    }
    return _accessoryLabel;
}
- (HWebImageView *)detailView {
    if (!_detailView) {
        _detailView = [HWebImageView new];
        [self frameChanged];
        [self.cellContentView addSubview:_detailView];
    }
    return _detailView;
}
- (HWebImageView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [HWebImageView new];
        [self.cellContentView addSubview:_accessoryView];
    }
    return _accessoryView;
}
- (void)frameChanged {
    CGRect frame = [self getContentBounds];
    
    if (_imageView) {
        CGRect tmpFrame = frame;
        tmpFrame.size.width = CGRectGetHeight(tmpFrame);
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
        [_detailView setFrame:tmpFrame3];
    }
    
    CGRect tmpFrame4 = frame;
    if (_imageView) {
        tmpFrame4.origin.x = CGRectGetMaxX(_imageView.frame)+10;
    }
    if (_detailView) {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-CGRectGetMaxX(_imageView.frame)-10-10;
        }else {
            tmpFrame4.size.width = CGRectGetMinX(_detailView.frame)-10;
        }
    }else {
        if (_imageView) {
            tmpFrame4.size.width = CGRectGetMinX(_accessoryView.frame)-CGRectGetMaxX(_imageView.frame)-10-10;
        }else {
            tmpFrame4.size.width = CGRectGetMinX(_accessoryView.frame)-10;
        }
    }
    [self._cellContentView setFrame:tmpFrame4];
    
    CGRect tmpFrame5 = self._cellContentView.bounds;
    
    if (self.leftWidth > 0) {
        CGRect tmpFrame6 = tmpFrame5;
        tmpFrame6.size.width = self.leftWidth;
        [self.detailLabel setFrame:tmpFrame6];
    }
    
    if (self.rightWidth > 0) {
        CGRect tmpFrame7 = tmpFrame5;
        tmpFrame7.origin.x = CGRectGetWidth(tmpFrame5)-self.rightWidth;
        tmpFrame7.size.width = self.rightWidth;
        [self.accessoryLabel setFrame:tmpFrame7];
    }
    
    CGRect tmpFrame8 = tmpFrame5;
    if (self.leftWidth > 0) {
        tmpFrame8.origin.x += CGRectGetMaxX(tmpFrame5)+10;
    }
    tmpFrame8.origin.x = self.leftWidth;
    tmpFrame8.size.width = CGRectGetWidth(tmpFrame5)-self.leftWidth-self.rightWidth;
    [self.label setFrame:tmpFrame8];
}
@end
