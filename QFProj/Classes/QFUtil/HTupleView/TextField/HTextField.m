//
//  HTextField.m
//  QFProj
//
//  Created by wind on 2019/5/8.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTextField.h"

@implementation HTextField
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    [self setDelegate:self];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setRightViewMode:UITextFieldViewModeAlways];
    _forbidWhitespaceAndNewline = YES;
}
- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        [_leftLabel setBackgroundColor:[UIColor clearColor]];
        [self setLeftView:_leftLabel];
    }
    return _leftLabel;
}
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        [_rightLabel setBackgroundColor:[UIColor clearColor]];
        [self setRightView:_rightLabel];
    }
    return _rightLabel;
}
- (HWebImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = HWebImageView.new;
        [_leftImageView setBackgroundColor:[UIColor clearColor]];
        [self setLeftView:_leftImageView];
    }
    return _leftImageView;
}
- (HWebImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = HWebImageView.new;
        [_rightImageView setBackgroundColor:[UIColor clearColor]];
        [self setRightView:_rightImageView];
    }
    return _rightImageView;
}
- (HWebButtonView *)leftButton {
    if (!_leftButton) {
        _leftButton = [HWebButtonView new];
        [_leftButton setUserInteractionEnabled:NO];
        @weakify(self)
        [_leftButton setPressed:^(id sender, id data) {
            @strongify(self)
            if (self.leftButtonBlock) {
                self.leftButtonBlock(self.leftButton);
            }
        }];
        [_leftButton setBackgroundColor:[UIColor clearColor]];
        [self setLeftView:_leftButton];
    }
    return _leftButton;
}
- (void)setLeftButtonBlock:(HTextFieldBlock)leftButtonBlock {
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
                self.rightButtonBlock(self.rightButton);
            }
        }];
        [_rightButton setBackgroundColor:[UIColor clearColor]];
        [self setRightView:_rightButton];
    }
    return _rightButton;
}
- (void)setRightButtonBlock:(HTextFieldBlock)rightButtonBlock {
    if (_rightButtonBlock != rightButtonBlock) {
        _rightButtonBlock = rightButtonBlock;
        [self.rightButton setUserInteractionEnabled:YES];
    }
}
- (void)placeholderColor:(UIColor *)color {
    [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}
- (NSString *)trimmingWhitespaceAndNewline {
    NSString *content = [self.text mutableCopy];
    if (content.length > 0) {
        content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return content;
}
- (NSString *)trimmingAllWhitespaceAndNewline {
    NSString *content = [self.text mutableCopy];
    if (content.length > 0) {
        content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    return content;
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
        [self setText:[self trimmingAllWhitespaceAndNewline]];
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
#pragma mark - Rect
- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect normalRect = [super leftViewRectForBounds:bounds];
    normalRect.origin.x += self.leftInsets.left;
    return normalRect;
}
- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect normalRect = [super rightViewRectForBounds:bounds];
    normalRect.origin.x -= self.rightInsets.right;
    return normalRect;
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    return [self calculateTextRectForBounds:bounds];
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self calculateTextRectForBounds:bounds];
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return [self calculateTextRectForBounds:bounds];
}
- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    return [super clearButtonRectForBounds:bounds];
}
#pragma mark - Private
- (CGRect)calculateTextRectForBounds:(CGRect)bounds {
    CGRect frame = CGRectInset(bounds, 0, 0);
    frame.origin.x += self.leftInsets.left;
    frame.origin.x += self.leftInsets.right;
    if (self.leftView) {
        frame.origin.x += self.leftView.frame.size.width;
        frame.size.width -= frame.origin.x;
    }
    frame.size.width -= self.rightInsets.left;
    frame.size.width -= self.rightInsets.right;
    if (self.rightView) {
        frame.size.width -= self.rightView.frame.size.width;
    }
    //光标距右边输入框默认有10pt的距离
    //此处去掉此默认距离，以达到精准控制的目的
    frame.size.width += 10;
    return frame;
}
@end