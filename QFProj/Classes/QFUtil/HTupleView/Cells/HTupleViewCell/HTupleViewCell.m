//
//  HTupleViewCell.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"

@implementation HTupleBlankCell
- (UIView *)view {
    if (!_view) {
        _view = [UIView new];
        [self.contentView addSubview:_view];
    }
    return _view;
}
- (void)layoutContentView {
    HLayoutTupleCell(self.view)
}
@end

@implementation HTupleLabelCell
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [self.contentView addSubview:_label];
    }
    return _label;
}
- (void)layoutContentView {
    HLayoutTupleCell(self.label)
}
@end

@implementation HTupleTextCell
- (HTextView *)textView {
    if (!_textView) {
        _textView = [HTextView new];
        [self.contentView addSubview:_textView];
    }
    return _textView;
}
- (void)layoutContentView {
    HLayoutTupleCell(self.textView)
}
@end

@implementation HTupleButtonCell
- (HWebButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [HWebButtonView new];
        [self.contentView addSubview:_buttonView];
    }
    return _buttonView;
}
- (void)layoutContentView {
    HLayoutTupleCell(self.buttonView)
}
@end

@implementation HTupleImageCell
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = [HWebImageView new];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}
- (void)layoutContentView {
    HLayoutTupleCell(self.imageView)
}
@end

@implementation HTupleTextFieldCell
- (HTextField *)textField {
    if (!_textField) {
        _textField = HTextField.new;
        [self.contentView addSubview:_textField];
    }
    return _textField;
}
- (void)layoutContentView {
    HLayoutTupleCell(self.textField)
}
@end

@implementation HTupleVerticalCell
- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds];
        [_tupleView setScrollEnabled:NO];
        [self.contentView addSubview:_tupleView];
    }
    return _tupleView;
}
- (void)layoutContentView {
    HLayoutTupleCell(self.tupleView)
}
@end

@implementation HTupleHorizontalCell
- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds scrollDirection:HTupleViewScrollDirectionHorizontal];
        [_tupleView setScrollEnabled:NO];
        [self.contentView addSubview:_tupleView];
    }
    return _tupleView;
}
- (void)layoutContentView {
    HLayoutTupleCell(self.tupleView)
}
@end

@implementation HTupleViewCell
- (void)layoutContentView {
    HLayoutTupleCell(self.cellContentView)
}
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
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
@end

@implementation HTupleUnionCell
- (void)layoutContentView {
    HLayoutTupleCell(self.cellContentView)
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
- (HTextView *)textView {
    if (!_textView) {
        _textView = [HTextView new];
        [self.cellContentView addSubview:_textView];
    }
    return _textView;
}
- (HTextView *)detailTextView {
    if (!_detailTextView) {
        _detailTextView = [HTextView new];
        [self.cellContentView addSubview:_detailTextView];
    }
    return _detailTextView;
}
- (HTextView *)accessoryTextView {
    if (!_accessoryTextView) {
        _accessoryTextView = [HTextView new];
        [self.cellContentView addSubview:_accessoryTextView];
    }
    return _accessoryTextView;
}
- (HWebButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [HWebButtonView new];
        [self.cellContentView addSubview:_buttonView];
    }
    return _buttonView;
}
- (HWebButtonView *)detailButtonView {
    if (!_detailButtonView) {
        _detailButtonView = [HWebButtonView new];
        [self.cellContentView addSubview:_detailButtonView];
    }
    return _detailButtonView;
}
- (HWebButtonView *)accessoryButtonView {
    if (!_accessoryButtonView) {
        _accessoryButtonView = [HWebButtonView new];
        [self.cellContentView addSubview:_accessoryButtonView];
    }
    return _accessoryButtonView;
}
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        [self.cellContentView addSubview:_imageView];
    }
    return _imageView;
}
- (HWebImageView *)detailImageView {
    if (!_detailImageView) {
        _detailImageView = HWebImageView.new;
        [self.cellContentView addSubview:_detailImageView];
    }
    return _detailImageView;
}
- (HWebImageView *)accessoryImageView {
    if (!_accessoryImageView) {
        _accessoryImageView = HWebImageView.new;
        [self.cellContentView addSubview:_accessoryImageView];
    }
    return _accessoryImageView;
}
- (HTextField *)textField {
    if (!_textField) {
        _textField = HTextField.new;
        [self.cellContentView addSubview:_textField];
    }
    return _textField;
}
- (HTextField *)detailTextField {
    if (!_detailTextField) {
        _detailTextField = HTextField.new;
        [self.cellContentView addSubview:_detailTextField];
    }
    return _detailTextField;
}
- (HTextField *)accessoryTextField {
    if (!_accessoryTextField) {
        _accessoryTextField = HTextField.new;
        [self.cellContentView addSubview:_accessoryTextField];
    }
    return _accessoryTextField;
}
@end
