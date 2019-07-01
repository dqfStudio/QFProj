//
//  HTupleViewCell.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"

@implementation HTupleLabelViewCell
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [_label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_label];
    }
    return _label;
}
- (void)layoutContentView {
    HLayoutTupleView(self.label)
}
@end

@implementation HTupleTextViewCell
- (HTextView *)textView {
    if (!_textView) {
        _textView = [HTextView new];
        [_textView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_textView];
    }
    return _textView;
}
- (void)layoutContentView {
    HLayoutTupleView(self.textView)
}
@end

@implementation HTupleButtonViewCell
- (HWebButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [HWebButtonView new];
        [_buttonView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_buttonView];
    }
    return _buttonView;
}
- (void)layoutContentView {
    HLayoutTupleView(self.buttonView)
}
@end

@implementation HTupleImageViewCell
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = [HWebImageView new];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (void)layoutContentView {
    HLayoutTupleView(self.imageView)
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
    HLayoutTupleView(self.textField)
}
@end

@implementation HTupleVerticalCell
- (HTupleView *)tuple {
    if (!_tuple) {
        _tuple = [[HTupleView alloc] initWithFrame:self.bounds];
        [_tuple setBackgroundColor:[UIColor clearColor]];
        [_tuple setScrollEnabled:NO];
        [self addSubview:_tuple];
    }
    return _tuple;
}
- (void)layoutContentView {
    HLayoutTupleView(self.tuple)
}
@end

@implementation HTupleHorizontalCell
- (HTupleView *)tuple {
    if (!_tuple) {
        _tuple = [[HTupleView alloc] initWithFrame:self.bounds scrollDirection:HTupleViewScrollDirectionHorizontal];
        [_tuple setBackgroundColor:[UIColor clearColor]];
        [_tuple setScrollEnabled:NO];
        [self addSubview:_tuple];
    }
    return _tuple;
}
- (void)layoutContentView {
    HLayoutTupleView(self.tuple)
}
@end

@implementation HTupleViewCell
- (HLabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [HLabel new];
        [_leftLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_leftLabel];
    }
    return _leftLabel;
}
- (HLabel *)middleLabel {
    if (!_middleLabel) {
        _middleLabel = [HLabel new];
        [_middleLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_middleLabel];
    }
    return _middleLabel;
}
- (HLabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [HLabel new];
        [_rightLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_rightLabel];
    }
    return _rightLabel;
}
- (HTextView *)leftTextView {
    if (!_leftTextView) {
        _leftTextView = [HTextView new];
        [_leftTextView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_leftTextView];
    }
    return _leftTextView;
}
- (HTextView *)middleTextView {
    if (!_middleTextView) {
        _middleTextView = [HTextView new];
        [_middleTextView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_middleTextView];
    }
    return _middleTextView;
}
- (HTextView *)rightTextView {
    if (!_rightTextView) {
        _rightTextView = [HTextView new];
        [_rightTextView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_rightTextView];
    }
    return _rightTextView;
}
- (HWebButtonView *)leftButton {
    if (!_leftButton) {
        _leftButton = [HWebButtonView new];
        [_leftButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_leftButton];
    }
    return _leftButton;
}
- (HWebButtonView *)middleButton {
    if (!_middleButton) {
        _middleButton = [HWebButtonView new];
        [_middleButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_middleButton];
    }
    return _middleButton;
}
- (HWebButtonView *)rightButton {
    if (!_rightButton) {
        _rightButton = [HWebButtonView new];
        [_rightButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_rightButton];
    }
    return _rightButton;
}
- (HWebImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = HWebImageView.new;
        [_leftImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_leftImageView];
    }
    return _leftImageView;
}
- (HWebImageView *)middleImageView {
    if (!_middleImageView) {
        _middleImageView = HWebImageView.new;
        [_middleImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_middleImageView];
    }
    return _middleImageView;
}
- (HWebImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = HWebImageView.new;
        [_rightImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_rightImageView];
    }
    return _rightImageView;
}
- (HTextField *)leftTextField {
    if (!_leftTextField) {
        _leftTextField = HTextField.new;
        [_leftTextField setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_leftTextField];
    }
    return _leftTextField;
}
- (HTextField *)middleTextField {
    if (!_middleTextField) {
        _middleTextField = HTextField.new;
        [_middleTextField setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_middleTextField];
    }
    return _middleTextField;
}
- (HTextField *)rightTextField {
    if (!_rightTextField) {
        _rightTextField = HTextField.new;
        [_rightTextField setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_rightTextField];
    }
    return _rightTextField;
}
@end
