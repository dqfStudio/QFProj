//
//  HTupleViewCellDetail.m
//  QFProj
//
//  Created by wind on 2019/9/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCellDetail.h"

@implementation HTupleViewCellDetail
- (void)layoutContentView {
    HLayoutTupleCell(self.cellContentView)
}
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        [self.cellContentView addSubview:_imageView];
        [self frameChanged];
    }
    return _imageView;
}
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [self.cellContentView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [self.cellContentView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HWebImageView *)detailView {
    if (!_detailView) {
        _detailView = [HWebImageView new];
        [self.cellContentView addSubview:_detailView];
        [self frameChanged];
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
        CGRect tmpFrame3 = frame;
        tmpFrame3.size.width = CGRectGetHeight(tmpFrame3);
        tmpFrame3.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame3);
        [_detailView setFrame:tmpFrame3];
    }
    
    CGRect tmpFrame4 = frame;
    tmpFrame4.size.height = CGRectGetHeight(frame)/2;
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
            tmpFrame4.size.width = CGRectGetWidth(frame)-CGRectGetMaxX(_imageView.frame)-10;
        }else {
            tmpFrame4.size.width = CGRectGetWidth(frame);
        }
    }
    [self.label setFrame:tmpFrame4];
    
    CGRect tmpFrame5 = tmpFrame4;
    tmpFrame5.origin.y += CGRectGetMaxY(tmpFrame4);
    [self.detailLabel setFrame:tmpFrame5];
}
@end

@interface HTupleViewCellDetail2 ()
@property (nonatomic) HWebImageView *accessoryView; //右边显示箭头
@end

@implementation HTupleViewCellDetail2
- (void)layoutContentView {
    HLayoutTupleCell(self.cellContentView)
}
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        [self.cellContentView addSubview:_imageView];
        [self frameChanged];
    }
    return _imageView;
}
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [self.cellContentView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [self.cellContentView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HWebImageView *)detailView {
    if (!_detailView) {
        _detailView = [HWebImageView new];
        [self.cellContentView addSubview:_detailView];
        [self frameChanged];
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
    tmpFrame4.size.height = CGRectGetHeight(frame)/2;
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
    [self.label setFrame:tmpFrame4];
    
    CGRect tmpFrame5 = tmpFrame4;
    tmpFrame5.origin.y += CGRectGetMaxY(tmpFrame4);
    [self.detailLabel setFrame:tmpFrame5];
}
@end
