//
//  UILabel+HUtil.h
//  HProj
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+HMessy.h"
#import "UILabel+HAttributeText.h"
#import "NSMutableAttributedString+HUtil.h"
#import "NSString+HChain.h"
#import "UIColor+HUtil.h"
#import "HStringFormatter.h"

@interface UILabel (HUtil)

////解析如下字符串
////NSString *string = @"</flag=global,linespace=5,lines=0,font=12,color=123456/>张三李四</font=12,color=123456,headerspace=5,footerspace=10/>张三</font=12,color=123456,click=true,underliane=true,middleline=true,headerspace=auto/>李四";
//- (void)parse:(NSString *)aString block:(HTapKeywordsBlock)tapBlock;

- (void)makeAttributes:(void(^)(HStringFormatter2 *make))block;

/**
 计算label宽高
 
 @param maxWidth 最大宽度
 @return label的size
 */
- (CGSize)sizeThatWidth:(CGFloat)maxWidth;

@end
