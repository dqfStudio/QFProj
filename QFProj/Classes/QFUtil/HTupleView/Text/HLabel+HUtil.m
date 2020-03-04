//
//  HLabel+HUtill.m
//  HProj
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HLabel+HUtil.h"
#import <CoreText/CoreText.h>

@implementation HLabel (HUtil)

- (CGFloat)characterSpace {
    return [[self getAssociatedValueForKey:_cmd] floatValue];
}
- (void)setCharacterSpace:(CGFloat)characterSpace {
    [self setAssociateValue:@(characterSpace) withKey:@selector(characterSpace)];
}

- (CGFloat)lineSpace {
    return [[self getAssociatedValueForKey:_cmd] floatValue];
}
- (void)setLineSpace:(CGFloat)lineSpace {
    [self setAssociateValue:@(lineSpace) withKey:@selector(lineSpace)];
}


- (NSString *)keywords {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setKeywords:(NSString *)keywords {
    [self setAssociateValue:keywords withKey:@selector(keywords)];
}

- (UIFont *)keywordsFont {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setKeywordsFont:(UIFont *)keywordsFont {
    [self setAssociateValue:keywordsFont withKey:@selector(keywordsFont)];
}

- (UIColor *)keywordsColor {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setKeywordsColor:(UIColor *)keywordsColor {
    [self setAssociateValue:keywordsColor withKey:@selector(keywordsColor)];
}

- (HKeywordsBlock)keywordsBlock {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setKeywordsBlock:(HKeywordsBlock)keywordsBlock {
    [self setAssociateValue:keywordsBlock withKey:@selector(keywordsBlock)];
}

- (NSInteger)imgIndex {
    return [[self getAssociatedValueForKey:_cmd] integerValue];
}
- (void)setImgIndex:(NSInteger)imgIndex {
    [self setAssociateValue:@(imgIndex) withKey:@selector(imgIndex)];
}

- (HWordAlign)wordAlign {
    return [[self getAssociatedValueForKey:_cmd] integerValue];
}
- (void)setWordAlign:(HWordAlign)wordAlign {
    [self setAssociateValue:@(wordAlign) withKey:@selector(wordAlign)];
}

- (CGSize)imgSize {
    return CGSizeFromString([self getAssociatedValueForKey:_cmd]);
}
- (void)setImgSize:(CGSize)imgSize {
    [self setAssociateValue:NSStringFromCGSize(imgSize) withKey:@selector(imgSize)];
}

- (NSString *)imgUrl {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setImgUrl:(NSString *)imgUrl {
    [self setAssociateValue:imgUrl withKey:@selector(imgUrl)];
}

- (NSInteger)leftSpace {
    return [[self getAssociatedValueForKey:_cmd] integerValue];
}
- (void)setLeftSpace:(NSInteger)leftSpace {
    [self setAssociateValue:@(leftSpace) withKey:@selector(leftSpace)];
}

- (NSInteger)rightSpace {
    return [[self getAssociatedValueForKey:_cmd] integerValue];
}
- (void)setRightSpace:(NSInteger)rightSpace {
    [self setAssociateValue:@(rightSpace) withKey:@selector(rightSpace)];
}

- (NSString *)underlineStr {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setUnderlineStr:(NSString *)underlineStr {
    [self setAssociateValue:underlineStr withKey:@selector(underlineStr)];
    
}

- (UIFont *)underlineFont {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setUnderlineFont:(UIFont *)underlineFont {
    [self setAssociateValue:underlineFont withKey:@selector(underlineFont)];
}

- (UIColor *)underlineColor {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setUnderlineColor:(UIColor *)underlineColor {
    [self setAssociateValue:underlineColor withKey:@selector(underlineColor)];
}

- (NSString *)middlelineStr {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setMiddlelineStr:(NSString *)middlelineStr {
    [self setAssociateValue:middlelineStr withKey:@selector(middlelineStr)];
}

- (UIFont *)middlelineFont {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setMiddlelineFont:(UIFont *)middlelineFont {
    [self setAssociateValue:middlelineFont withKey:@selector(middlelineFont)];
}

- (UIColor *)middlelineColor {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setMiddlelineColor:(UIColor *)middlelineColor {
    [self setAssociateValue:middlelineColor withKey:@selector(middlelineColor)];
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
 获取上述设置的属性字符串，此方法需要在所有属性设置后调用
 */
- (NSMutableAttributedString *)getCustomFormatString {
    if (!self.text) self.text = @"";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0,self.text.length)];
    attributedString.h_alignment = self.textAlignment;
    attributedString.h_font = self.font;
    attributedString.h_color = self.textColor;
    
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
    
    //插入图片
    if (self.imgUrl.length > 0 && ![NSStringFromCGSize(self.imgSize) isEqualToString:NSStringFromCGSize(CGSizeZero)]) {
        NSTextAttachment *attch  = [[NSTextAttachment alloc] init];
        NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:attch];
        NSMutableAttributedString *leftSpaceString = [[NSMutableAttributedString alloc] init];
        NSMutableAttributedString *rightSpaceString = [[NSMutableAttributedString alloc] init];
        for (int i=0; i<self.leftSpace; i++) {
            [leftSpaceString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        }
        for (int i=0; i<self.rightSpace; i++) {
            [rightSpaceString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        }
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
        [string appendAttributedString:leftSpaceString];
        [string appendAttributedString:imageString];
        [string appendAttributedString:rightSpaceString];
        
        if ([self.imgUrl containsString:@"http://"] || [self.imgUrl containsString:@"https://"]) {
            //            [self loadImageForUrl:url toAttach:attch syncLoadCache:NO range:range text:temp];
        }else {//加载本地图片
            if ([NSStringFromCGSize(CGSizeZero) isEqualToString:NSStringFromCGSize(self.frame.size)]) {
                CGSize imageSize = self.imgSize;
                CGSize frameSize = self.imgSize;
                CGSize  wordSize = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
                
                frameSize.width = imageSize.width + wordSize.width;
                if (wordSize.width > 0 && wordSize.height > imageSize.height) {
                    frameSize.height = wordSize.height;
                }
                
                attch.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
                attch.image = [UIImage imageNamed:self.imgUrl];
                
                CGRect frame = CGRectZero;
                frame.origin = self.frame.origin;
                frame.size = frameSize;
                self.frame = frame;
            }else {
                //调整图片大小
                CGSize imageSize = self.imgSize;
                attch.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
                attch.image = [UIImage imageNamed:self.imgUrl];
            }
        }
        
        //调整图片位置使文字居上居中居下显示
        switch (self.wordAlign) {
            case HWordAlignBottom: {
                CGSize  imageSize = attch.bounds.size;
                attch.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
            }
                break;
            case HWordAlignCenter: {
                CGSize  imageSize = attch.bounds.size;
                CGSize  wordSize = [self.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
                CGFloat height = imageSize.height-wordSize.height;
                if (height > 0) height = -height/2.0;
                else height = height/2.0;
                if (wordSize.width <= 0) height = 0;
                attch.bounds = CGRectMake(0, height, imageSize.width, imageSize.height);
            }
                break;
            case HWordAlignTop: {
                CGSize  imageSize = attch.bounds.size;
                CGSize  wordSize = [self.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
                CGFloat height = imageSize.height-wordSize.height;
                if (height > 0) height = -height;
                if (wordSize.width <= 0) height = 0;
                attch.bounds = CGRectMake(0, height, imageSize.width, imageSize.height);
            }
                break;
                
            default:
                break;
        }
        
        //插入图片，插到某个序号前面
        if (self.imgIndex < 0) {
            [attributedString insertAttributedString:string atIndex:0];
        }else if (self.imgIndex >= self.text.length) {
            [attributedString appendAttributedString:string];
        }else {
            [attributedString insertAttributedString:string atIndex:self.imgIndex];
        }
        
    }else if ([NSStringFromCGSize(CGSizeZero) isEqualToString:NSStringFromCGSize(self.frame.size)]) {
        CGSize  wordSize = [self.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
        CGRect frame = CGRectZero;
        frame.origin = self.frame.origin;
        frame.size = wordSize;
        self.frame = frame;
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
        NSRange range = [self.text rangeOfString:self.keywords];
        [attributedString h_setTextHighlightRange:range
                                            color:self.keywordsColor
                                  backgroundColor:self.keywordsColor
                                        tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                                            if (self.keywordsBlock) {
                                               self.keywordsBlock();
                                            }
                                        }];
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
    return attributedString;
}

/**
 使设置的格式有效
 */
- (void)formatThatFits {
    self.attributedText = [self getCustomFormatString];
}

@end
