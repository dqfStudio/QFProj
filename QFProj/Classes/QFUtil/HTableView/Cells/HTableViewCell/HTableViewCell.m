//
//  HTableViewCell.m
//  MGMobileMusic
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HTableViewCell.h"

@implementation HTableCellValue1
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}
- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end

@implementation HTableCellValue2
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
}
- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end

@implementation HTableCellSubtitle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}
- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end

@implementation HTableBlankCell
- (UIView *)view {
    if (!_view) {
        _view = [UIView new];
        [self.layoutView addSubview:_view];
    }
    return _view;
}
- (void)relayoutSubviews {
    HLayoutTableCell(self.view)
}
@end

@implementation HTableLabelCell
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [_label setFont:[UIFont systemFontOfSize:14]];
        [self.layoutView addSubview:_label];
    }
    return _label;
}
- (void)relayoutSubviews {
    HLayoutTableCell(self.label)
}
@end

@implementation HTableTextCell
- (HTextView *)textView {
    if (!_textView) {
        _textView = [HTextView new];
        [self.layoutView addSubview:_textView];
    }
    return _textView;
}
- (void)relayoutSubviews {
    HLayoutTableCell(self.textView)
}
@end

@implementation HTableButtonCell
- (HWebButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [HWebButtonView new];
        [self.layoutView addSubview:_buttonView];
    }
    return _buttonView;
}
- (void)relayoutSubviews {
    HLayoutTableCell(self.buttonView)
}
@end

@implementation HTableImageCell
@synthesize imageView = _imageView;
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = [HWebImageView new];
        [self.layoutView addSubview:_imageView];
    }
    return _imageView;
}
- (void)relayoutSubviews {
    HLayoutTableCell(self.imageView)
}
@end

@implementation HTableAnimatedImageCell
@synthesize imageView = _imageView;
- (HAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [HAnimatedImageView new];
        [self.layoutView addSubview:_imageView];
    }
    return _imageView;
}
- (void)relayoutSubviews {
    HLayoutTableCell(self.imageView)
}
@end

@implementation HTableTextFieldCell
- (HTextField *)textField {
    if (!_textField) {
        _textField = HTextField.new;
        HLayoutTableCell(_textField)
        [self.layoutView addSubview:_textField];
    }
    return _textField;
}
- (void)relayoutSubviews {
    HLayoutTableCell(self.textField)
}
@end

@implementation HTableViewCell
@synthesize imageView = _imageView;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}
- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
        [self.layoutView addSubview:_textView];
    }
    return _textView;
}
- (HTextView *)detailTextView {
    if (!_detailTextView) {
        _detailTextView = [HTextView new];
        [self.layoutView addSubview:_detailTextView];
    }
    return _detailTextView;
}
- (HTextView *)accessoryTextView {
    if (!_accessoryTextView) {
        _accessoryTextView = [HTextView new];
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
