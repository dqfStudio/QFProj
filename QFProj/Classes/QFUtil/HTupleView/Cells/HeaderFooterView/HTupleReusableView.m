//
//  HTupleReusableView.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleReusableView.h"

#define HLayoutView(v) \
if(!CGRectEqualToRect(v.frame, [self getContentView])) {\
    [v setFrame:[self getContentView]];\
}

@implementation HReusableView
- (UIView *)view {
    if (!_view) {
        _view = [UIView new];
        [self addSubview:_view];
    }
    return _view;
}
- (void)layoutContentView {
    HLayoutView(self.view)
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
    HLayoutView(self.label)
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
    HLayoutView(self.button)
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
    HLayoutView(self.imageView)
}
@end

