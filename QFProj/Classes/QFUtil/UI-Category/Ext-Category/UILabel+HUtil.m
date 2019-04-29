//
//  UILabel+HUtill.m
//  TestProject
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "UILabel+HUtil.h"
#import <CoreText/CoreText.h>

@implementation UILabel (HUtil)

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
- (void)setKeywords:(NSString *)keywords font:(NSFont *)font color:(UIColor *)color {
    if (keywords && [self.text containsString:keywords]) {
        NSRange itemRange = [self.text rangeOfString:keywords];
        NSMutableDictionary *dict = NSMutableDictionary.dictionary;
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

//点击事件
- (void)setTapKeywords:(NSArray *)keywords block:(HTapKeywordsBlock)tapBlock {
    if (keywords.count > 0) {
        self.attributedText = self.mutableAttributedString;
        [self addAttributeTapActionWithStrings:keywords tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
            if (tapBlock) {
                tapBlock(index);
            }
        }];
    }
}

//中线
- (void)setMiddleline:(NSString *)keywords font:(NSFont *)font color:(UIColor *)color {
    if (keywords && [self.text containsString:keywords]) {
        NSRange itemRange = [self.text rangeOfString:keywords];
        NSMutableDictionary *dict = NSMutableDictionary.dictionary;
        [dict setObject:@(NSUnderlineStyleSingle) forKey:NSBaselineOffsetAttributeName];
        [dict setObject:@(NSUnderlineStyleSingle) forKey:NSStrikethroughStyleAttributeName];
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
- (void)setUnderline:(NSString *)keywords font:(NSFont *)font color:(UIColor *)color {
    if (keywords && [self.text containsString:keywords]) {
        NSRange itemRange = [self.text rangeOfString:keywords];
        NSMutableDictionary *dict = NSMutableDictionary.dictionary;
        [dict setObject:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
        if (font) {
            [dict setObject:font forKey:NSFontAttributeName];
        }
        if (color) {
            [dict setObject:color forKey:NSUnderlineColorAttributeName];
        }
        if (dict.count > 0) {
            [self.mutableAttributedString attributedWithRange:itemRange attributed:dict];
            self.attributedText = self.mutableAttributedString;
        }
    }
}

//插入图片
- (void)setImageUrl:(NSString *)url index:(NSInteger)idx size:(CGSize)size leftSpace:(NSInteger)left rightSpace:(NSInteger)right wordAlign:(NSWordAlign)align {
    
    if (url.length > 0 && !CGSizeEqualToSize(size, CGSizeZero)) {
        NSTextAttachment   *attch  = [[NSTextAttachment alloc] init];
        NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:attch];
        NSMutableAttributedString *leftSpaceString = [[NSMutableAttributedString alloc] init];
        NSMutableAttributedString *rightSpaceString = [[NSMutableAttributedString alloc] init];
        for (int i=0; i<left; i++) {
            [leftSpaceString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        }
        for (int i=0; i<right; i++) {
            [rightSpaceString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        }
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
        [string appendAttributedString:leftSpaceString];
        [string appendAttributedString:imageString];
        [string appendAttributedString:rightSpaceString];
        
        if ([url hasPrefix:@"http"]) {
//            [self loadImageForUrl:url toAttach:attch syncLoadCache:NO range:range text:temp];
        }else {//加载本地图片
            if (CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
                CGSize imageSize = size;
                CGSize frameSize = size;
                CGSize  wordSize = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
                
                frameSize.width = imageSize.width + wordSize.width;
                if (wordSize.width > 0 && wordSize.height > imageSize.height) {
                    frameSize.height = wordSize.height;
                }
                
                attch.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
                attch.image = [UIImage imageNamed:url];
                
                CGRect frame = CGRectZero;
                frame.origin = self.frame.origin;
                frame.size = frameSize;
                self.frame = frame;
            }else {
                //调整图片大小
                CGSize imageSize = size;
                attch.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
                attch.image = [UIImage imageNamed:url];
            }
        }
        
        //调整图片位置使文字居上居中居下显示
        switch (align) {
            case NSWordAlignBottom:
            {
                CGSize  imageSize = attch.bounds.size;
                attch.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
            }
                break;
            case NSWordAlignCenter:
            {
                CGSize  imageSize = attch.bounds.size;
                CGSize  wordSize = [self.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
                CGFloat height = imageSize.height-wordSize.height;
                if (height > 0) height = -height/2.0;
                else height = height/2.0;
                if (wordSize.width <= 0) height = 0;
                attch.bounds = CGRectMake(0, height, imageSize.width, imageSize.height);
            }
                break;
            case NSWordAlignTop:
            {
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
        if (idx < 0) {
            [self.mutableAttributedString insertAttributedString:string atIndex:0];
        }else if (idx >= self.text.length) {
            [self.mutableAttributedString appendAttributedString:string];
        }else {
            [self.mutableAttributedString insertAttributedString:string atIndex:idx];
        }
        
    }else if (CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
        CGSize  wordSize = [self.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
        CGRect frame = CGRectZero;
        frame.origin = self.frame.origin;
        frame.size = wordSize;
        self.frame = frame;
    }
    self.attributedText = self.mutableAttributedString;
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
