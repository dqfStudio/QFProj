//
//  HTableViewCell.m
//  MGMobileMusic
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HTableViewCell.h"

@implementation HTableViewCellValue1
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}
- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end

@implementation HTableViewCellValue2
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
}
- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end

@implementation HTableViewCellSubtitle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}
- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end

@implementation HTableLabelCell
- (HLabel *)label {
    if (!_label) {
        _label = [HLabel new];
        [_label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_label];
    }
    return _label;
}
- (void)layoutContentView {
    HLayoutTableView(self.label)
}
@end

@implementation HTableTextViewCell
- (HTextView *)textView {
    if (!_textView) {
        _textView = [HTextView new];
        [_textView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_textView];
    }
    return _textView;
}
- (void)layoutContentView {
    HLayoutTableView(self.textView)
}
@end

@implementation HTableButtonViewCell
- (HWebButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [HWebButtonView new];
        [_buttonView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_buttonView];
    }
    return _buttonView;
}
- (void)layoutContentView {
    HLayoutTableView(self.buttonView)
}
@end

@implementation HTableImageViewCell
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = [HWebImageView new];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (void)layoutContentView {
    HLayoutTableView(self.imageView)
}
@end

@implementation HTableTextFieldCell
- (HTextField *)textField {
    if (!_textField) {
        _textField = HTextField.new;
        [self addSubview:_textField];
    }
    return _textField;
}
- (void)layoutContentView {
    HLayoutTableView(self.textField)
}
@end

@implementation HTableVerticalCell
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
    HLayoutTableView(self.tuple)
}
@end

@implementation HTableHorizontalCell
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
    HLayoutTableView(self.tuple)
}
@end

@implementation HTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}
- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (HLabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [HLabel new];
        [_headerLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_headerLabel];
    }
    return _headerLabel;
}
- (HLabel *)sectionLabel {
    if (!_sectionLabel) {
        _sectionLabel = [HLabel new];
        [_sectionLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_sectionLabel];
    }
    return _sectionLabel;
}
- (HLabel *)footerLabel {
    if (!_footerLabel) {
        _footerLabel = [HLabel new];
        [_footerLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_footerLabel];
    }
    return _footerLabel;
}
- (HTextView *)headerTextView {
    if (!_headerTextView) {
        _headerTextView = [HTextView new];
        [_headerTextView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_headerTextView];
    }
    return _headerTextView;
}
- (HTextView *)sectionTextView {
    if (!_sectionTextView) {
        _sectionTextView = [HTextView new];
        [_sectionTextView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_sectionTextView];
    }
    return _sectionTextView;
}
- (HTextView *)footerTextView {
    if (!_footerTextView) {
        _footerTextView = [HTextView new];
        [_footerTextView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_footerTextView];
    }
    return _footerTextView;
}
- (HWebButtonView *)headerButton {
    if (!_headerButton) {
        _headerButton = [HWebButtonView new];
        [_headerButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_headerButton];
    }
    return _headerButton;
}
- (HWebButtonView *)sectionButton {
    if (!_sectionButton) {
        _sectionButton = [HWebButtonView new];
        [_sectionButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_sectionButton];
    }
    return _sectionButton;
}
- (HWebButtonView *)footerButton {
    if (!_footerButton) {
        _footerButton = [HWebButtonView new];
        [_footerButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_footerButton];
    }
    return _footerButton;
}
- (HWebImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = HWebImageView.new;
        [_headerImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_headerImageView];
    }
    return _headerImageView;
}
- (HWebImageView *)sectionImageView {
    if (!_sectionImageView) {
        _sectionImageView = HWebImageView.new;
        [_sectionImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_sectionImageView];
    }
    return _sectionImageView;
}
- (HWebImageView *)footerImageView {
    if (!_footerImageView) {
        _footerImageView = HWebImageView.new;
        [_footerImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_footerImageView];
    }
    return _footerImageView;
}
- (HTextField *)headerTextField {
    if (!_headerTextField) {
        _headerTextField = HTextField.new;
        [_headerTextField setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_headerTextField];
    }
    return _headerTextField;
}
- (HTextField *)sectionTextField {
    if (!_sectionTextField) {
        _sectionTextField = HTextField.new;
        [_sectionTextField setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_sectionTextField];
    }
    return _sectionTextField;
}
- (HTextField *)footerTextField {
    if (!_footerTextField) {
        _footerTextField = HTextField.new;
        [_footerTextField setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_footerTextField];
    }
    return _footerTextField;
}
@end
