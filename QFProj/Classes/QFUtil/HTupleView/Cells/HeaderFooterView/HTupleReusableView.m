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

@implementation HReusableLabelView
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

@implementation HReusableTextView
- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        [_textView setScrollEnabled:NO];
        [_textView setUserInteractionEnabled:NO];
        [self addSubview:_textView];
    }
    return _textView;
}
- (void)layoutContentView {
    HLayoutReusableView(self.textView)
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
        [self addSubview:_buttonView];
    }
    return _buttonView;
}
- (void)layoutContentView {
    HLayoutReusableView(self.buttonView)
}
@end

@interface HReusableImageView ()
@property (nonatomic) UITapGestureRecognizer *tapGesture;
@end

@implementation HReusableImageView
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
    HLayoutReusableView(self.imageView)
}
@end

@interface HReusableImageView2 ()
@property (nonatomic) UITapGestureRecognizer *tapGesture;
@end

@implementation HReusableImageView2
- (void)initUI {
    //默认高度为20
    self.labelHeight = 20;
}
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = [HWebImageView new];
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        [self addSubview:_label];
    }
    return _label;
}
- (void)setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets {
    if(!CGEdgeEqualToEdge(_imageEdgeInsets, imageEdgeInsets)) {
        _imageEdgeInsets = imageEdgeInsets;
        [self layoutContentView];
    }
}
- (void)setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    if(!CGEdgeEqualToEdge(_titleEdgeInsets, titleEdgeInsets)) {
        _titleEdgeInsets = titleEdgeInsets;
        [self layoutContentView];
    }
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
- (void)setReusableImageViewBlock:(HReusableImageViewBlock2)reusableImageViewBlock {
    if (_reusableImageViewBlock != reusableImageViewBlock) {
        _reusableImageViewBlock = nil;
        _reusableImageViewBlock = reusableImageViewBlock;
        if (!self.tapGesture.view) {
            [self addGestureRecognizer:self.tapGesture];
        }
    }
}
- (void)layoutContentView {
    //设置label的frame
    CGRect frame = [self getContentFrame];
    
    frame.origin.x += self.titleEdgeInsets.left;
    frame.size.width -= self.titleEdgeInsets.left + self.titleEdgeInsets.right;
    
    frame.origin.y = frame.size.height - self.labelHeight;
    frame.origin.y += self.titleEdgeInsets.top;
    frame.size.height = self.labelHeight - self.titleEdgeInsets.top - self.titleEdgeInsets.bottom;
    [self.label setFrame:frame];
    
    //设置imageView的frame
    frame = [self getContentFrame];
    
    frame.origin.x += self.imageEdgeInsets.left;
    frame.size.width -= self.imageEdgeInsets.left + self.imageEdgeInsets.right;
    
    frame.origin.y += self.imageEdgeInsets.top;
    frame.size.height -= self.labelHeight + self.imageEdgeInsets.top + self.imageEdgeInsets.bottom;
    [self.imageView setFrame:frame];
}
@end

