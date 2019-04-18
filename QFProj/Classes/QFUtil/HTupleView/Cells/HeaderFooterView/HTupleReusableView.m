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
        [_view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_view];
    }
    return _view;
}
- (void)layoutContentView {
    HLayoutReusableTupleView(self.view)
}
@end

@implementation HReusableLabelView
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        [_label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_label];
    }
    return _label;
}
- (void)layoutContentView {
    HLayoutReusableTupleView(self.label)
}
@end

@implementation HReusableTextView
- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        [_textView setScrollEnabled:NO];
        [_textView setUserInteractionEnabled:NO];
        [_textView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_textView];
    }
    return _textView;
}
- (void)layoutContentView {
    HLayoutReusableTupleView(self.textView)
}
@end

@implementation HReusableButtonView
- (HWebButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [HWebButtonView new];
        @weakify(self)
        [_buttonView setPressed:^(id sender, id data) {
            @strongify(self)
            if (self.reusableButtonViewBlock) {
                self.reusableButtonViewBlock(self.buttonView, self);
            }
        }];
        [_buttonView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_buttonView];
    }
    return _buttonView;
}
- (void)layoutContentView {
    HLayoutReusableTupleView(self.buttonView)
}
@end

@interface HReusableImageView ()
@property (nonatomic) UITapGestureRecognizer *tapGesture;
@end

@implementation HReusableImageView
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = [HWebImageView new];
        [_imageView setBackgroundColor:[UIColor clearColor]];
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
    if (_reusableImageViewBlock) {
        _reusableImageViewBlock(self.imageView, self);
    }
}
- (void)setReusableImageViewBlock:(HReusableImageViewBlock)reusableImageViewBlock {
    if (_reusableImageViewBlock != reusableImageViewBlock) {
        _reusableImageViewBlock = nil;
        _reusableImageViewBlock = reusableImageViewBlock;
        if (!self.tapGesture.view) {
            [self.imageView addGestureRecognizer:self.tapGesture];
        }
    }
}
- (void)layoutContentView {
    HLayoutReusableTupleView(self.imageView)
}
@end

@implementation HReusableVerticalView
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

@implementation HReusableHorizontalView
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

