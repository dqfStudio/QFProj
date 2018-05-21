//
//  HTupleReusableView.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleReusableView.h"

@implementation HReusableView
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

@implementation HReusableTextView
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

@implementation HReusableButtonView
- (HWebButtonView *)button {
    if (!_button) {
        _button = [HWebButtonView new];
        @weakify(self)
        [_button setPressed:^(id sender, id data) {
            @strongify(self)
            if (self.reusableButtonViewBlock) {
                self.reusableButtonViewBlock(self.button);
            }
        }];
        [self addSubview:_button];
    }
    return _button;
}
- (void)layoutContentView {
    if(!CGRectEqualToRect(self.button.frame, [self getContentView])) {
        [self.button setFrame:[self getContentView]];
    }
}
@end

@implementation HReusableImageView
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
    if (_reusableImageViewBlock) {
        _reusableImageViewBlock(self.imageView);
    }
}
- (void)layoutContentView {
    if(!CGRectEqualToRect(self.imageView.frame, [self getContentView])) {
        [self.imageView setFrame:[self getContentView]];
    }
}
@end

