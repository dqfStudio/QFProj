//
//  HStringFormatter.m
//  QFProj
//
//  Created by Wind on 2021/5/24.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HStringFormatter.h"

@implementation NSMutableAttributedString (HStringFormatter)

//设置字体大小
- (void)makeFont:(UIFont *)font range:(NSRange)range {
    [self h_setFont:font range:range];
}
//设置字体颜色
- (void)makeColor:(UIColor *)color range:(NSRange)range {
    [self h_setColor:color range:range];
}
//设置字间距
- (void)makeCharspace:(CGFloat)charspace range:(NSRange)range {
    [self h_setKern:@(charspace) range:range];
}
//设置行间距
- (void)makeLinespace:(CGFloat)linespace range:(NSRange)range {
    [self h_setLineSpacing:linespace range:range];
}
//设置中线
- (void)makeMiddleline:(NSRange)range {
    HTextDecoration *textDecoration = [HTextDecoration decorationWithStyle:HTextLineStyleSingle];
    [self h_setTextStrikethrough:textDecoration range:range];
}
//设置下划线
- (void)makeUnderline:(NSRange)range {
    HTextDecoration *textDecoration = [HTextDecoration decorationWithStyle:HTextLineStyleSingle];
    [self h_setTextUnderline:textDecoration range:range];
}
//设置点击事件
- (void)makeTapAction:(NSRange)range tapAction:(HTextActionBlock)block {
    HTextHighlight *highlight = HTextHighlight.new;
    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) block(text, range);
        });
    };
    [self h_setTextHighlight:highlight range:range];
}


//追加图片，alignment默认为HTextVerticalAlignmentCenter
- (void)appendImageName:(NSString *)imageName size:(CGSize)size {
    [self appendImageName:imageName size:size alignment:HTextVerticalAlignmentCenter];
}
- (void)appendImageName:(NSString *)imageName size:(CGSize)size alignment:(HTextVerticalAlignment)alignment {
    [self appendImageName:imageName size:size alignment:HTextVerticalAlignmentCenter pressed:nil];
}
- (void)appendImageName:(NSString *)imageName size:(CGSize)size alignment:(HTextVerticalAlignment)alignment pressed:(callback)block {
    HWebImageView *imageView = [[HWebImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [imageView setImageWithName:imageName];
    if (block) [imageView setPressed:block];
    NSMutableAttributedString *attributedString = [NSMutableAttributedString h_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:self.h_font alignment:alignment];
    [self appendAttributedString:attributedString];
}


//插入图片，alignment默认为HTextVerticalAlignmentCenter
- (void)insertImageName:(NSString *)imageName size:(CGSize)size atIndex:(NSUInteger)loc {
    [self insertImageName:imageName size:size atIndex:loc alignment:HTextVerticalAlignmentCenter];
}
- (void)insertImageName:(NSString *)imageName size:(CGSize)size atIndex:(NSUInteger)loc alignment:(HTextVerticalAlignment)alignment {
    [self insertImageName:imageName size:size atIndex:loc alignment:HTextVerticalAlignmentCenter pressed:nil];
}
- (void)insertImageName:(NSString *)imageName size:(CGSize)size atIndex:(NSUInteger)loc alignment:(HTextVerticalAlignment)alignment pressed:(callback)block {
    HWebImageView *imageView = [[HWebImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [imageView setImageWithName:imageName];
    if (block) [imageView setPressed:block];
    NSMutableAttributedString *attributedString = [NSMutableAttributedString h_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:self.h_font alignment:alignment];
    [self insertAttributedString:attributedString atIndex:loc];
}

@end
