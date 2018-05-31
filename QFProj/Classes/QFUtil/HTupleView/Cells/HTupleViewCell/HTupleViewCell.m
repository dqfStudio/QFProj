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

@implementation HScrollViewCell
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
- (void)layoutContentView {
    HLayoutTupleView(self.scrollView)
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

@interface HTextViewCell2 ()
@property (nonatomic) UIView *bgView;
@end

@implementation HTextViewCell2
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        [self addSubview:_bgView];
    }
    return _bgView;
}
- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        [self.bgView addSubview:_leftLabel];
    }
    return _leftLabel;
}
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        [self.bgView addSubview:_rightLabel];
    }
    return _rightLabel;
}
- (void)layoutContentView {
    HLayoutTupleView(self.bgView)
}
- (void)initUI {
    
    [self.leftLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.leftLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@10);
        make.right.equalTo(self.rightLabel.mas_left).offset(-10);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLabel.mas_right).offset(10);
        make.top.equalTo(self.leftLabel);
        make.right.equalTo(@(-10));
    }];
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
                self.buttonViewBlock(self.button, self);
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
@property (nonatomic) UITapGestureRecognizer *tapGesture;
@end

@implementation HImageViewCell
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = [HWebImageView new];
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] init];
        _tapGesture.numberOfTapsRequired = 1;
        _tapGesture.numberOfTouchesRequired = 1;
        [_tapGesture addTarget:self action:@selector(tapGestureAction)];
    }
    return _tapGesture;
}
- (void)tapGestureAction {
    if (_imageViewBlock) {
        _imageViewBlock(self.imageView, self);
    }
}
- (void)setImageViewBlock:(HImageViewBlock)imageViewBlock {
    if (_imageViewBlock != imageViewBlock) {
        _imageViewBlock = nil;
        _imageViewBlock = imageViewBlock;
        if (!self.tapGesture.view) {
            [self.imageView addGestureRecognizer:self.tapGesture];
        }
    }
}
- (void)layoutContentView {
    HLayoutTupleView(self.imageView)
}
@end
