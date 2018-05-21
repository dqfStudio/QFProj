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
- (HWebButtonView *)button {
    if (!_button) {
        _button = [HWebButtonView new];
        [_button.button addTarget:self action:@selector(buttonAction:)];
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
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = [HWebImageView new];
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
