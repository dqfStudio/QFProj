//
//  HTupleViewCell.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"

bool CGEdgeEqualToEdge(UIEdgeInsets edge1, UIEdgeInsets edge2) {
    bool equal = true;
    if (edge1.top != edge2.left) equal = false;
    else if (edge1.left != edge2.left) equal = false;
    else if (edge1.bottom != edge2.right) equal = false;
    else if (edge1.right != edge2.right) equal = false;
    return equal;
}

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

@interface HTextViewCell3 ()
@property (nonatomic) UIView *bgView;
@end

@implementation HTextViewCell3
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        [self addSubview:_bgView];
    }
    return _bgView;
}
- (UILabel *)upLabel {
    if (!_upLabel) {
        _upLabel = [UILabel new];
        [self.bgView addSubview:_upLabel];
    }
    return _upLabel;
}
- (UILabel *)downLabel {
    if (!_downLabel) {
        _downLabel = [UILabel new];
        [self.bgView addSubview:_downLabel];
    }
    return _downLabel;
}
- (void)layoutContentView {
    HLayoutTupleView(self.bgView)
    
    CGRect frame = [self getContentFrame];
    frame.origin = CGPointZero;
    
    frame.size.height /= 2;
    self.upLabel.frame = frame;
    
    frame.origin.y = frame.size.height;
    self.downLabel.frame = frame;
}
@end

@implementation HTextViewCell4
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
    HLayoutTupleView(self.textView)
}
@end

//@implementation HTextViewCell5
//- (YYLabel *)label {
//    if (!_label) {
//        _label = [YYLabel new];
//        [self addSubview:_label];
//    }
//    return _label;
//}
//- (void)layoutContentView {
//    HLayoutTupleView(self.label)
//}
//@end

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

@interface HImageViewCell2 ()
@property (nonatomic) UITapGestureRecognizer *tapGesture;
@end

@implementation HImageViewCell2
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
    if (_imageViewBlock) {
        _imageViewBlock(self.imageView, self);
    }
}
- (void)setImageViewBlock:(HImageViewBlock2)imageViewBlock {
    if (_imageViewBlock != imageViewBlock) {
        _imageViewBlock = nil;
        _imageViewBlock = imageViewBlock;
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

@interface HTextFieldCell () <UITextFieldDelegate>

@end

@implementation HTextFieldCell

- (UITextField *)textField {
    if (!_textField) {
        _textField = UITextField.new;
        [_textField setDelegate:self];
        [self addSubview:_textField];
    }
    return _textField;
}

- (void)layoutContentView {
    HLayoutTupleView(self.textField)
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.maxInput > 0) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > self.maxInput) {
            NSString *tmpString = nil;
            if (string.length > 1) {//复制字符串
                NSCharacterSet *characterSet = [NSCharacterSet whitespaceCharacterSet];
                string = [string stringByTrimmingCharactersInSet:characterSet];
                tmpString = [textField.text stringByAppendingString:string];
                //赋值
                textField.text = [tmpString substringToIndex:self.maxInput];
                //异步移动光标
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self cursorLocation:textField index:textField.text.length];
                });
            }else {//输入字符串
                tmpString = [textField.text stringByAppendingString:string];
                textField.text = [tmpString substringToIndex:self.maxInput];
            }
        }
        return (strLength <= self.maxInput);
    }
    return YES;
}
//移动光标
- (void)cursorLocation:(UITextField *)textField index:(NSInteger)index {
    NSRange range = NSMakeRange(index, 0);
    UITextPosition *start = [textField positionFromPosition:[textField beginningOfDocument] offset:range.location];
    UITextPosition *end = [textField positionFromPosition:start offset:range.length];
    [textField setSelectedTextRange:[textField textRangeFromPosition:start toPosition:end]];
}
@end

