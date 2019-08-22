//
//  HTupleViewApex.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleViewApex.h"

@implementation HTupleLabelView
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [self addSubview:_label];
    }
    return _label;
}
- (void)layoutContentView {
    HLayoutTupleApex(self.label)
}
@end

@implementation HTupleTextView
- (HTextView *)textView {
    if (!_textView) {
        _textView = [HTextView new];
        [self addSubview:_textView];
    }
    return _textView;
}
- (void)layoutContentView {
    HLayoutTupleApex(self.textView)
}
@end

@implementation HTupleButtonView
- (HWebButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [HWebButtonView new];
        [self addSubview:_buttonView];
    }
    return _buttonView;
}
- (void)layoutContentView {
    HLayoutTupleApex(self.buttonView)
}
@end

@implementation HTupleImageView
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = [HWebImageView new];
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (void)layoutContentView {
    HLayoutTupleApex(self.imageView)
}
@end

@implementation HTupleTextFieldView
- (HTextField *)textField {
    if (!_textField) {
        _textField = HTextField.new;
        [self addSubview:_textField];
    }
    return _textField;
}
- (void)layoutContentView {
    HLayoutTupleApex(self.textField)
}
@end

@implementation HTupleVerticalView
- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds];
        [_tupleView setScrollEnabled:NO];
        [self addSubview:_tupleView];
    }
    return _tupleView;
}
- (void)layoutContentView {
    HLayoutTupleApex(self.tupleView)
}
@end

@implementation HTupleHorizontalView
- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds scrollDirection:HTupleViewScrollDirectionHorizontal];
        [_tupleView setScrollEnabled:NO];
        [self addSubview:_tupleView];
    }
    return _tupleView;
}
- (void)layoutContentView {
    HLayoutTupleApex(self.tupleView)
}
@end

@implementation HTupleUnionView
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
- (HWebButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [HWebButtonView new];
        [self addSubview:_buttonView];
    }
    return _buttonView;
}
- (HWebButtonView *)detailButtonView {
    if (!_detailButtonView) {
        _detailButtonView = [HWebButtonView new];
        [self addSubview:_detailButtonView];
    }
    return _detailButtonView;
}
- (HWebButtonView *)accessoryButtonView {
    if (!_accessoryButtonView) {
        _accessoryButtonView = [HWebButtonView new];
        [self addSubview:_accessoryButtonView];
    }
    return _accessoryButtonView;
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

@implementation HTupleViewApex
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        [self addSubview:_imageView];
    }
    return _imageView;
}
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
