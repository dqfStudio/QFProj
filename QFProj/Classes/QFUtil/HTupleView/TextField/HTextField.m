//
//  HTextField.m
//  QFProj
//
//  Created by wind on 2019/5/8.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTextField.h"
#import <objc/runtime.h>

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
    _forbidWhitespaceAndNewline = YES;
    _editEnabled = YES;
}
- (HLabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [HLabel new];
        [self setLeftViewMode:UITextFieldViewModeAlways];
        [self setLeftView:_leftLabel];
    }
    return _leftLabel;
}
- (HLabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [HLabel new];
        [self setRightViewMode:UITextFieldViewModeAlways];
        [self setRightView:_rightLabel];
    }
    return _rightLabel;
}
- (HWebImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = HWebImageView.new;
        [self setLeftViewMode:UITextFieldViewModeAlways];
        [self setLeftView:_leftImageView];
    }
    return _leftImageView;
}
- (HWebImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = HWebImageView.new;
        [self setRightViewMode:UITextFieldViewModeAlways];
        [self setRightView:_rightImageView];
    }
    return _rightImageView;
}
- (HWebButtonView *)leftButton {
    if (!_leftButton) {
        _leftButton = [HWebButtonView new];
        [self setLeftViewMode:UITextFieldViewModeAlways];
        [self setLeftView:_leftButton];
    }
    return _leftButton;
}
- (HWebButtonView *)rightButton {
    if (!_rightButton) {
        _rightButton = [HWebButtonView new];
        [self setRightViewMode:UITextFieldViewModeAlways];
        [self setRightView:_rightButton];
    }
    return _rightButton;
}
- (NSString *)trimmingWhitespaceAndNewline {
    if (self.text.length > 0) {
        return [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return self.text;
}
- (NSString *)trimmingAllWhitespaceAndNewline {
    NSString *content = nil;
    if (self.text.length > 0) {
        content = [self.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        return content;
    }
    return self.text;
}
#pragma mark - 字体
- (NSString *)placeholder {
    return self.attributedPlaceholder.string;
}
- (void)setPlaceholder:(NSString *)placeholder {
    if (placeholder.length > 0) {
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholder];
        NSRange range = NSMakeRange(0, placeholder.length);
        if(self.placeholderFont) {//字体
            [placeholderString addAttribute:NSFontAttributeName value:self.placeholderFont range:range];
        }
        if(self.placeholderColor) {//颜色
            [placeholderString addAttribute:NSForegroundColorAttributeName value:self.placeholderColor range:range];
        }
        self.attributedPlaceholder = placeholderString;
    }
}
#pragma mark - 字体大小
- (UIFont *)placeholderFont {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    if (placeholderFont && placeholderFont != self.placeholderFont && self.attributedPlaceholder.length > 0) {
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedPlaceholder];
        NSRange range = NSMakeRange(0, placeholderString.length);
        [placeholderString addAttribute:NSFontAttributeName value:placeholderFont range:range];
        self.attributedPlaceholder = placeholderString;
    }
    objc_setAssociatedObject(self, @selector(placeholderFont), placeholderFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - 字体颜色
- (UIColor *)placeholderColor {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if (placeholderColor && placeholderColor != self.placeholderColor && self.attributedPlaceholder.length > 0) {
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedPlaceholder];
        NSRange range = NSMakeRange(0, placeholderString.length);
        [placeholderString addAttribute:NSForegroundColorAttributeName value:placeholderColor range:range];
        self.attributedPlaceholder = placeholderString;
    }
    objc_setAssociatedObject(self, @selector(placeholderColor), placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - delegate
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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return self.editEnabled;
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
    //frame.size.width += 10;
    return frame;
}
@end

@implementation HTextField (HValidate)

- (BOOL)isValidatedUserName {
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,11}$";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isValidatedPassword {
    NSString *regex = @"[a-zA-Z0-9]{6,12}$";
    return [self isValidateWithRegex:regex];
}


- (BOOL)isEmpty {
    return (self.trimmingWhitespaceAndNewline.length == 0);
}
- (BOOL)isOnlyAlpha {
    NSString *regex = @"[a-zA-Z]*";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isOnlyNumeric {
    NSString *regex = @"[0-9]*";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isAlphaNumeric {
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{2,10000}$";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isAlphaOrNumeric {
    NSString *regex = @"^[A-Za-z0-9]+$";
    return [self isValidateWithRegex:regex];
}



- (BOOL)isValidatedEmial {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isValidatedVCode {
    NSString *regex = @"[0-9]{4,6}";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isValidatedMobile {
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 16[6], 17[5, 6, 7, 8], 18[0-9], 170[0-9], 19[89]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705,198
     * 联通号段: 130,131,132,155,156,185,186,145,175,176,1709,166
     * 电信号段: 133,153,180,181,189,177,1700,199
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|6[6]|7[05-8]|8[0-9]|9[89])\\d{8}$";
    
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478]|9[8])\\d{8}$)|(^1705\\d{7}$)";
    
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|66|7[56]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    
    NSString *CT = @"(^1(33|53|77|8[019]|99)\\d{8}$)|(^1700\\d{7}$)";
    
    if([self isValidateWithRegex:MOBILE] || [self isValidateWithRegex:CM] || [self isValidateWithRegex:CU] || [self isValidateWithRegex:CT]) {
        return YES;
    }else {
        return NO;
    }
}
- (BOOL)isValidatedIDCard {
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [self isValidateWithRegex:regex];
}



- (BOOL)isValidatedCarNo {
    NSString *regex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isValidatedCarType {
    NSString *regex = @"^[\u4E00-\u9FFF]+$";
    return [self isValidateWithRegex:regex];
}



- (BOOL)isOnlyChinese {
    NSString *regex = @"[\u4e00-\u9fa5]+";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isValidatedWechat {
    NSString *regex = @"^[a-zA-Z]([-_a-zA-Z0-9]{5,19})+$";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isValidatedBankCard {
    NSString *regex = @"[1-9]([0-9]{13,19})";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isContainIllegalCharacters {
    NSString *regex = @"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    return ![self isValidateWithRegex:regex];
}



- (BOOL (^)(NSInteger start, NSInteger end))isBetween {
    return ^BOOL (NSInteger start, NSInteger end) {
        if (self.text.length >= start && self.text.length <= end) {
            return YES;
        }
        return NO;
    };
}
- (BOOL)isValidateWithRegex:(NSString *)regex {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex] evaluateWithObject:self.text];
}
@end
