//
//  HTupleViewApex.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleViewApex.h"

@implementation HTupleBlankApex
- (UIView *)view {
    if (!_view) {
        _view = [UIView new];
        [self addSubview:_view];
    }
    return _view;
}
- (void)updateLayoutView {
    HLayoutTupleApex(self.view)
}
@end

@implementation HTupleLabelApex
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [_label setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_label];
    }
    return _label;
}
- (void)updateLayoutView {
    HLayoutTupleApex(self.label)
}
@end

@implementation HTupleTextApex
- (HTextView *)textView {
    if (!_textView) {
        _textView = [HTextView new];
        [_textView setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_textView];
    }
    return _textView;
}
- (void)updateLayoutView {
    HLayoutTupleApex(self.textView)
}
@end

@implementation HTupleButtonApex
- (HWebButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [HWebButtonView new];
        [self addSubview:_buttonView];
    }
    return _buttonView;
}
- (void)updateLayoutView {
    HLayoutTupleApex(self.buttonView)
}
@end

@implementation HTupleImageApex
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = [HWebImageView new];
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (void)updateLayoutView {
    HLayoutTupleApex(self.imageView)
}
@end

@implementation HTupleTextFieldApex
- (HTextField *)textField {
    if (!_textField) {
        _textField = HTextField.new;
        [self addSubview:_textField];
    }
    return _textField;
}
- (void)updateLayoutView {
    HLayoutTupleApex(self.textField)
}
@end

@implementation HTupleViewApex
- (void)updateLayoutView {
    HLayoutTupleApex(self.layoutView)
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
- (HTextView *)textView {
    if (!_textView) {
        _textView = [HTextView new];
        [_textView setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_textView];
    }
    return _textView;
}
- (HTextView *)detailTextView {
    if (!_detailTextView) {
        _detailTextView = [HTextView new];
        [_detailTextView setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_detailTextView];
    }
    return _detailTextView;
}
- (HTextView *)accessoryTextView {
    if (!_accessoryTextView) {
        _accessoryTextView = [HTextView new];
        [_accessoryTextView setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_accessoryTextView];
    }
    return _accessoryTextView;
}
- (HWebButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [HWebButtonView new];
        [self.layoutView addSubview:_buttonView];
    }
    return _buttonView;
}
- (HWebButtonView *)detailButtonView {
    if (!_detailButtonView) {
        _detailButtonView = [HWebButtonView new];
        [self.layoutView addSubview:_detailButtonView];
    }
    return _detailButtonView;
}
- (HWebButtonView *)accessoryButtonView {
    if (!_accessoryButtonView) {
        _accessoryButtonView = [HWebButtonView new];
        [self.layoutView addSubview:_accessoryButtonView];
    }
    return _accessoryButtonView;
}
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        [self.layoutView addSubview:_imageView];
    }
    return _imageView;
}
- (HWebImageView *)detailImageView {
    if (!_detailImageView) {
        _detailImageView = HWebImageView.new;
        [self.layoutView addSubview:_detailImageView];
    }
    return _detailImageView;
}
- (HWebImageView *)accessoryImageView {
    if (!_accessoryImageView) {
        _accessoryImageView = HWebImageView.new;
        [self.layoutView addSubview:_accessoryImageView];
    }
    return _accessoryImageView;
}
- (HTextField *)textField {
    if (!_textField) {
        _textField = HTextField.new;
        [self.layoutView addSubview:_textField];
    }
    return _textField;
}
- (HTextField *)detailTextField {
    if (!_detailTextField) {
        _detailTextField = HTextField.new;
        [self.layoutView addSubview:_detailTextField];
    }
    return _detailTextField;
}
- (HTextField *)accessoryTextField {
    if (!_accessoryTextField) {
        _accessoryTextField = HTextField.new;
        [self.layoutView addSubview:_accessoryTextField];
    }
    return _accessoryTextField;
}
@end
