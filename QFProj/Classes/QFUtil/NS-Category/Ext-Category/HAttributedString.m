//
//  HAttributedString.m
//  QFProj
//
//  Created by dqf on 2019/6/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HAttributedString.h"

@implementation HMutableAttributedString

//字间距
- (void)setCharSpace:(CGFloat)space {
    [self h_setKern:@(space) range:NSMakeRange(0, self.length)];
}

//行间距
- (void)setLineSpace:(CGFloat)space {
    [self h_setLineSpacing:space range:NSMakeRange(0, self.length)];
}

- (void)setFont:(UIFont *)font {
    [self h_setFont:font range:NSMakeRange(0, self.length)];
}

- (void)setColor:(UIColor *)color {
    [self h_setColor:color range:NSMakeRange(0, self.length)];
}

//中线
- (void)setTextStrikethrough {
    HTextDecoration *textDecoration = [HTextDecoration decorationWithStyle:HTextLineStyleSingle];
    [self h_setTextStrikethrough:textDecoration range:NSMakeRange(0, self.length)];
}

//下划线
- (void)setTextUnderline {
    HTextDecoration *textDecoration = [HTextDecoration decorationWithStyle:HTextLineStyleSingle];
    [self h_setTextUnderline:textDecoration range:NSMakeRange(0, self.length)];
}

- (NSMutableAttributedString *)h_attachmentStringWithContent:(id)content
                                              attachmentSize:(CGSize)attachmentSize
                                                   leftSpace:(NSUInteger)left
                                                  rightSpace:(NSUInteger)right {
    
    return [self h_attachmentStringWithContent:content attachmentSize:attachmentSize alignment:HTextVerticalAlignmentCenter leftSpace:left rightSpace:right];
}

- (NSMutableAttributedString *)h_attachmentStringWithContent:(id)content
                                              attachmentSize:(CGSize)attachmentSize
                                                   alignment:(HTextVerticalAlignment)alignment
                                                   leftSpace:(NSUInteger)left
                                                   rightSpace:(NSUInteger)right {
    
    NSMutableAttributedString *mutableAttributedString = NSMutableAttributedString.new;
    
    //左间距
    for (int i=0; i<left; i++) {
        [mutableAttributedString h_appendString:@" "];
    }
    
    
    //content
    NSMutableAttributedString *attachment = [NSMutableAttributedString h_attachmentStringWithContent:content contentMode:UIViewContentModeScaleAspectFill attachmentSize:attachmentSize alignToFont:self.h_font alignment:alignment];
    [mutableAttributedString appendAttributedString:attachment];
    
    
    //右间距
    for (int i=0; i<right; i++) {
        [mutableAttributedString h_appendString:@" "];
    }
    
    return mutableAttributedString;
}

@end
