//
//  UILabel+HState.m
//  QFProj
//
//  Created by dqf on 2018/5/18.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "UILabel+HState.h"
#import <objc/runtime.h>

#ifndef DYNAMIC
#define DYNAMIC(_getter_, _setter_, _type_) \
- (void)_setter_ : (_type_)object { \
objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
} \
- (_type_)_getter_ { \
return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif

@interface UILabel ()

@property (nonatomic) UILabelState labelState;

@property (nonatomic, getter=isSelecting) BOOL selecting; // default is NO

@property (nonatomic) NSString *normalText;
@property (nonatomic) NSString *selectedText;

@property (nonatomic) UIColor *normalColor;
@property (nonatomic) UIColor *selectedColor;

@property (nonatomic) UIFont *normalFont;
@property (nonatomic) UIFont *selectedFont;

@property (nonatomic) NSAttributedString *normalAttributedText;
@property (nonatomic) NSAttributedString *selectedAttributedText;

@property (nonatomic) UIColor *normalBackgroundColor;
@property (nonatomic) UIColor *selectedBackgroundColor;

@end

@implementation UILabel (HState)

DYNAMIC(normalText,setNormalText,NSString*)
DYNAMIC(selectedText,setSelectedText,NSString*)

DYNAMIC(normalColor,setNormalColor,UIColor*)
DYNAMIC(selectedColor,setSelectedColor,UIColor*)

DYNAMIC(normalFont,setNormalFont,UIFont*)
DYNAMIC(selectedFont,setSelectedFont,UIFont*)

DYNAMIC(normalAttributedText,setNormalAttributedText,NSAttributedString*)
DYNAMIC(selectedAttributedText,setSelectedAttributedText,NSAttributedString*)

DYNAMIC(normalBackgroundColor,setNormalBackgroundColor,UIColor*)
DYNAMIC(selectedBackgroundColor,setSelectedBackgroundColor,UIColor*)

- (UILabelState)labelState {
    if (objc_getAssociatedObject(self, _cmd)) {
        UILabelState state = UILabelStateNormal;
        NSInteger integer = [objc_getAssociatedObject(self, _cmd) integerValue];
        if (integer == UILabelStateSelected) state = UILabelStateSelected;
        return state;
    } else {
        return UILabelStateNormal;
    }
}

- (void)setLabelState:(UILabelState)labelState {
    objc_setAssociatedObject(self, @selector(labelState), @(labelState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isSelecting {
    if (objc_getAssociatedObject(self, _cmd)) {
        return [objc_getAssociatedObject(self, _cmd) boolValue];
    } else {
        return NO;
    }
}

- (void)setSelecting:(BOOL)selecting {
    objc_setAssociatedObject(self, @selector(isSelecting), @(selecting), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isSelected {
    if (self.labelState == UILabelStateSelected) return YES;
    return NO;
}

- (void)setSelected:(BOOL)selected {
    if (!self.isSelecting) {
        [self setSelecting:YES];
        if (selected) {
            self.labelState = UILabelStateSelected;
            if (self.selectedText) [self setText:self.selectedText];
            if (self.selectedColor) [self setTextColor:self.selectedColor];
            if (self.selectedFont) [self setFont:self.selectedFont];
            //如果attributedText有值，则优先级高于text
            if (self.selectedAttributedText) [self setAttributedText:self.selectedAttributedText];
            if (self.selectedBackgroundColor) [self setBackgroundColor:self.selectedBackgroundColor];
        }else {
            self.labelState = UILabelStateNormal;
            [self setText:self.normalText];
            if (self.normalColor) [self setTextColor:self.normalColor];
            if (self.normalFont) [self setFont:self.normalFont];
            //如果attributedText有值，则优先级高于text
            if (self.normalAttributedText) [self setAttributedText:self.normalAttributedText];
            if (self.normalBackgroundColor) [self setBackgroundColor:self.normalBackgroundColor];
        }
        [self setSelecting:NO];
    }else {
        NSLog(@"正在设置中，请稍后重试！");
    }
}

- (void)setText:(NSString *)text forState:(UILabelState)state {
    switch (state) {
        case UILabelStateNormal:
            [self setNormalText:text];
            break;
        case UILabelStateSelected:
            [self setSelectedText:text];
            break;
        default:
            break;
    }
    if (self.isSelected && self.selectedText) {
        [self setText:self.selectedText];
    }else {
        [self setText:self.normalText];
    }
}

- (void)setTextColor:(nullable UIColor *)color forState:(UILabelState)state {
    switch (state) {
        case UILabelStateNormal:
            [self setNormalColor:color];
            break;
        case UILabelStateSelected:
            [self setSelectedColor:color];
            break;
        default:
            break;
    }
    if (self.isSelected && self.selectedColor) {
        [self setTextColor:self.selectedColor];
    }else {
        [self setTextColor:self.normalColor];
    }
}

- (void)setFont:(nullable UIFont *)font forState:(UILabelState)state {
    switch (state) {
        case UILabelStateNormal:
            [self setNormalFont:font];
            break;
        case UILabelStateSelected:
        [self setSelectedFont:font];
            break;
        default:
            break;
    }
    if (self.isSelected && self.selectedFont) {
        [self setFont:self.selectedFont];
    }else {
        [self setFont:self.normalFont];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText forState:(UILabelState)state {
    switch (state) {
        case UILabelStateNormal:
            [self setNormalAttributedText:attributedText];
            break;
        case UILabelStateSelected:
            [self setSelectedAttributedText:attributedText];
            break;
        default:
            break;
    }
    if (self.isSelected && self.selectedAttributedText) {
        [self setAttributedText:self.selectedAttributedText];
    }else {
        [self setAttributedText:self.normalAttributedText];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UILabelState)state {
    switch (state) {
        case UILabelStateNormal:
            [self setNormalBackgroundColor:backgroundColor];
            break;
        case UILabelStateSelected:
            [self setSelectedBackgroundColor:backgroundColor];
            break;
        default:
            break;
    }
    if (self.isSelected && self.selectedBackgroundColor) {
        [self setBackgroundColor:self.selectedBackgroundColor];
    }else {
        [self setBackgroundColor:self.normalBackgroundColor];
    }
}

@end
