//
//  HLabel+HUtil.h
//  QFProj
//
//  Created by wind on 2019/6/7.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLabel.h"
#import "NSObject+HMessy.h"
#import "UILabel+HAttributeText.h"
#import "NSMutableAttributedString+HUtil.h"
#import "NSAttributedString+HText.h"
#import "NSString+HChain.h"
#import "UIColor+HUtil.h"
#import "HText.h"

typedef void(^HTapKeywordsBlock)(void);

@interface HLabel (HUtil)

@property (nonatomic, readonly) NSMutableAttributedString *mutableAttributedString;

//字间距
- (void)setCharSpace:(CGFloat)space;
//行间距
- (void)setLineSpace:(CGFloat)space;
//关键字
- (void)setKeywords:(NSString *)keywords font:(UIFont *)font color:(UIColor *)color;
//点击事件
- (void)setTapKeywords:(NSString *)keywords color:(UIColor *)color block:(HTapKeywordsBlock)tapBlock;
//中线
- (void)setMiddleline:(NSString *)keywords font:(UIFont *)font color:(UIColor *)color;
//下划线
- (void)setUnderline:(NSString *)keywords color:(UIColor *)color;
//字间距
- (void)setCharWith:(NSArray <NSNumber *>*)idxs space:(NSArray <NSNumber *>*)spaces;

/**
 计算label宽高
 
 @param maxWidth 最大宽度
 @return label的size
 */
- (CGSize)sizeThatWidth:(CGFloat)maxWidth;

@end
