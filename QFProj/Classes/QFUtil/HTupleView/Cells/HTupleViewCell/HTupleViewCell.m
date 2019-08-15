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
- (HLabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [HLabel new];
        [self addSubview:_headerLabel];
    }
    return _headerLabel;
}
- (HLabel *)sectionLabel {
    if (!_sectionLabel) {
        _sectionLabel = [HLabel new];
        [self addSubview:_sectionLabel];
    }
    return _sectionLabel;
}
- (HLabel *)footerLabel {
    if (!_footerLabel) {
        _footerLabel = [HLabel new];
        [self addSubview:_footerLabel];
    }
    return _footerLabel;
}
- (HTextView *)headerTextView {
    if (!_headerTextView) {
        _headerTextView = [HTextView new];
        [self addSubview:_headerTextView];
    }
    return _headerTextView;
}
- (HTextView *)sectionTextView {
    if (!_sectionTextView) {
        _sectionTextView = [HTextView new];
        [self addSubview:_sectionTextView];
    }
    return _sectionTextView;
}
- (HTextView *)footerTextView {
    if (!_footerTextView) {
        _footerTextView = [HTextView new];
        [self addSubview:_footerTextView];
    }
    return _footerTextView;
}
- (HWebButtonView *)headerButton {
    if (!_headerButton) {
        _headerButton = [HWebButtonView new];
        [self addSubview:_headerButton];
    }
    return _headerButton;
}
- (HWebButtonView *)sectionButton {
    if (!_sectionButton) {
        _sectionButton = [HWebButtonView new];
        [self addSubview:_sectionButton];
    }
    return _sectionButton;
}
- (HWebButtonView *)footerButton {
    if (!_footerButton) {
        _footerButton = [HWebButtonView new];
        [self addSubview:_footerButton];
    }
    return _footerButton;
}
- (HWebImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = HWebImageView.new;
        [self addSubview:_headerImageView];
    }
    return _headerImageView;
}
- (HWebImageView *)sectionImageView {
    if (!_sectionImageView) {
        _sectionImageView = HWebImageView.new;
        [self addSubview:_sectionImageView];
    }
    return _sectionImageView;
}
- (HWebImageView *)footerImageView {
    if (!_footerImageView) {
        _footerImageView = HWebImageView.new;
        [self addSubview:_footerImageView];
    }
    return _footerImageView;
}
- (HTextField *)headerTextField {
    if (!_headerTextField) {
        _headerTextField = HTextField.new;
        [self addSubview:_headerTextField];
    }
    return _headerTextField;
}
- (HTextField *)sectionTextField {
    if (!_sectionTextField) {
        _sectionTextField = HTextField.new;
        [self addSubview:_sectionTextField];
    }
    return _sectionTextField;
}
- (HTextField *)footerTextField {
    if (!_footerTextField) {
        _footerTextField = HTextField.new;
        [self addSubview:_footerTextField];
    }
    return _footerTextField;
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
- (HWebButtonView *)detailView {
    if (!_detailView) {
        _detailView = [HWebButtonView new];
        [self addSubview:_detailView];
    }
    return _detailView;
}
- (HWebButtonView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [HWebButtonView new];
        [self addSubview:_accessoryView];
    }
    return _accessoryView;
}
@end
