//
//  HRichLabel+HUtil.h
//  TestProject
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRichLabel.h"
#import "NSObject+HMessy.h"
#import "NSMutableAttributedString+HUtil.h"
#import "NSString+HChain.h"
#import "UIColor+HUtil.h"
#import "HWebImageView.h"
#import "UIView+HUtil.h"

typedef void(^HTapKeywordsBlock)(void);
//supported type: UIImage/UIView/CALayer
typedef id(^HAttachmentBlock)(void);

@interface HRichLabel (HUtil)

@property (nonatomic, readonly) NSMutableAttributedString *mutableAttributedString;

//关键字
- (void)setKeywords:(NSString *)keywords font:(UIFont *)font color:(UIColor *)color;
//追加字符串
- (void)appendString:(NSString *)text;
- (void)insertString:(NSString *)text atIndex:(NSInteger)loc;
//点击事件
- (void)appendTapKeywords:(NSString *)keywords block:(HTapKeywordsBlock)tapBlock;
- (void)insertTapKeywords:(NSString *)keywords atIndex:(NSInteger)loc block:(HTapKeywordsBlock)tapBlock;
- (void)setTapKeywords:(NSString *)keywords block:(HTapKeywordsBlock)tapBlock;
//中线
- (void)setMiddleline:(NSString *)keywords;
- (void)setMiddleline:(NSString *)keywords font:(UIFont *)font color:(UIColor *)color;
//下划线
- (void)setUnderline:(NSString *)keywords;
- (void)setUnderline:(NSString *)keywords font:(UIFont *)font color:(UIColor *)color;
//插入图片
- (void)appendAttachment:(HAttachmentBlock)block font:(UIFont *)font;
- (void)insertAttachment:(HAttachmentBlock)block atIndex:(NSInteger)loc font:(UIFont *)font;

//解析如下字符串
//NSString *string = @"</flag=global,linespace=5,lines=0,font=12,color=123456/>张三李四</font=12,color=123456,headerspace=5,footerspace=10/>张三</font=12,color=123456,click=true,underliane=true,middleline=true,headerspace=auto/>李四";
- (void)parse:(NSString *)aString;

/**
 计算label宽高
 
 @param maxWidth 最大宽度
 @return label的size
 */
- (CGSize)sizeThatWidth:(CGFloat)maxWidth;

@end
