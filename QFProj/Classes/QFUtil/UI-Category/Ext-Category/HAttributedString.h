//
//  HAttributedString.h
//  QFProj
//
//  Created by wind on 2019/6/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "NSAttributedString+HText.h"

@interface HMutableAttributedString : NSMutableAttributedString

//字间距
- (void)setCharSpace:(CGFloat)space;

//行间距
- (void)setLineSpace:(CGFloat)space;

- (void)setFont:(UIFont *)font;

- (void)setColor:(UIColor *)color;

//中线
- (void)setTextStrikethrough;

//下划线
- (void)setTextUnderline;

- (NSMutableAttributedString *)h_attachmentStringWithContent:(id)content
                                              attachmentSize:(CGSize)attachmentSize
                                                   leftSpace:(NSUInteger)left
                                                  rightSpace:(NSUInteger)right;

- (NSMutableAttributedString *)h_attachmentStringWithContent:(id)content
                                              attachmentSize:(CGSize)attachmentSize
                                                   alignment:(HTextVerticalAlignment)alignment
                                                   leftSpace:(NSUInteger)left
                                                  rightSpace:(NSUInteger)right;
@end
