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
@property(nonatomic) NSString *words;
@property(nonatomic) UIFont   *font;
@property(nonatomic) UIColor  *color;
@end

@interface HTapKeywords : NSObject
@property(nonatomic) NSArray *words;
@property(nonatomic) HTapKeywordsBlock tapBlock;
@end


@interface HStringFormatter : NSObject

@property(nonatomic) NSString *string;
@property(nonatomic) CGFloat charSpace;

@property(nonatomic) HKeywords  *keywords;
@property(nonatomic) HKeywords  *middleline;
@property(nonatomic) HKeywords  *underline;

- (NSMutableAttributedString *)attributedStringFor:(HStringFormatter *)formatter;

@end

@interface HStringFormatter2 : HStringFormatter
@property(nonatomic) CGFloat lineSpace;
@property(nonatomic) HTapKeywords *tapKeywords;
@end

@interface NSString (HStringFormatter)
- (NSMutableAttributedString *)makeAttributes:(void(^)(HStringFormatter *make))block;
- (NSMutableAttributedString *)addAttributes:(void(^)(HStringFormatter *make))block;
@end
