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
- (HWebImageView *)appendImageWithSize:(CGSize)size {
    return [self appendImageWithSize:size alignment:HTextVerticalAlignmentCenter];
}
- (HWebImageView *)appendImageWithSize:(CGSize)size alignment:(HTextVerticalAlignment)alignment {
    HWebImageView *imageView = [[HWebImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    NSMutableAttributedString *attributedString = [NSMutableAttributedString h_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:self.h_font alignment:alignment];
    [self appendAttributedString:attributedString];
    return imageView;
}


//插入图片，alignment默认为HTextVerticalAlignmentCenter
- (HWebImageView *)insertImageWithSize:(CGSize)size atIndex:(NSUInteger)loc {
    return [self insertImageWithSize:size atIndex:loc alignment:HTextVerticalAlignmentCenter];
}
- (HWebImageView *)insertImageWithSize:(CGSize)size atIndex:(NSUInteger)loc alignment:(HTextVerticalAlignment)alignment {
    HWebImageView *imageView = [[HWebImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    NSMutableAttributedString *attributedString = [NSMutableAttributedString h_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:self.h_font alignment:alignment];
    [self insertAttributedString:attributedString atIndex:loc];
    return imageView;
}



//追加button，alignment默认为HTextVerticalAlignmentCenter
- (HWebButtonView *)appendButtonWithSize:(CGSize)size {
    return [self appendButtonWithSize:size alignment:HTextVerticalAlignmentCenter];
}
- (HWebButtonView *)appendButtonWithSize:(CGSize)size alignment:(HTextVerticalAlignment)alignment {
    HWebButtonView *buttonView = [[HWebButtonView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    NSMutableAttributedString *attributedString = [NSMutableAttributedString h_attachmentStringWithContent:buttonView contentMode:UIViewContentModeScaleAspectFit attachmentSize:buttonView.frame.size alignToFont:self.h_font alignment:alignment];
    [self appendAttributedString:attributedString];
    return buttonView;
}

//插入button，alignment默认为HTextVerticalAlignmentCenter
- (HWebButtonView *)insertButtonWithSize:(CGSize)size atIndex:(NSUInteger)loc {
    return [self insertButtonWithSize:size atIndex:loc alignment:HTextVerticalAlignmentCenter];
}
- (HWebButtonView *)insertButtonWithSize:(CGSize)size atIndex:(NSUInteger)loc alignment:(HTextVerticalAlignment)alignment {
    HWebButtonView *buttonView = [[HWebButtonView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    NSMutableAttributedString *attributedString = [NSMutableAttributedString h_attachmentStringWithContent:buttonView contentMode:UIViewContentModeScaleAspectFit attachmentSize:buttonView.frame.size alignToFont:self.h_font alignment:alignment];
    [self insertAttributedString:attributedString atIndex:loc];
    return buttonView;
}

@end
