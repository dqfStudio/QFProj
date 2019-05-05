//
//  HRichLabel+HUtill.m
//  TestProject
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HRichLabel+HUtil.h"
#import <CoreText/CoreText.h>

@implementation HRichLabel (HUtil)

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

//追加字符串
- (void)appendString:(NSString *)text {
    if (text.length > 0) {
        [self.mutableAttributedString appendString:text];
        self.attributedText = self.mutableAttributedString;
    }
}
- (void)insertString:(NSString *)text atIndex:(NSInteger)loc {
    if (text.length > 0) {
        [self.mutableAttributedString insertString:text atIndex:loc];
        self.attributedText = self.mutableAttributedString;
    }
}

//点击事件
- (void)appendTapKeywords:(NSString *)keywords block:(HTapKeywordsBlock)tapBlock {
    if (keywords.length > 0) {
        [self.mutableAttributedString appendString:keywords singleTap:^(UIView * _Nonnull targetView, NSAttributedString * _Nonnull attributeString, HTextAttachment * _Nullable attachment) {
            if (tapBlock) {
                tapBlock();
            }
        }];
        self.attributedText = self.mutableAttributedString;
    }
}
- (void)insertTapKeywords:(NSString *)keywords atIndex:(NSInteger)loc block:(HTapKeywordsBlock)tapBlock {
    if (keywords.length > 0) {
        [self.mutableAttributedString insertString:keywords atIndex:loc singleTap:^(UIView * _Nonnull targetView, NSAttributedString * _Nonnull attributeString, HTextAttachment * _Nullable attachment) {
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

//插入图片
- (void)appendAttachment:(HAttachmentBlock)block font:(UIFont *)font {
    if (block) {
        id content = block();
        CGSize size = CGSizeZero;
        if ([content isKindOfClass:UIImage.class]) {
            UIImage *image = content;
            size = image.size;
        }else if ([content isKindOfClass:UIView.class]) {
            UIView *view = content;
            size = view.frame.size;
        }else if ([content isKindOfClass:CALayer.class]) {
            CALayer *layer = content;
            size = layer.frame.size;
        }
        HTextAttachment *attachment = [HTextAttachment attachmentWithContent:content contentSize:size alignToFont:font];
        [self.mutableAttributedString appendAttachment:attachment];
        self.attributedText = self.mutableAttributedString;
    }
}
- (void)insertAttachment:(HAttachmentBlock)block atIndex:(NSInteger)loc font:(UIFont *)font {
    if (block) {
        id content = block();
        CGSize size = CGSizeZero;
        if ([content isKindOfClass:UIImage.class]) {
            UIImage *image = content;
            size = image.size;
        }else if ([content isKindOfClass:UIView.class]) {
            UIView *view = content;
            size = view.frame.size;
        }else if ([content isKindOfClass:CALayer.class]) {
            CALayer *layer = content;
            size = layer.frame.size;
        }
        HTextAttachment *attachment = [HTextAttachment attachmentWithContent:content contentSize:size alignToFont:font];
        [self.mutableAttributedString insertAttachment:attachment atIndex:loc];
        self.attributedText = self.mutableAttributedString;
    }
}

- (void)parse:(NSString *)aString {
    
    //解析如下字符串
    //NSString *string = @"</flag=global,linespace=5,lines=0,font=12,color=123456/>张三李四</font=12,color=123456,headerspace=5,footerspace=10/>张三</font=12,color=123456,click=true,underliane=true,middleline=true,headerspace=auto/>李四";
    
//    NSString *string = @"</flag=global,linespace=5,lines=0,font=12,color=123456/>张三李四</flag=text,font=12,color=123456,headerspace=5,footerspace=10/>张三</flag=text,font=12,color=123456,click=true,underliane=true,middleline=true,headerspace=auto/>李四</flag=image,index=0,size={20,20},click=true/>test.png</flag=image,index=0,click=true/>http://test.png";
    
//    NSString *string = @"</flag=global,linespace=5,lines=0,backgroundcolor=123456/></flag=text,font=12,color=123456,headerspace=5,footerspace=10/>张三</flag=text,font=12,color=123456,click=true,underliane=true,middleline=true,headerspace=auto/>李四</flag=image,index=0,size={20,20},click=true/>test.png</flag=image,index=0,click=true/>http://test.png";

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
                    //[self setLineSpace:value.integerValue];
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
//                    if ([value isEqualToString:@"true"]) {
//                        [self setTapKeywords:@[text] block:^(NSInteger index) {
//                            if (textBlock) {
//                                textBlock(index);
//                            }
//                        }];
//                    }
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
            UIFont *font = nil;
            UIColor *color = nil;
            for (int j=0; j<idArr.count; j++) {
                NSString *idString = idArr[j];
                NSArray *arr = [idString componentsByString:@"="];
                NSString *key = arr.firstObject;
                NSString *value = arr.lastObject;
                if ([key isEqualToString:@"font"]) {
                    if ([value containsString:@"+"]) {
                        value = [value stringByReplacingOccurrencesOfString:@"+" withString:@""];
                        font = [UIFont boldSystemFontOfSize:value.integerValue];
                    }else {
                        font = [UIFont systemFontOfSize:value.integerValue];
                    }
                }else if ([key isEqualToString:@"color"]) {
                    color = [UIColor colorWithString:value];
                }else if ([key isEqualToString:@"click"]) {
                    if ([value isEqualToString:@"true"]) {
//                        [self setTapKeywords:@[text] block:^(NSInteger index) {
//                            if (textBlock) {
//                                textBlock(index);
//                            }
//                        }];
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
            //设置关键字属性
            [self setKeywords:text font:font color:color];
//            [self setTapKeywords:text block:^{
//
//            }];
            
        }else if ([idArr containsObject:@"flag=image"]) {
            //遍历其他属性
            NSString *index = nil;
            NSString *click = nil;
            NSString *image = text;
            CGSize size = CGSizeZero;
            for (int j=0; j<idArr.count; j++) {
                NSString *idString = idArr[j];
                NSArray *arr = [idString componentsByString:@"="];
                NSString *key = arr.firstObject;
                NSString *value = arr.lastObject;
                if ([key isEqualToString:@"index"]) {
                    index = value;
                }else if ([key isEqualToString:@"click"]) {
                    if ([value isEqualToString:@"true"]) {
                        click = value;
                    }
                }else if ([key isEqualToString:@"size"]) {
                    if ([value isEqualToString:@"true"]) {
                        size = CGSizeFromString(value);
                    }
                }
                HWebImageView *imageView = [[HWebImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];;
                imageView.backgroundColor = [UIColor clearColor];
                [imageView setImageUrlString:image];
                if ([click isEqualToString:@"true"]) {
                    [imageView addSingleTapGestureWithBlock:^(UITapGestureRecognizer *recognizer) {
//                        tapBlock();
                    }];
                }
                HTextAttachment *attachment = [HTextAttachment attachmentWithContent:imageView contentSize:size alignToFont:[UIFont systemFontOfSize:14.f]];
                [self.mutableAttributedString appendAttachment:attachment];
                self.attributedText = self.mutableAttributedString;
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
