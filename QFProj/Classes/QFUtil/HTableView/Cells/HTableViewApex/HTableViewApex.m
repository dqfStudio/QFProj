//
//  HTableViewApex.m
//  QFProj
//
//  Created by wind on 2019/4/12.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTableViewApex.h"

@implementation HTableBlankApex
- (UIView *)view {
    if (!_view) {
        _view = [UIView new];
        [self.contentView addSubview:_view];
    }
    return _view;
}
- (void)layoutContentView {
    HLayoutTableApex(self.view)
}
@end

@implementation HTableLabelApex
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [self.contentView addSubview:_label];
    }
    return _label;
}
- (void)layoutContentView {
    HLayoutTableApex(self.label)
}
@end

@implementation HTableTextApex
- (HTextView *)textView {
    if (!_textView) {
        _textView = [HTextView new];
        [self.contentView addSubview:_textView];
    }
    return _textView;
}
- (void)layoutContentView {
    HLayoutTableApex(self.textView)
}
@end

@implementation HTableButtonApex
- (HWebButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [HWebButtonView new];
        [self.contentView addSubview:_buttonView];
    }
    return _buttonView;
}
- (void)layoutContentView {
    HLayoutTableApex(self.buttonView)
}
@end

@implementation HTableImageApex
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = [HWebImageView new];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}
- (void)layoutContentView {
    HLayoutTableApex(self.imageView)
}
@end

@implementation HTableTextFieldApex
- (HTextField *)textField {
    if (!_textField) {
        _textField = HTextField.new;
        [self.contentView addSubview:_textField];
    }
    return _textField;
}
- (void)layoutContentView {
    HLayoutTableApex(self.textField)
}
@end

@implementation HTableVerticalApex
- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds];
        [_tupleView setScrollEnabled:NO];
        [self.contentView addSubview:_tupleView];
    }
    return _tupleView;
}
- (void)layoutContentView {
    HLayoutTableApex(self.tupleView)
}
@end

@implementation HTableHorizontalApex
- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds scrollDirection:HTupleViewScrollDirectionHorizontal];
        [_tupleView setScrollEnabled:NO];
        [self.contentView addSubview:_tupleView];
    }
    return _tupleView;
}
- (void)layoutContentView {
    HLayoutTableApex(self.tupleView)
}
@end

@implementation HTableViewApex
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [self.contentView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HLabel *)accessoryLabel {
    if (!_accessoryLabel) {
        _accessoryLabel = [HLabel new];
        [self.contentView addSubview:_accessoryLabel];
    }
    return _accessoryLabel;
}
- (HWebImageView *)detailView {
    if (!_detailView) {
        _detailView = [HWebImageView new];
        [self.contentView addSubview:_detailView];
    }
    return _detailView;
}
- (HWebImageView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [HWebImageView new];
        [self.contentView addSubview:_accessoryView];
    }
    return _accessoryView;
}
@end

@implementation HTableUnionApex
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [self.contentView addSubview:_label];
    }
    return _label;
}
- (HLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [HLabel new];
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (HLabel *)accessoryLabel {
    if (!_accessoryLabel) {
        _accessoryLabel = [HLabel new];
        [self.contentView addSubview:_accessoryLabel];
    }
    return _accessoryLabel;
}
- (HTextView *)textView {
    if (!_textView) {
        _textView = [HTextView new];
        [self.contentView addSubview:_textView];
    }
    return _textView;
}
- (HTextView *)detailTextView {
    if (!_detailTextView) {
        _detailTextView = [HTextView new];
        [self.contentView addSubview:_detailTextView];
    }
    return _detailTextView;
}
- (HTextView *)accessoryTextView {
    if (!_accessoryTextView) {
        _accessoryTextView = [HTextView new];
        [self.contentView addSubview:_accessoryTextView];
    }
    return _accessoryTextView;
}
- (HWebButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [HWebButtonView new];
        [self.contentView addSubview:_buttonView];
    }
    return _buttonView;
}
- (HWebButtonView *)detailButtonView {
    if (!_detailButtonView) {
        _detailButtonView = [HWebButtonView new];
        [self.contentView addSubview:_detailButtonView];
    }
    return _detailButtonView;
}
- (HWebButtonView *)accessoryButtonView {
    if (!_accessoryButtonView) {
        _accessoryButtonView = [HWebButtonView new];
        [self.contentView addSubview:_accessoryButtonView];
    }
    return _accessoryButtonView;
}
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = HWebImageView.new;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}
- (HWebImageView *)detailImageView {
    if (!_detailImageView) {
        _detailImageView = HWebImageView.new;
        [self.contentView addSubview:_detailImageView];
    }
    return _detailImageView;
}
- (HWebImageView *)accessoryImageView {
    if (!_accessoryImageView) {
        _accessoryImageView = HWebImageView.new;
        [self.contentView addSubview:_accessoryImageView];
    }
    return _accessoryImageView;
}
- (HTextField *)textField {
    if (!_textField) {
        _textField = HTextField.new;
        [self.contentView addSubview:_textField];
    }
    return _textField;
}
- (HTextField *)detailTextField {
    if (!_detailTextField) {
        _detailTextField = HTextField.new;
        [self.contentView addSubview:_detailTextField];
    }
    return _detailTextField;
}
- (HTextField *)accessoryTextField {
    if (!_accessoryTextField) {
        _accessoryTextField = HTextField.new;
        [self.contentView addSubview:_accessoryTextField];
    }
    return _accessoryTextField;
}
@end
