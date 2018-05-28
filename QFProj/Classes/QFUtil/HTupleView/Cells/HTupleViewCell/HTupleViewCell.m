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
    HLayoutTupleView(self.view)
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
    HLayoutTupleView(self.label)
}
@end

@implementation HButtonViewCell
- (HWebButtonView *)button {
    if (!_button) {
        _button = [HWebButtonView new];
        @weakify(self)
        [_button setPressed:^(id sender, id data) {
            @strongify(self)
            if (self.buttonViewBlock) {
                self.buttonViewBlock(self.button);
            }
        }];
        [self addSubview:_button];
    }
    return _button;
}
- (void)layoutContentView {
    HLayoutTupleView(self.button)
}
@end

@interface HImageViewCell ()
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation HImageViewCell
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = [HWebImageView new];
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (void)setImageViewBlock:(HImageViewBlock)imageViewBlock {
    if (_imageViewBlock != imageViewBlock) {
        _imageViewBlock = nil;
        _imageViewBlock = imageViewBlock;
        if (!_tapGestureRecognizer) {
            _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewAction:)];
            [self.imageView addGestureRecognizer:_tapGestureRecognizer];
        }
    }
}
- (void)imageViewAction:(id)sender {
    if (_imageViewBlock) {
        _imageViewBlock(self.imageView);
    }
}
- (void)layoutContentView {
    HLayoutTupleView(self.imageView)
}
@end
