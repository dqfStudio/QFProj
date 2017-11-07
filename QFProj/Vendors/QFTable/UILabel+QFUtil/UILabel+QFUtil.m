//
//  UILabel+QFUtill.m
//  TestProject
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "UILabel+QFUtil.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>

@implementation UILabel (QFUtil)

- (CGFloat)characterSpace {
    return [objc_getAssociatedObject(self,_cmd) floatValue];
}
- (void)setCharacterSpace:(CGFloat)characterSpace {
    objc_setAssociatedObject(self, @selector(characterSpace), @(characterSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lineSpace {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}
- (void)setLineSpace:(CGFloat)lineSpace {
    objc_setAssociatedObject(self, @selector(lineSpace), @(lineSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)keywords {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setKeywords:(NSString *)keywords {
    objc_setAssociatedObject(self, @selector(keywords), keywords, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)keywordsFont {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setKeywordsFont:(UIFont *)keywordsFont {
    objc_setAssociatedObject(self, @selector(keywordsFont), keywordsFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)keywordsColor {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setKeywordsColor:(UIColor *)keywordsColor {
    objc_setAssociatedObject(self, @selector(keywordsColor), keywordsColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)underlineStr {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setUnderlineStr:(NSString *)underlineStr {
    objc_setAssociatedObject(self, @selector(underlineStr), underlineStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (UIFont *)underlineFont {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setUnderlineFont:(UIFont *)underlineFont {
    objc_setAssociatedObject(self, @selector(underlineFont), underlineFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)underlineColor {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setUnderlineColor:(UIColor *)underlineColor {
    objc_setAssociatedObject(self, @selector(underlineColor), underlineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)middlelineStr {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setMiddlelineStr:(NSString *)middlelineStr {
    objc_setAssociatedObject(self, @selector(middlelineStr), middlelineStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)middlelineFont {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setMiddlelineFont:(UIFont *)middlelineFont {
    objc_setAssociatedObject(self, @selector(middlelineFont), middlelineFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)middlelineColor {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setMiddlelineColor:(UIColor *)middlelineColor {
    objc_setAssociatedObject(self, @selector(middlelineColor), middlelineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 计算label宽高，必须调用
 
 @param maxWidth 最大宽度
 @return label的size
 */
- (CGSize)sizeThatWidth:(CGFloat)maxWidth {
    CGSize maximumLabelSize = CGSizeMake(maxWidth, MAXFLOAT);//labelsize的最大值
    CGSize expectSize = [self sizeThatFits:maximumLabelSize];
    return expectSize;
}

/**
 使设置的格式有效
 */
- (void)formatThatFits {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0,self.text.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    // 行间距
    if (self.lineSpace > 0) {
        [paragraphStyle setLineSpacing:self.lineSpace];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,self.text.length)];
    }
    
    // 字间距
    if (self.characterSpace > 0) {
        long number = self.characterSpace;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
        CFRelease(num);
    }
    
    //关键字
    if (self.keywords && [self.text containsString:self.keywords]) {
        NSRange itemRange = [self.text rangeOfString:self.keywords];
        if (self.keywordsFont) {
            [attributedString addAttribute:NSFontAttributeName value:self.keywordsFont range:itemRange];
        }
        if (self.keywordsColor) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:self.keywordsColor range:itemRange];
        }
    }
    
    //下划线
    if (self.underlineStr && [self.text containsString:self.underlineStr]) {
        NSRange itemRange = [self.text rangeOfString:self.underlineStr];
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:itemRange];
        if (self.underlineFont) {
            [attributedString addAttribute:NSFontAttributeName value:self.underlineFont range:itemRange];
        }
        if (self.underlineColor) {
            [attributedString addAttribute:NSUnderlineColorAttributeName value:self.underlineColor range:itemRange];
        }
    }
    
    //中线
    if (self.middlelineStr && [self.text containsString:self.middlelineStr]) {
        NSRange itemRange = [self.text rangeOfString:self.middlelineStr];
        [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:itemRange];
        [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(NSUnderlineStyleSingle) range:itemRange];
        if (self.middlelineFont) {
            [attributedString addAttribute:NSFontAttributeName value:self.middlelineFont range:itemRange];
        }
        if (self.middlelineColor) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:self.middlelineColor range:itemRange];
        }
    }
    
    self.attributedText = attributedString;
}

@end
