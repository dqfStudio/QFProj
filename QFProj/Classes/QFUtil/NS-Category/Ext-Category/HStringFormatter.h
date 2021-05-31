//
//  HStringFormatter.h
//  QFProj
//
//  Created by Wind on 2021/5/24.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "NSAttributedString+HText.h"

typedef void(^HTextActionBlock)(NSAttributedString *text, NSRange range);

@interface HStringFormatter : NSMutableAttributedString

- (void)makeFont:(UIFont *)font range:(NSRange)range;
- (void)makeColor:(UIColor *)color range:(NSRange)range;
- (void)makeCharspace:(CGFloat)charspace range:(NSRange)range;
- (void)makeLinespace:(CGFloat)linespace range:(NSRange)range;
- (void)makeMiddleline:(NSRange)range;
- (void)makeUnderline:(NSRange)range;
- (void)makeTapAction:(NSRange)range tapAction:(HTextActionBlock)block;

- (void)appendImageName:(NSString *)imageName size:(CGSize)size;

@end
