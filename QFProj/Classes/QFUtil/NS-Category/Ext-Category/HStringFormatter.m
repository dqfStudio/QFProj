//
//  HStringFormatter.m
//  QFProj
//
//  Created by Wind on 2021/5/24.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HStringFormatter.h"

@implementation HStringFormatter

- (void)makeFont:(UIFont *)font range:(NSRange)range {
    [self h_setFont:font range:range];
}
- (void)makeColor:(UIColor *)color range:(NSRange)range {
    [self h_setColor:color range:range];
}
- (void)makeCharspace:(CGFloat)charspace range:(NSRange)range {
    [self h_setKern:@(charspace) range:range];
}
- (void)makeLinespace:(CGFloat)linespace range:(NSRange)range {
    [self h_setLineSpacing:linespace range:range];
}
- (void)makeMiddleline:(NSRange)range {
    HTextDecoration *textDecoration = [HTextDecoration decorationWithStyle:HTextLineStyleSingle];
    [self h_setTextStrikethrough:textDecoration range:range];
}
- (void)makeUnderline:(NSRange)range {
    HTextDecoration *textDecoration = [HTextDecoration decorationWithStyle:HTextLineStyleSingle];
    [self h_setTextUnderline:textDecoration range:range];
}
- (void)makeTapAction:(NSRange)range tapAction:(HTextActionBlock)block {
    HTextHighlight *highlight = HTextHighlight.new;
    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) block(text, range);
        });
    };
    [self h_setTextHighlight:highlight range:range];
}

- (void)appendImageName:(NSString *)imageName size:(CGSize)size {
    HWebImageView *imageView = [[HWebImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [imageView setImageWithName:imageName];
    NSMutableAttributedString *attributedString = [NSMutableAttributedString h_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:self.h_font alignment:HTextVerticalAlignmentCenter];
    [self appendAttributedString:attributedString];
}

@end
