//
//  HStringFormatter.h
//  QFProj
//
//  Created by Wind on 2021/5/24.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "NSAttributedString+HText.h"
#import "HWebButtonView.h"
#import "HWebImageView.h"
#import "HCommonBlock.h"

typedef void(^HTextActionBlock)(NSAttributedString *text, NSRange range);

@interface NSMutableAttributedString (HStringFormatter)
//设置字体大小
- (void)makeFont:(UIFont *)font range:(NSRange)range;
//设置字体颜色
- (void)makeColor:(UIColor *)color range:(NSRange)range;
//设置字间距
- (void)makeCharspace:(CGFloat)charspace range:(NSRange)range;
//设置行间距
- (void)makeLinespace:(CGFloat)linespace range:(NSRange)range;
//设置中线
- (void)makeMiddleline:(NSRange)range;
//设置下划线
- (void)makeUnderline:(NSRange)range;
//设置点击事件
- (void)makeTapAction:(NSRange)range tapAction:(HTextActionBlock)block;


//追加图片，alignment默认为HTextVerticalAlignmentCenter
- (HWebImageView *)appendImageWithSize:(CGSize)size;
- (HWebImageView *)appendImageWithSize:(CGSize)size alignment:(HTextVerticalAlignment)alignment;

//插入图片，alignment默认为HTextVerticalAlignmentCenter
- (HWebImageView *)insertImageWithSize:(CGSize)size atIndex:(NSUInteger)loc;
- (HWebImageView *)insertImageWithSize:(CGSize)size atIndex:(NSUInteger)loc alignment:(HTextVerticalAlignment)alignment;


//追加button，alignment默认为HTextVerticalAlignmentCenter
- (HWebButtonView *)appendButtonWithSize:(CGSize)size;
- (HWebButtonView *)appendButtonWithSize:(CGSize)size alignment:(HTextVerticalAlignment)alignment;

//插入button，alignment默认为HTextVerticalAlignmentCenter
- (HWebButtonView *)insertButtonWithSize:(CGSize)size atIndex:(NSUInteger)loc;
- (HWebButtonView *)insertButtonWithSize:(CGSize)size atIndex:(NSUInteger)loc alignment:(HTextVerticalAlignment)alignment;

@end
