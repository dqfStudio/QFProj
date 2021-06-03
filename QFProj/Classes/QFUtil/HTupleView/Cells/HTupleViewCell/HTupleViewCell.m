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
        [self.layoutView addSubview:_view];
    }
    return _view;
}
- (void)relayoutSubviews {
    HLayoutTupleCell(self.view)
}
@end

@implementation HTupleLabelCell
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        [_label setFont:[UIFont systemFontOfSize:14]];
        [_label setAdjustsFontSizeToFitWidth:YES];
        [self.layoutView addSubview:_label];
    }
    return _label;
}
- (void)relayoutSubviews {
    HLayoutTupleCell(self.label)
}
@end

@implementation HTupleNoteCell
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [_label setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_label];
    }
    return _label;
}
- (void)relayoutSubviews {
    HLayoutTupleCell(self.label)
}
@end

@implementation HTupleTextCell
- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        [_textView setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_textView];
    }
    return _textView;
}
- (void)relayoutSubviews {
    HLayoutTupleCell(self.textView)
}
@end

@implementation HTupleTextNoteCell
- (HTextView *)textView {
    if (!_textView) {
        _textView = [HTextView new];
        [_textView setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_textView];
    }
    return _textView;
}
- (void)relayoutSubviews {
    HLayoutTupleCell(self.textView)
}
@end

@implementation HTupleButtonCell
- (HWebButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [HWebButtonView new];
        [self.layoutView addSubview:_buttonView];
    }
    return _buttonView;
}
- (void)relayoutSubviews {
    HLayoutTupleCell(self.buttonView)
}
@end

@implementation HTupleImageCell
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = [HWebImageView new];
        [self.layoutView addSubview:_imageView];
    }
    return _imageView;
}
- (void)relayoutSubviews {
    HLayoutTupleCell(self.imageView)
}
@end

@implementation HTupleAnimatedImageCell
- (HAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [HAnimatedImageView new];
        [self.layoutView addSubview:_imageView];
    }
    return _imageView;
}
- (void)relayoutSubviews {
    HLayoutTupleCell(self.imageView)
}
@end

@implementation HTupleTextFieldCell
- (HTextField *)textField {
    if (!_textField) {
        _textField = HTextField.new;
        HLayoutTupleCell(_textField)
        [self.layoutView addSubview:_textField];
    }
    return _textField;
}
- (void)relayoutSubviews {
    HLayoutTupleCell(self.textField)
}
@end

@implementation HTupleViewCell
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        [_label setFont:[UIFont systemFontOfSize:14]];
        [_label setAdjustsFontSizeToFitWidth:YES];
        [self.layoutView addSubview:_label];
    }
    return _label;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        [_detailLabel setFont:[UIFont systemFontOfSize:14]];
        [_detailLabel setAdjustsFontSizeToFitWidth:YES];
        [self.layoutView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (UILabel *)accessoryLabel {
    if (!_accessoryLabel) {
        _accessoryLabel = [UILabel new];
        [_accessoryLabel setFont:[UIFont systemFontOfSize:14]];
        [_accessoryLabel setAdjustsFontSizeToFitWidth:YES];
        [self.layoutView addSubview:_accessoryLabel];
    }
    return _accessoryLabel;
}
- (HLabel *)note {
    if (!_note) {
        _note = [HLabel new];
        [_note setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_note];
    }
    return _note;
}
- (HLabel *)detailNote {
    if (!_detailNote) {
        _detailNote = [HLabel new];
        [_detailNote setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_detailNote];
    }
    return _detailNote;
}
- (HLabel *)accessoryNote {
    if (!_accessoryNote) {
        _accessoryNote = [HLabel new];
        [_accessoryNote setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_accessoryNote];
    }
    return _accessoryNote;
}
- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        [_textView setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_textView];
    }
    return _textView;
}
- (UITextView *)detailTextView {
    if (!_detailTextView) {
        _detailTextView = [UITextView new];
        [_detailTextView setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_detailTextView];
    }
    return _detailTextView;
}
- (UITextView *)accessoryTextView {
    if (!_accessoryTextView) {
        _accessoryTextView = [UITextView new];
        [_accessoryTextView setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_accessoryTextView];
    }
    return _accessoryTextView;
}
- (HTextView *)textNote {
    if (!_textNote) {
        _textNote = [HTextView new];
        [_textNote setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_textNote];
    }
    return _textNote;
}
- (HTextView *)detailTextNote {
    if (!_detailTextNote) {
        _detailTextNote = [HTextView new];
        [_detailTextNote setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_detailTextNote];
    }
    return _detailTextNote;
}
- (HTextView *)accessoryTextNote {
    if (!_accessoryTextNote) {
        _accessoryTextNote = [HTextView new];
        [_accessoryTextNote setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_accessoryTextNote];
    }
    return _accessoryTextNote;
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
