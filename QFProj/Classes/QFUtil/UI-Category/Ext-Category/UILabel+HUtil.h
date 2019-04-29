//
//  UILabel+HUtil.h
//  TestProject
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+HMessy.h"
#import "UILabel+HAttributeText.h"
#import "NSMutableAttributedString+HUtil.h"

typedef NS_ENUM(NSInteger, NSWordAlign) {
    NSWordAlignBottom = 0,
    NSWordAlignCenter,
    NSWordAlignTop
};

typedef void(^HTapKeywordsBlock)(NSInteger index);

@interface UILabel (HUtil)

@property (nonatomic, readonly) NSMutableAttributedString *mutableAttributedString;

//字间距
- (void)setCharSpace:(CGFloat)space;
//行间距
- (void)setLineSpace:(CGFloat)space;
//关键字
- (void)setKeywords:(NSString *)keywords font:(NSFont *)font color:(UIColor *)color;
//点击事件
- (void)setTapKeywords:(NSArray *)keywords block:(HTapKeywordsBlock)tapBlock;
//中线
- (void)setMiddleline:(NSString *)keywords font:(NSFont *)font color:(UIColor *)color;
//下划线
- (void)setUnderline:(NSString *)keywords font:(NSFont *)font color:(UIColor *)color;

//插入图片
- (void)setImageUrl:(NSString *)url
              index:(NSInteger)idx
               size:(CGSize)size
          leftSpace:(NSInteger)left
         rightSpace:(NSInteger)right
          wordAlign:(NSWordAlign)align;

//字间距
- (void)setCharWith:(NSArray <NSNumber *>*)idxs space:(NSArray <NSNumber *>*)spaces;

/**
 计算label宽高
 
 @param maxWidth 最大宽度
 @return label的size
 */
- (CGSize)sizeThatWidth:(CGFloat)maxWidth;

@end
