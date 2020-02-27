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

@interface UILabel (_HState)

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
    return [[self getAssociatedValueForKey:_cmd] integerValue];
}
- (void)setLabelState:(UILabelState)labelState {
    [self setAssociateValue:@(labelState) withKey:@selector(labelState)];
}

- (BOOL)isSelecting {
    return [[self getAssociatedValueForKey:_cmd] boolValue];
}
- (void)setSelecting:(BOOL)selecting {
    [self setAssociateValue:@(selecting) withKey:@selector(isSelecting)];
}

- (BOOL)isSelected {
    return self.labelState = UILabelStateSelected ? YES : NO;
}
- (void)setSelected:(BOOL)selected {
    if (!self.isSelecting) {
        @synchronized(self) {

            self.selecting = YES;
            
            self.labelState = self.isSelected ? UILabelStateSelected : UILabelStateNormal;
            self.text = self.isSelected ? self.selectedText : self.normalText;
            self.textColor = self.isSelected ? self.selectedColor : self.normalColor;
            self.font = self.isSelected ? self.selectedFont : self.normalFont;
            self.attributedText = self.isSelected ? self.selectedAttributedText : self.normalAttributedText;
            self.backgroundColor = self.isSelected ? self.selectedBackgroundColor : self.normalBackgroundColor;
            
            self.selecting = NO;
        }
    }else {
        NSLog(@"正在设置中，请稍后重试！");
    }
}

- (void)setText:(NSString *)text forState:(UILabelState)state {
    state ? (self.selectedText = text) : (self.normalText = text);
    self.text = self.isSelected ? self.selectedText : self.normalText;
}

- (void)setTextColor:(nullable UIColor *)color forState:(UILabelState)state {
    state ? (self.selectedColor = color) : (self.normalColor = color);
    self.textColor = self.isSelected ? self.selectedColor : self.normalColor;
}

- (void)setFont:(nullable UIFont *)font forState:(UILabelState)state {
    state ? (self.selectedFont = font) : (self.normalFont = font);
    self.font = self.isSelected ? self.selectedFont : self.normalFont;
}

- (void)setAttributedText:(NSAttributedString *)attributedText forState:(UILabelState)state {
    state ? (self.selectedAttributedText = attributedText) : (self.normalAttributedText = attributedText);
    self.attributedText = self.isSelected ? self.selectedAttributedText : self.normalAttributedText;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UILabelState)state {
    state ? (self.selectedBackgroundColor = backgroundColor) : (self.normalBackgroundColor = backgroundColor);
    self.backgroundColor = self.isSelected ? self.selectedBackgroundColor : self.normalBackgroundColor;
}

@end
