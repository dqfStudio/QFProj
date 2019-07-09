//
//  HTupleReusableView.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleReusableView.h"

@implementation HTupleLabelView
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [_label setBackgroundColor:UIColor.clearColor];
        [self addSubview:_label];
    }
    return _label;
}
- (void)layoutContentView {
    HLayoutTupleView(self.label)
}
@end

@implementation HTupleTextView
- (HTextView *)textView {
    if (!_textView) {
        _textView = [HTextView new];
        [_textView setBackgroundColor:UIColor.clearColor];
        [self addSubview:_textView];
    }
    return _textView;
}
- (void)layoutContentView {
    HLayoutTupleView(self.textView)
}
@end

@implementation HTupleButtonView
- (HWebButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [HWebButtonView new];
        [_buttonView setBackgroundColor:UIColor.clearColor];
        [self addSubview:_buttonView];
    }
    return _buttonView;
}
- (void)layoutContentView {
    HLayoutTupleView(self.buttonView)
}
@end

@implementation HTupleImageView
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = [HWebImageView new];
        [_imageView setBackgroundColor:UIColor.clearColor];
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (void)layoutContentView {
    HLayoutTupleView(self.imageView)
}
@end

@implementation HTupleTextFieldView
- (HTextField *)textField {
    if (!_textField) {
        _textField = HTextField.new;
        [_textField setBackgroundColor:UIColor.clearColor];
        [self addSubview:_textField];
    }
    return _textField;
}
- (void)layoutContentView {
    HLayoutTupleView(self.textField)
}
@end

@implementation HTupleVerticalView
- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds];
        [_tupleView setBackgroundColor:UIColor.clearColor];
        [_tupleView setScrollEnabled:NO];
        [self addSubview:_tupleView];
    }
    return _tupleView;
}
- (void)layoutContentView {
    HLayoutTupleView(self.tupleView)
}
@end

@implementation HTupleHorizontalView
- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds scrollDirection:HTupleViewScrollDirectionHorizontal];
        [_tupleView setBackgroundColor:UIColor.clearColor];
        [_tupleView setScrollEnabled:NO];
        [self addSubview:_tupleView];
    }
    return _tupleView;
}
- (void)layoutContentView {
    HLayoutTupleView(self.tupleView)
}
@end

@implementation HTupleUnionView
- (HLabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [HLabel new];
        [_headerLabel setBackgroundColor:UIColor.clearColor];
        [self addSubview:_headerLabel];
    }
    return _headerLabel;
}
- (HLabel *)sectionLabel {
    if (!_sectionLabel) {
        _sectionLabel = [HLabel new];
        [_sectionLabel setBackgroundColor:UIColor.clearColor];
        [self addSubview:_sectionLabel];
    }
    return _sectionLabel;
}
- (HLabel *)footerLabel {
    if (!_footerLabel) {
        _footerLabel = [HLabel new];
        [_footerLabel setBackgroundColor:UIColor.clearColor];
        [self addSubview:_footerLabel];
    }
    return _footerLabel;
}
- (HTextView *)headerTextView {
    if (!_headerTextView) {
        _headerTextView = [HTextView new];
        [_headerTextView setBackgroundColor:UIColor.clearColor];
        [self addSubview:_headerTextView];
    }
    return _headerTextView;
}
- (HTextView *)sectionTextView {
    if (!_sectionTextView) {
        _sectionTextView = [HTextView new];
        [_sectionTextView setBackgroundColor:UIColor.clearColor];
        [self addSubview:_sectionTextView];
    }
    return _sectionTextView;
}
- (HTextView *)footerTextView {
    if (!_footerTextView) {
        _footerTextView = [HTextView new];
        [_footerTextView setBackgroundColor:UIColor.clearColor];
        [self addSubview:_footerTextView];
    }
    return _footerTextView;
}
- (HWebButtonView *)headerButton {
    if (!_headerButton) {
        _headerButton = [HWebButtonView new];
        [_headerButton setBackgroundColor:UIColor.clearColor];
        [self addSubview:_headerButton];
    }
    return _headerButton;
}
- (HWebButtonView *)sectionButton {
    if (!_sectionButton) {
        _sectionButton = [HWebButtonView new];
        [_sectionButton setBackgroundColor:UIColor.clearColor];
        [self addSubview:_sectionButton];
    }
    return _sectionButton;
}
- (HWebButtonView *)footerButton {
    if (!_footerButton) {
        _footerButton = [HWebButtonView new];
        [_footerButton setBackgroundColor:UIColor.clearColor];
        [self addSubview:_footerButton];
    }
    return _footerButton;
}
- (HWebImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = HWebImageView.new;
        [_headerImageView setBackgroundColor:UIColor.clearColor];
        [self addSubview:_headerImageView];
    }
    return _headerImageView;
}
- (HWebImageView *)sectionImageView {
    if (!_sectionImageView) {
        _sectionImageView = HWebImageView.new;
        [_sectionImageView setBackgroundColor:UIColor.clearColor];
        [self addSubview:_sectionImageView];
    }
    return _sectionImageView;
}
- (HWebImageView *)footerImageView {
    if (!_footerImageView) {
        _footerImageView = HWebImageView.new;
        [_footerImageView setBackgroundColor:UIColor.clearColor];
        [self addSubview:_footerImageView];
    }
    return _footerImageView;
}
- (HTextField *)headerTextField {
    if (!_headerTextField) {
        _headerTextField = HTextField.new;
        [_headerTextField setBackgroundColor:UIColor.clearColor];
        [self addSubview:_headerTextField];
    }
    return _headerTextField;
}
- (HTextField *)sectionTextField {
    if (!_sectionTextField) {
        _sectionTextField = HTextField.new;
        [_sectionTextField setBackgroundColor:UIColor.clearColor];
        [self addSubview:_sectionTextField];
    }
    return _sectionTextField;
}
- (HTextField *)footerTextField {
    if (!_footerTextField) {
        _footerTextField = HTextField.new;
        [_footerTextField setBackgroundColor:UIColor.clearColor];
        [self addSubview:_footerTextField];
    }
    return _footerTextField;
}
@end
