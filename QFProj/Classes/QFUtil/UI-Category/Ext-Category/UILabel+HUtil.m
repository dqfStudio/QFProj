//
//  UILabel+HUtill.m
//  HProj
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
- (void)setKeywords:(NSString *)keywords font:(UIFont *)font color:(UIColor *)color {
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
- (void)setMiddleline:(NSString *)keywords font:(UIFont *)font color:(UIColor *)color {
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
- (void)setUnderline:(NSString *)keywords font:(UIFont *)font color:(UIColor *)color {
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

- (void)parse:(NSString *)aString block:(HTapKeywordsBlock)tapBlock {
    
    //解析如下字符串
    //NSString *string = @"</flag=global,linespace=5,lines=0,font=12,color=123456/>张三李四</font=12,color=123456,headerspace=5,footerspace=10/>张三</font=12,color=123456,click=true,underliane=true,middleline=true,headerspace=auto/>李四";
    
//    NSString *string = @"</flag=global,linespace=5,lines=0,font=12,color=123456/>张三李四</flag=text,font=12,color=123456,headerspace=5,footerspace=10/>张三</flag=text,font=12,color=123456,click=true,underliane=true,middleline=true,headerspace=auto/>李四</flag=image,index=0,click=true/>test.png</flag=image,index=0,click=true/>http://test.png";

    NSArray *tagArr = [aString componentsByString:@"</"];
    for (int i=0; i<tagArr.count; i++) {
        NSString *tagString = tagArr[i];
        if (tagString.length == 0) continue;
        NSArray *flagArr = [tagString componentsByString:@"/>"];
        NSString *text = flagArr.lastObject;
        NSString *flagString = flagArr.firstObject;
        flagString = [flagString stringByReplacingOccurrencesOfString:@"，" withString:@","];
        flagString = [flagString stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *idArr = [flagString componentsByString:@","];
        if ([idArr containsObject:@"flag=global"]) {
            //set text
            [self setText:text];
            //遍历其他属性
            for (int j=0; j<idArr.count; j++) {
                NSString *idString = idArr[j];
                NSArray *arr = [idString componentsByString:@"="];
                NSString *key = arr.firstObject;
                NSString *value = arr.lastObject;
                if ([key isEqualToString:@"lines"]) {
                    [self setNumberOfLines:value.integerValue];
                }else if ([key isEqualToString:@"linespace"]) {
                    [self setLineSpace:value.integerValue];
                }else if ([key isEqualToString:@"font"]) {
                    if ([value containsString:@"+"]) {
                        value = [value stringByReplacingOccurrencesOfString:@"+" withString:@""];
                        [self setFont:[UIFont boldSystemFontOfSize:value.integerValue]];
                    }else {
                        [self setFont:[UIFont systemFontOfSize:value.integerValue]];
                    }
                }else if ([key isEqualToString:@"color"]) {
                    [self setTextColor:[UIColor colorWithString:value]];
                }else if ([key isEqualToString:@"align"]) {
                    if ([value isEqualToString:@"left"]) {
                        [self setTextAlignment:NSTextAlignmentLeft];
                    }else if ([value isEqualToString:@"center"]) {
                        [self setTextAlignment:NSTextAlignmentCenter];
                    }else if ([value isEqualToString:@"right"]) {
                        [self setTextAlignment:NSTextAlignmentRight];
                    }
                }else if ([key isEqualToString:@"click"]) {
                    if ([value isEqualToString:@"true"]) {
                        [self setTapKeywords:@[text] block:^(NSInteger index) {
                            if (tapBlock) {
                                tapBlock(index);
                            }
                        }];
                    }
                }else if ([key isEqualToString:@"underliane"]) {
                    if ([value isEqualToString:@"true"]) {
                        [self setUnderline:text font:nil color:nil];
                    }
                }else if ([key isEqualToString:@"middleline"]) {
                    if ([value isEqualToString:@"true"]) {
                        [self setMiddleline:text font:nil color:nil];
                    }
                }else if ([key isEqualToString:@"backgroundcolor"]) {
                    [self setBackgroundColor:[UIColor colorWithString:value]];
                }
            }
        }else if ([idArr containsObject:@"flag=text"]) {
            //遍历其他属性
            for (int j=0; j<idArr.count; j++) {
                NSString *idString = idArr[j];
                NSArray *arr = [idString componentsByString:@"="];
                NSString *key = arr.firstObject;
                NSString *value = arr.lastObject;
                if ([key isEqualToString:@"font"]) {
                    if ([value containsString:@"+"]) {
                        value = [value stringByReplacingOccurrencesOfString:@"+" withString:@""];
                        [self setFont:[UIFont boldSystemFontOfSize:value.integerValue]];
                        [self setKeywords:text font:[UIFont boldSystemFontOfSize:value.integerValue] color:nil];
                    }else {
                        [self setKeywords:text font:[UIFont systemFontOfSize:value.integerValue] color:nil];
                    }
                }else if ([key isEqualToString:@"color"]) {
                    [self setKeywords:text font:nil color:[UIColor colorWithString:value]];
                }else if ([key isEqualToString:@"click"]) {
                    if ([value isEqualToString:@"true"]) {
                        [self setTapKeywords:@[text] block:^(NSInteger index) {
                            if (tapBlock) {
                                tapBlock(index);
                            }
                        }];
                    }
                }else if ([key isEqualToString:@"underliane"]) {
                    if ([value isEqualToString:@"true"]) {
                        [self setUnderline:text font:nil color:nil];
                    }
                }else if ([key isEqualToString:@"middleline"]) {
                    if ([value isEqualToString:@"true"]) {
                        [self setMiddleline:text font:nil color:nil];
                    }
                }else if ([key isEqualToString:@"headerspace"]) {
                    
                }else if ([key isEqualToString:@"footerspace"]) {
                    
                }
            }
        }else if ([idArr containsObject:@"flag=image"]) {
            //遍历其他属性
            for (int j=0; j<idArr.count; j++) {
                NSString *idString = idArr[j];
                NSArray *arr = [idString componentsByString:@"="];
                NSString *key = arr.firstObject;
                NSString *value = arr.lastObject;
                if ([key isEqualToString:@"index"]) {
//                    if ([value containsString:@"+"]) {
//                        value = [value stringByReplacingOccurrencesOfString:@"+" withString:@""];
//                        [self setFont:[UIFont boldSystemFontOfSize:value.integerValue]];
//                        [self setKeywords:text font:[UIFont boldSystemFontOfSize:value.integerValue] color:nil];
//                    }else {
//                        [self setKeywords:text font:[UIFont systemFontOfSize:value.integerValue] color:nil];
//                    }
                    
                }else if ([key isEqualToString:@"color"]) {
                    [self setKeywords:text font:nil color:[UIColor colorWithString:value]];
                }else if ([key isEqualToString:@"click"]) {
                    if ([value isEqualToString:@"true"]) {
                        [self setTapKeywords:@[text] block:^(NSInteger index) {
                            if (tapBlock) {
                                tapBlock(index);
                            }
                        }];
                    }
                }else if ([key isEqualToString:@"underliane"]) {
                    if ([value isEqualToString:@"true"]) {
                        [self setUnderline:text font:nil color:nil];
                    }
                }else if ([key isEqualToString:@"middleline"]) {
                    if ([value isEqualToString:@"true"]) {
                        [self setMiddleline:text font:nil color:nil];
                    }
                }else if ([key isEqualToString:@"headerspace"]) {
                    
                }else if ([key isEqualToString:@"headerspace"]) {
                    
                }else if ([key isEqualToString:@"footerspace"]) {
                    
                }
            }
        }
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
