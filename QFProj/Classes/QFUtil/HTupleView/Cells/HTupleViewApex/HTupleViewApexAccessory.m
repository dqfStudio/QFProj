//
//  HTupleViewApexAccessory.m
//  QFProj
//
//  Created by wind on 2019/9/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewApexAccessory.h"

@implementation HTupleViewApexAccessory
- (void)layoutContentView {
    HLayoutTupleCell(self.cellContentView)
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
- (HLabel *)accessoryLabel {
    if (!_accessoryLabel) {
        _accessoryLabel = [HLabel new];
        [self.cellContentView addSubview:_accessoryLabel];
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
        CGRect tmpFrame3 = frame;
        tmpFrame3.size.width = CGRectGetHeight(tmpFrame3);
        tmpFrame3.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame3);
        [_detailView setFrame:tmpFrame3];
    }
    
    CGRect tmpFrame4 = frame;
    tmpFrame4.size.height = CGRectGetHeight(frame)/3;
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
    
    CGRect tmpFrame6 = tmpFrame5;
    tmpFrame6.origin.y += CGRectGetMaxY(tmpFrame4);
    [self.accessoryLabel setFrame:tmpFrame6];
}
@end

@interface HTupleViewApexAccessory2 ()
@property (nonatomic) HWebImageView *accessoryView;
@end

@implementation HTupleViewApexAccessory2
- (void)layoutContentView {
    HLayoutTupleCell(self.cellContentView)
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
- (HLabel *)accessoryLabel {
    if (!_accessoryLabel) {
        _accessoryLabel = [HLabel new];
        [self.cellContentView addSubview:_accessoryLabel];
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
    tmpFrame4.size.height = CGRectGetHeight(frame)/3;
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
    
    CGRect tmpFrame6 = tmpFrame5;
    tmpFrame6.origin.y += CGRectGetMaxY(tmpFrame4);
    [self.accessoryLabel setFrame:tmpFrame6];
}
@end
