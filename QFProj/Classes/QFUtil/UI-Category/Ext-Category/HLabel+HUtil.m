//
//  HLabel+HUtil.m
//  QFProj
//
//  Created by wind on 2019/6/7.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HLabel+HUtil.h"
#import <CoreText/CoreText.h>

@implementation HLabel (HUtil)

- (NSMutableAttributedString *)mutableAttributedString {
    NSMutableAttributedString *attributedString = [self getAssociatedValueForKey:_cmd];
    if (!attributedString) {
        NSString *content = [self.text mutableCopy];
        content = content ?: @"";
        attributedString = [NSMutableAttributedString attributedWithString:content
                                                                attributed:@{NSFontAttributeName: self.font}];
        [self setMutableAttributedString:attributedString];
    }
    return attributedString;
}
- (void)setMutableAttributedString:(NSMutableAttributedString *)mutableAttributedString {
    [self setAssociateValue:mutableAttributedString withKey:@selector(mutableAttributedString)];
}

//字间距
- (void)setCharSpace:(CGFloat)space {
    if (space >= 0) {
        NSMutableDictionary *dict = NSMutableDictionary.dictionary;
        long number = space;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [dict setObject:(__bridge id)num forKey:(id)kCTKernAttributeName];
        [self.mutableAttributedString attributedWith:dict];
        CFRelease(num);
        self.attributedText = self.mutableAttributedString;
    }
}

//行间距
- (void)setLineSpace:(CGFloat)space {
    if (space >= 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = self.textAlignment;
        paragraphStyle.lineBreakMode = self.lineBreakMode;
        [paragraphStyle setLineSpacing:space];
        NSMutableDictionary *dict = NSMutableDictionary.dictionary;
        [dict setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        [self.mutableAttributedString attributedWith:dict];
        self.attributedText = self.mutableAttributedString;
    }
}

//关键字
- (void)setKeywords:(NSString *)keywords font:(UIFont *)font color:(UIColor *)color {
    if (keywords && [self.text containsString:keywords]) {
        NSRange itemRange = [self.text rangeOfString:keywords];
        if (font) [self.mutableAttributedString h_setFont:font range:itemRange];
        if (color) [self.mutableAttributedString h_setColor:color range:itemRange];
        self.attributedText = self.mutableAttributedString;
    }
}

//点击事件
- (void)setTapKeywords:(NSString *)keywords color:(UIColor *)color block:(HTapKeywordsBlock)tapBlock {
    if (keywords.length > 0 && tapBlock) {
        NSRange range = [self.text rangeOfString:keywords];
        [self.mutableAttributedString h_setTextHighlightRange:range
                                                      color:color
                                            backgroundColor:color
                                                  tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                                                      if (tapBlock) {
                                                          tapBlock();
                                                      }
                                                  }];
        self.attributedText = self.mutableAttributedString;
    }
}

//中线
- (void)setMiddleline:(NSString *)keywords font:(UIFont *)font color:(UIColor *)color {
    if (keywords && [self.text containsString:keywords]) {
        NSRange itemRange = [self.text rangeOfString:keywords];
        NSMutableDictionary *dict = NSMutableDictionary.dictionary;
        [dict setObject:@(NSUnderlineStyleSingle) forKey:NSBaselineOffsetAttributeName];
        [dict setObject:@(NSUnderlineStyleSingle) forKey:NSStrikethroughStyleAttributeName];
        [self.mutableAttributedString h_setStrikethroughStyle:NSUnderlineStyleSingle range:itemRange];
        if (font) {
            [dict setObject:font forKey:NSFontAttributeName];
        }
        if (color) {
            [dict setObject:color forKey:NSForegroundColorAttributeName];
        }
        if (dict.count > 0) {
            [self.mutableAttributedString attributedWithRange:itemRange attributed:dict];
            self.attributedText = self.mutableAttributedString;
        }
    }
}

//下划线
- (void)setUnderline:(NSString *)keywords color:(UIColor *)color {
    if (keywords && [self.text containsString:keywords]) {
        NSRange itemRange = [self.text rangeOfString:keywords];
        [self.mutableAttributedString h_setUnderlineStyle:NSUnderlineStyleSingle range:itemRange];
        if (color) [self.mutableAttributedString h_setUnderlineColor:color range:itemRange];
        self.attributedText = self.mutableAttributedString;
    }
}

//字间距
- (void)setCharWith:(NSArray <NSNumber *>*)idxs space:(NSArray <NSNumber *>*)spaces {
    if (idxs.count == spaces.count && idxs.count > 0) {
        for (int i=0; i<idxs.count; i++) {
            NSNumber *idx = idxs[i];
            NSNumber *space = spaces[i];
            long number = space.longValue;
            CFNumberRef numberRef = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
            NSMutableDictionary *dict = NSMutableDictionary.dictionary;
            [dict setObject:(__bridge id)numberRef forKey:(id)kCTKernAttributeName];
            NSRange range = NSMakeRange(idx.integerValue, 1);
            [self.mutableAttributedString attributedWithRange:range attributed:dict];
            CFRelease(numberRef);
        }
        self.attributedText = self.mutableAttributedString;
    }
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

@end
