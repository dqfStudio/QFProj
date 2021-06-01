//
//  HStringFormatter.h
//  QFProj
//
//  Created by Wind on 2021/5/24.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "NSAttributedString+HText.h"

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

//追加图片
- (void)appendImageName:(NSString *)imageName size:(CGSize)size;
- (void)appendImageName:(NSString *)imageName size:(CGSize)size alignment:(HTextVerticalAlignment)alignment;
//插入图片
- (void)insertImageName:(NSString *)imageName size:(CGSize)size atIndex:(NSUInteger)loc;
- (void)insertImageName:(NSString *)imageName size:(CGSize)size atIndex:(NSUInteger)loc alignment:(HTextVerticalAlignment)alignment;

@end
