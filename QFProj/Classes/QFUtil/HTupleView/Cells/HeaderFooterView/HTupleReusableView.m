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
- (HRichLabel *)label {
    if (!_label) {
        _label = [HRichLabel new];
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
            if (self.buttonViewBlock) {
                self.buttonViewBlock(self.buttonView, self);
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
    if (_imageViewBlock) {
        _imageViewBlock(self.imageView, self);
    }
}
- (void)setImageViewBlock:(HReusableImageViewBlock)imageViewBlock {
    if (_imageViewBlock != imageViewBlock) {
        _imageViewBlock = nil;
        _imageViewBlock = imageViewBlock;
        if (!self.tapGesture.view) {
            [self.imageView addGestureRecognizer:self.tapGesture];
        }
    }
}
- (void)layoutContentView {
    HLayoutReusableTupleView(self.imageView)
}
@end

@interface HReusableTextFieldCell () <UITextFieldDelegate>

@end

@implementation HReusableTextFieldCell
- (UITextField *)textField {
    if (!_textField) {
        _textField = UITextField.new;
        [_textField setDelegate:self];
        [_textField setBackgroundColor:[UIColor clearColor]];
        [_textField setLeftViewMode:UITextFieldViewModeAlways];
        [_textField setRightViewMode:UITextFieldViewModeAlways];
        _forbidWhitespaceAndNewline = YES;
        [self addSubview:_textField];
    }
    return _textField;
}
- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        [_leftLabel setBackgroundColor:[UIColor clearColor]];
        [self.textField setLeftView:_leftLabel];
    }
    return _leftLabel;
}
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        [_rightLabel setBackgroundColor:[UIColor clearColor]];
        [self.textField setLeftView:_rightLabel];
    }
    return _rightLabel;
}
- (HWebButtonView *)leftButton {
    if (!_leftButton) {
        _leftButton = [HWebButtonView new];
        [_leftButton setUserInteractionEnabled:NO];
        @weakify(self)
        [_leftButton setPressed:^(id sender, id data) {
            @strongify(self)
            if (self.leftButtonBlock) {
                self.leftButtonBlock(self.leftButton, nil);
            }
        }];
        [_leftButton setBackgroundColor:[UIColor clearColor]];
        [self.textField setLeftView:_leftButton];
    }
    return _leftButton;
}
- (void)setLeftButtonBlock:(HReusableButtonViewBlock)leftButtonBlock {
    if (_leftButtonBlock != leftButtonBlock) {
        _leftButtonBlock = leftButtonBlock;
        [self.leftButton setUserInteractionEnabled:YES];
    }
}
- (HWebButtonView *)rightButton {
    if (!_rightButton) {
        _rightButton = [HWebButtonView new];
        [_rightButton setUserInteractionEnabled:NO];
        @weakify(self)
        [_rightButton setPressed:^(id sender, id data) {
            @strongify(self)
            if (self.rightButtonBlock) {
                self.rightButtonBlock(self.rightButton, nil);
            }
        }];
        [_rightButton setBackgroundColor:[UIColor clearColor]];
        [self.textField setLeftView:_rightButton];
    }
    return _rightButton;
}
- (void)setRightButtonBlock:(HReusableButtonViewBlock)rightButtonBlock {
    if (_rightButtonBlock != rightButtonBlock) {
        _rightButtonBlock = rightButtonBlock;
        [self.rightButton setUserInteractionEnabled:YES];
    }
}
- (void)setPlaceholder:(NSString *)placeholder {
    [self.textField setPlaceholder:placeholder];
}
- (void)placeholderColor:(UIColor *)color {
    [self.textField setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}
- (NSString *)trimmingWhitespaceAndNewline {
    NSString *content = [self.textField.text mutableCopy];
    if (content.length > 0) {
        content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return content;
}
- (NSString *)trimmingAllWhitespaceAndNewline {
    NSString *content = [self.textField.text mutableCopy];
    if (content.length > 0) {
        content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    return content;
}
- (void)layoutContentView {
    HLayoutTupleView(self.textField)
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.forbidWhitespaceAndNewline && string.length == 1) {//输入字符串
        if ([string containsString:@" "] || [string containsString:@"\n"]) {
            return NO;
        }
    }
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
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.forbidWhitespaceAndNewline) {
        [self.textField setText:[self trimmingAllWhitespaceAndNewline]];
    }
}
//移动光标
- (void)cursorLocation:(UITextField *)textField index:(NSInteger)index {
    NSRange range = NSMakeRange(index, 0);
    UITextPosition *start = [textField positionFromPosition:[textField beginningOfDocument] offset:range.location];
    UITextPosition *end = [textField positionFromPosition:start offset:range.length];
    [textField setSelectedTextRange:[textField textRangeFromPosition:start toPosition:end]];
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.forbidPaste) {
        if([UIMenuController sharedMenuController]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
            }];
            return NO;
        }
    }
    return [super canPerformAction:action withSender:sender];
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

