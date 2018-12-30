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

typedef NS_ENUM(NSInteger, NSWordAlign) {
    NSWordAlignBottom = 0,
    NSWordAlignCenter,
    NSWordAlignTop
};

typedef void(^HTapKeywordsBlock)(NSInteger index);

@interface UILabel (HUtil)

//字间距
@property (nonatomic, assign) CGFloat  characterSpace;
//行间距
@property (nonatomic, assign) CGFloat  lineSpace;

//关键字
@property (nonatomic, copy)   NSString *keywords;
@property (nonatomic, strong) UIFont   *keywordsFont;
@property (nonatomic, strong) UIColor  *keywordsColor;

//点击事件
@property (nonatomic, copy)   NSArray *tapKeywordsArr;
@property (nonatomic, copy)   HTapKeywordsBlock tapKeywordsBlock;

//插入图片
@property (nonatomic, assign) NSInteger   imgIndex;
@property (nonatomic, assign) NSWordAlign wordAlign;
@property (nonatomic, assign) CGSize      imgSize;
@property (nonatomic, strong) NSString    *imgUrl;
@property (nonatomic, assign) NSInteger   leftSpace;
@property (nonatomic, assign) NSInteger   rightSpace;

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
 获取上述设置的属性字符串，此方法需要在所有属性设置后调用
 */
- (NSAttributedString *)getCustomFormatString;

/**
 使设置的格式有效
 */
- (void)formatThatFits;

@end
