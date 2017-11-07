//
//  UILabel+QFUtil.h
//  TestProject
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (QFUtil)

//字间距
@property (nonatomic, assign) CGFloat  characterSpace;
//行间距
@property (nonatomic, assign) CGFloat  lineSpace;

//关键字
@property (nonatomic, copy)   NSString *keywords;
@property (nonatomic, strong) UIFont   *keywordsFont;
@property (nonatomic, strong) UIColor  *keywordsColor;

//下划线
@property (nonatomic, copy)   NSString *underlineStr;
@property (nonatomic, strong) UIFont   *underlineFont;
@property (nonatomic, strong) UIColor  *underlineColor;

//中线
@property (nonatomic, copy)   NSString *middlelineStr;
@property (nonatomic, strong) UIFont   *middlelineFont;
@property (nonatomic, strong) UIColor  *middlelineColor;

/**
 计算label宽高

 @param maxWidth 最大宽度
 @return label的size
 */
- (CGSize)sizeThatWidth:(CGFloat)maxWidth;

/**
 使设置的格式有效
 */
- (void)formatThatFits;

@end
