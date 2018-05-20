//
//  HTupleViewCell.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"

@implementation HViewCell
- (UIView *)view {
    if (!_view) {
        _view = [UIView new];
        [self addSubview:_view];
    }
    return _view;
}
- (void)layoutContentView {
    if(!CGRectEqualToRect(self.view.frame, [self getContentView])) {
        [self.view setFrame:[self getContentView]];
    }
}
@end

@implementation HTextViewCell
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        [self addSubview:_label];
    }
    return _label;
}
- (void)layoutContentView {
    if(!CGRectEqualToRect(self.label.frame, [self getContentView])) {
        [self.label setFrame:[self getContentView]];
    }
}
@end

@implementation HButtonViewCell
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton new];
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return _button;
}
- (void)buttonAction:(id)sender {
    if (_buttonViewBlock) {
        _buttonViewBlock(sender);
    }
}
- (void)layoutContentView {
    if(!CGRectEqualToRect(self.button.frame, [self getContentView])) {
        [self.button setFrame:[self getContentView]];
    }
}
@end

@implementation HImageViewCell
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewAction:)];
        [_imageView addGestureRecognizer:tapGestureRecognizer];
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (void)imageViewAction:(id)sender {
    if (_imageViewBlock) {
        _imageViewBlock(self.imageView);
    }
}
- (void)layoutContentView {
    if(!CGRectEqualToRect(self.imageView.frame, [self getContentView])) {
        [self.imageView setFrame:[self getContentView]];
    }
}
@end

@implementation HTupleViewCell
- (HTupleView2 *)tupleView2 {
    if (!_tupleView2) {
        _tupleView2 = [[HTupleView2 alloc] initWithFrame:self.frame];
        [self addSubview:_tupleView2];
    }
    return _tupleView2;
}
- (void)layoutContentView {
    if(!CGRectEqualToRect(self.tupleView2.frame, [self getContentView])) {
        [self.tupleView2 setFrame:[self getContentView]];
    }
}
@end
