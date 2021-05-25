//
//  HStringFormatter.m
//  QFProj
//
//  Created by Wind on 2021/5/24.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HStringFormatter.h"

@implementation HKeywords
@end

@implementation HTapKeywords
@end

@implementation HStringFormatter

- (NSMutableAttributedString *)attributedStringForFormatter:(HStringFormatter *)formatter {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:formatter.string];
    //字间距
    if (formatter.charSpace) {
        NSMutableDictionary *dict = NSMutableDictionary.dictionary;
        long number = formatter.charSpace;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [dict setObject:(__bridge id)num forKey:(id)kCTKernAttributeName];
        [attributedString attributedWith:dict];
        CFRelease(num);
    }
    //关键字
    if (formatter.keywords.words.length) {
        if ([formatter.string containsString:formatter.keywords.words]) {
            NSRange itemRange = [formatter.string rangeOfString:formatter.keywords.words];
            NSMutableDictionary *dict = NSMutableDictionary.dictionary;
            if (formatter.keywords.font) {
                [dict setObject:formatter.keywords.font forKey:NSFontAttributeName];
            }
            if (formatter.keywords.color) {
                [dict setObject:formatter.keywords.color forKey:NSForegroundColorAttributeName];
            }
            if (dict.count > 0) {
                [attributedString attributedWithRange:itemRange attributed:dict];
            }
        }
    }
    //中线
    if (formatter.middleline.words.length) {
        if ([formatter.string containsString:formatter.middleline.words]) {
            NSRange itemRange = [formatter.string rangeOfString:formatter.middleline.words];
            NSMutableDictionary *dict = NSMutableDictionary.dictionary;
            [dict setObject:@(NSUnderlineStyleSingle) forKey:NSBaselineOffsetAttributeName];
            [dict setObject:@(NSUnderlineStyleSingle) forKey:NSStrikethroughStyleAttributeName];
            if (formatter.middleline.font) {
                [dict setObject:formatter.middleline.font forKey:NSFontAttributeName];
            }
            if (formatter.middleline.color) {
                [dict setObject:formatter.middleline.color forKey:NSForegroundColorAttributeName];
            }
            if (dict.count > 0) {
                [attributedString attributedWithRange:itemRange attributed:dict];
            }
        }
    }
    //下划线
    if (formatter.underline.words.length) {
        if ([formatter.string containsString:formatter.underline.words]) {
            NSRange itemRange = [formatter.string rangeOfString:formatter.underline.words];
            NSMutableDictionary *dict = NSMutableDictionary.dictionary;
            [dict setObject:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
            if (formatter.underline.font) {
                [dict setObject:formatter.underline.font forKey:NSFontAttributeName];
            }
            if (formatter.underline.color) {
                [dict setObject:formatter.underline.color forKey:NSUnderlineColorAttributeName];
            }
            if (dict.count > 0) {
                [attributedString attributedWithRange:itemRange attributed:dict];
            }
        }
    }
    return attributedString;
}

@end

@implementation HStringFormatter2
@end


@implementation NSString (HStringFormatter)
//字符串添加熟悉
- (NSMutableAttributedString *)makeAttributes:(void(^)(HStringFormatter *make))block {
    HStringFormatter *make = HStringFormatter.new;
    make.string = self;
    make.keywords = HKeywords.new;
    make.middleline = HKeywords.new;
    make.underline = HKeywords.new;
    if (block) block(make);
    return [make attributedStringForFormatter:make];
}
//添加属性字符串
- (NSMutableAttributedString *)addAttributes:(void(^)(HStringFormatter *make))block {
    HStringFormatter *make = HStringFormatter.new;
    make.keywords = HKeywords.new;
    make.middleline = HKeywords.new;
    make.underline = HKeywords.new;
    if (block) block(make);
    return [make attributedStringForFormatter:make];
}
@end
