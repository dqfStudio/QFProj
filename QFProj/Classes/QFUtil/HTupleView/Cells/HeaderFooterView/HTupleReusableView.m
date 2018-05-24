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
    HLayoutReusableView(self.view)
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
    HLayoutReusableView(self.label)
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
    HLayoutReusableView(self.button)
}
@end

@implementation HReusableImageView
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = [HWebImageView new];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewAction:)];
        [_imageView addGestureRecognizer:tapGestureRecognizer];
        [_imageView setUserInteractionEnabled:NO];
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (void)setTapEnable:(BOOL)enabled {
    [self.imageView setUserInteractionEnabled:enabled];
}
- (void)imageViewAction:(id)sender {
    if (_reusableImageViewBlock) {
        _reusableImageViewBlock(self.imageView);
    }
}
- (void)layoutContentView {
    HLayoutReusableView(self.imageView)
}
@end

