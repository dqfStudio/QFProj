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

- (void)makeAttributes:(void(^)(HStringFormatter2 *make))block {
    HStringFormatter2 *make = HStringFormatter2.new;
    make.string = self.text;
    make.keywords = HKeywords.new;
    make.tapKeywords = HTapKeywords.new;
    make.middleline = HKeywords.new;
    make.underline = HKeywords.new;
    if (block) block(make);

    NSMutableAttributedString *attributedString = [make attributedStringFor:make];
    
    if (make.lineSpace) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = self.textAlignment;
        paragraphStyle.lineBreakMode = self.lineBreakMode;
        [paragraphStyle setLineSpacing:make.lineSpace];
        NSMutableDictionary *dict = NSMutableDictionary.dictionary;
        [dict setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        [attributedString attributedWith:dict];
    }
    
    self.attributedText = attributedString;
    
    if (make.tapKeywords.words.length) {
        HTapKeywordsBlock tapBlock = make.tapKeywords.tapBlock;
        [self addAttributeTapActionWithStrings:make.tapKeywords.words tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
            if (tapBlock) {
                tapBlock(index);
            }
        }];
    }
}

//- (void)parse:(NSString *)aString block:(HTapKeywordsBlock)tapBlock {
//
//    //解析如下字符串
//    //NSString *string = @"</flag=global,linespace=5,lines=0,font=12,color=123456/>张三李四</font=12,color=123456,headerspace=5,footerspace=10/>张三</font=12,color=123456,click=true,underliane=true,middleline=true,headerspace=auto/>李四";
//
////    NSString *string = @"</flag=global,linespace=5,lines=0,font=12,color=123456/>张三李四</flag=text,font=12,color=123456,headerspace=5,footerspace=10/>张三</flag=text,font=12,color=123456,click=true,underliane=true,middleline=true,headerspace=auto/>李四</flag=image,index=0,click=true/>test.png</flag=image,index=0,click=true/>http://test.png";
//
//    NSArray *tagArr = [aString componentsByString:@"</"];
//    for (int i=0; i<tagArr.count; i++) {
//        NSString *tagString = tagArr[i];
//        if (tagString.length == 0) continue;
//        NSArray *flagArr = [tagString componentsByString:@"/>"];
//        NSString *text = flagArr.lastObject;
//        NSString *flagString = flagArr.firstObject;
//        flagString = [flagString stringByReplacingOccurrencesOfString:@"，" withString:@","];
//        flagString = [flagString stringByReplacingOccurrencesOfString:@" " withString:@""];
//        NSArray *idArr = [flagString componentsByString:@","];
//        if ([idArr containsObject:@"flag=global"]) {
//            //set text
//            [self setText:text];
//            //遍历其他属性
//            for (int j=0; j<idArr.count; j++) {
//                NSString *idString = idArr[j];
//                NSArray *arr = [idString componentsByString:@"="];
//                NSString *key = arr.firstObject;
//                NSString *value = arr.lastObject;
//                if ([key isEqualToString:@"lines"]) {
//                    [self setNumberOfLines:value.integerValue];
//                }else if ([key isEqualToString:@"linespace"]) {
//                    [self setLineSpace:value.integerValue];
//                }else if ([key isEqualToString:@"font"]) {
//                    if ([value containsString:@"+"]) {
//                        value = [value stringByReplacingOccurrencesOfString:@"+" withString:@""];
//                        [self setFont:[UIFont boldSystemFontOfSize:value.integerValue]];
//                    }else {
//                        [self setFont:[UIFont systemFontOfSize:value.integerValue]];
//                    }
//                }else if ([key isEqualToString:@"color"]) {
//                    [self setTextColor:[UIColor colorWithString:value]];
//                }else if ([key isEqualToString:@"align"]) {
//                    if ([value isEqualToString:@"left"]) {
//                        [self setTextAlignment:NSTextAlignmentLeft];
//                    }else if ([value isEqualToString:@"center"]) {
//                        [self setTextAlignment:NSTextAlignmentCenter];
//                    }else if ([value isEqualToString:@"right"]) {
//                        [self setTextAlignment:NSTextAlignmentRight];
//                    }
//                }else if ([key isEqualToString:@"click"]) {
//                    if ([value isEqualToString:@"true"]) {
//                        [self setTapKeywords:@[text] block:^(NSInteger index) {
//                            if (tapBlock) {
//                                tapBlock(index);
//                            }
//                        }];
//                    }
//                }else if ([key isEqualToString:@"underliane"]) {
//                    if ([value isEqualToString:@"true"]) {
//                        [self setUnderline:text font:nil color:nil];
//                    }
//                }else if ([key isEqualToString:@"middleline"]) {
//                    if ([value isEqualToString:@"true"]) {
//                        [self setMiddleline:text font:nil color:nil];
//                    }
//                }else if ([key isEqualToString:@"backgroundcolor"]) {
//                    [self setBackgroundColor:[UIColor colorWithString:value]];
//                }
//            }
//        }else if ([idArr containsObject:@"flag=text"]) {
//            //遍历其他属性
//            for (int j=0; j<idArr.count; j++) {
//                NSString *idString = idArr[j];
//                NSArray *arr = [idString componentsByString:@"="];
//                NSString *key = arr.firstObject;
//                NSString *value = arr.lastObject;
//                if ([key isEqualToString:@"font"]) {
//                    if ([value containsString:@"+"]) {
//                        value = [value stringByReplacingOccurrencesOfString:@"+" withString:@""];
//                        [self setFont:[UIFont boldSystemFontOfSize:value.integerValue]];
//                        [self setKeywords:text font:[UIFont boldSystemFontOfSize:value.integerValue] color:nil];
//                    }else {
//                        [self setKeywords:text font:[UIFont systemFontOfSize:value.integerValue] color:nil];
//                    }
//                }else if ([key isEqualToString:@"color"]) {
//                    [self setKeywords:text font:nil color:[UIColor colorWithString:value]];
//                }else if ([key isEqualToString:@"click"]) {
//                    if ([value isEqualToString:@"true"]) {
//                        [self setTapKeywords:@[text] block:^(NSInteger index) {
//                            if (tapBlock) {
//                                tapBlock(index);
//                            }
//                        }];
//                    }
//                }else if ([key isEqualToString:@"underliane"]) {
//                    if ([value isEqualToString:@"true"]) {
//                        [self setUnderline:text font:nil color:nil];
//                    }
//                }else if ([key isEqualToString:@"middleline"]) {
//                    if ([value isEqualToString:@"true"]) {
//                        [self setMiddleline:text font:nil color:nil];
//                    }
//                }else if ([key isEqualToString:@"headerspace"]) {
//
//                }else if ([key isEqualToString:@"footerspace"]) {
//
//                }
//            }
//        }else if ([idArr containsObject:@"flag=image"]) {
//            //遍历其他属性
//            for (int j=0; j<idArr.count; j++) {
//                NSString *idString = idArr[j];
//                NSArray *arr = [idString componentsByString:@"="];
//                NSString *key = arr.firstObject;
//                NSString *value = arr.lastObject;
//                if ([key isEqualToString:@"index"]) {
////                    if ([value containsString:@"+"]) {
////                        value = [value stringByReplacingOccurrencesOfString:@"+" withString:@""];
////                        [self setFont:[UIFont boldSystemFontOfSize:value.integerValue]];
////                        [self setKeywords:text font:[UIFont boldSystemFontOfSize:value.integerValue] color:nil];
////                    }else {
////                        [self setKeywords:text font:[UIFont systemFontOfSize:value.integerValue] color:nil];
////                    }
//
//                }else if ([key isEqualToString:@"color"]) {
//                    [self setKeywords:text font:nil color:[UIColor colorWithString:value]];
//                }else if ([key isEqualToString:@"click"]) {
//                    if ([value isEqualToString:@"true"]) {
//                        [self setTapKeywords:@[text] block:^(NSInteger index) {
//                            if (tapBlock) {
//                                tapBlock(index);
//                            }
//                        }];
//                    }
//                }else if ([key isEqualToString:@"underliane"]) {
//                    if ([value isEqualToString:@"true"]) {
//                        [self setUnderline:text font:nil color:nil];
//                    }
//                }else if ([key isEqualToString:@"middleline"]) {
//                    if ([value isEqualToString:@"true"]) {
//                        [self setMiddleline:text font:nil color:nil];
//                    }
//                }else if ([key isEqualToString:@"headerspace"]) {
//
//                }else if ([key isEqualToString:@"headerspace"]) {
//
//                }else if ([key isEqualToString:@"footerspace"]) {
//
//                }
//            }
//        }
//    }
//}

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
