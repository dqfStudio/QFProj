//
//  HStringFormatter.h
//  QFProj
//
//  Created by Wind on 2021/5/24.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HTapKeywordsBlock)(NSInteger index);

@interface HKeywords : NSObject
@property(nonatomic) NSString *words; //关键字
@property(nonatomic) UIFont   *font; //字体
@property(nonatomic) UIColor  *color; //颜色
@end

@interface HTapKeywords : NSObject
@property(nonatomic) NSArray *words; //可点击字体数组
@property(nonatomic) HTapKeywordsBlock tapBlock; //点击回调
@end


@interface HStringFormatter : NSObject

@property(nonatomic) NSString *string; //需要格式化的字符串
@property(nonatomic) CGFloat charSpace; //字间距

@property(nonatomic) HKeywords  *keywords; //关键字
@property(nonatomic) HKeywords  *middleline; //中线
@property(nonatomic) HKeywords  *underline; //下划线

- (NSMutableAttributedString *)attributedStringFor:(HStringFormatter *)formatter;

@end

@interface HStringFormatter2 : HStringFormatter
@property(nonatomic) CGFloat lineSpace; //行间距
@property(nonatomic) HTapKeywords *tapKeywords; //可点击字符串
@end

@interface NSString (HStringFormatter)
- (NSMutableAttributedString *)makeAttributes:(void(^)(HStringFormatter *make))block; //字符串添加熟悉
- (NSMutableAttributedString *)addAttributes:(void(^)(HStringFormatter *make))block; //添加属性字符串
@end
