//
//  HTupleViewCell.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"

@implementation HTupleLabelCell
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [self addSubview:_label];
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
        [self addSubview:_textView];
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
        [self addSubview:_buttonView];
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
        [self addSubview:_imageView];
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
        [self addSubview:_textField];
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
        [self addSubview:_tupleView];
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
        [self addSubview:_tupleView];
    }
    return _tupleView;
}
- (void)layoutContentView {
    HLayoutTupleCell(self.tupleView)
}
@end

@implementation HTupleUnionCell
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [self addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HLabel *)accessoryLabel {
    if (!_accessoryLabel) {
        _accessoryLabel = [HLabel new];
        [self addSubview:_accessoryLabel];
    }
    return _accessoryLabel;
}
- (HTextView *)textView {
    if (!_textView) {
        _textView = [HTextView new];
        [self addSubview:_textView];
    }
    return _textView;
}
- (HTextView *)detailTextView {
    if (!_detailTextView) {
        _detailTextView = [HTextView new];
        [self addSubview:_detailTextView];
    }
    return _detailTextView;
}
- (HTextView *)accessoryTextView {
    if (!_accessoryTextView) {
        _accessoryTextView = [HTextView new];
        [self addSubview:_accessoryTextView];
    }
    return _accessoryTextView;
}
- (HWebButtonView *)button {
    if (!_button) {
        _button = [HWebButtonView new];
        [self addSubview:_button];
    }
    return _button;
}
- (HWebButtonView *)detailButton {
    if (!_detailButton) {
        _detailButton = [HWebButtonView new];
        [self addSubview:_detailButton];
    }
    return _detailButton;
}
- (HWebButtonView *)accessoryButton {
    if (!_accessoryButton) {
        _accessoryButton = [HWebButtonView new];
        [self addSubview:_accessoryButton];
    }
    return _accessoryButton;
}
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (HWebImageView *)detailImageView {
    if (!_detailImageView) {
        _detailImageView = HWebImageView.new;
        [self addSubview:_detailImageView];
    }
    return _detailImageView;
}
- (HWebImageView *)accessoryImageView {
    if (!_accessoryImageView) {
        _accessoryImageView = HWebImageView.new;
        [self addSubview:_accessoryImageView];
    }
    return _accessoryImageView;
}
- (HTextField *)textField {
    if (!_textField) {
        _textField = HTextField.new;
        [self addSubview:_textField];
    }
    return _textField;
}
- (HTextField *)detailTextField {
    if (!_detailTextField) {
        _detailTextField = HTextField.new;
        [self addSubview:_detailTextField];
    }
    return _detailTextField;
}
- (HTextField *)accessoryTextField {
    if (!_accessoryTextField) {
        _accessoryTextField = HTextField.new;
        [self addSubview:_accessoryTextField];
    }
    return _accessoryTextField;
}
@end

@implementation HTupleViewCell
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (HLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [HLabel new];
        [self addSubview:_textLabel];
    }
    return _textLabel;
}
- (HLabel *)detailTextLabel {
    if (!_detailTextLabel) {
        _detailTextLabel = [HLabel new];
        [self addSubview:_detailTextLabel];
    }
    return _detailTextLabel;
}
- (HLabel *)accessoryLabel {
    if (!_accessoryLabel) {
        _accessoryLabel = [HLabel new];
        [self addSubview:_accessoryLabel];
    }
    return _accessoryLabel;
}
- (HWebImageView *)detailView {
    if (!_detailView) {
        _detailView = [HWebImageView new];
        [self addSubview:_detailView];
    }
    return _detailView;
}
- (HWebImageView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [HWebImageView new];
        [self addSubview:_accessoryView];
    }
    return _accessoryView;
}
@end
