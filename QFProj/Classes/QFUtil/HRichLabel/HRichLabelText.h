//
//  HRichLabelText.h
//  HRichLabel
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRichLabelAttribute.h"

NS_ASSUME_NONNULL_BEGIN
@interface NSAttributedString (HRichLabel)
- (CGSize)getSize;
- (CGFloat)getWidth;
- (CGFloat)getHeight;
@end

@interface NSMutableAttributedString (HRichLabel)

@property (nullable, nonatomic, strong) HTextHighlight *highlight;
@property (nullable, nonatomic, strong) HTextBorder *border;

@property (nullable, nonatomic, copy) HTextBlock singleTap;
@property (nullable, nonatomic, copy) HTextBlock longPress;

- (void)setUnderlineStyle:(NSUnderlineStyle)style color:(UIColor *)color;

// default style is NSUnderlineStyleSingle, default color is blackColor
- (void)setDefaultUnderlineStyleAndColor;

- (void)setDefaultLinkColor;
- (void)setDefaultLink;
- (void)setDefaultLinkWithSucceed:(dispatch_block_t)sBlock
                           failed:(dispatch_block_t)fBlock
NS_AVAILABLE_IOS(10_0)
NS_EXTENSION_UNAVAILABLE_IOS("");

- (void)h_setFont:(UIFont *)font;
- (void)h_setFont:(UIFont *)font inRange:(NSRange)range;

- (void)h_setTextColor:(UIColor *)color;
- (void)h_setTextColor:(UIColor *)color inRange:(NSRange)range;


- (instancetype)initWithString:(NSString *)str
                     singleTap:(nullable HTextBlock)singleTap;

- (instancetype)initWithAttributeString:(NSAttributedString *)str
                              singleTap:(nullable HTextBlock)singleTap;

- (instancetype)initWithAttachment:(HTextAttachment *)attachment
                         singleTap:(nullable HTextBlock)singleTap;



- (instancetype)initWithString:(NSString *)str
                     singleTap:(nullable HTextBlock)singleTap
                     longPress:(nullable HTextBlock)longPress;

- (instancetype)initWithAttributeString:(NSAttributedString *)str
                              singleTap:(nullable HTextBlock)singleTap
                              longPress:(nullable HTextBlock)longPress;

- (instancetype)initWithAttachment:(HTextAttachment *)attachment
                         singleTap:(nullable HTextBlock)singleTap
                         longPress:(nullable HTextBlock)longPress;

- (void)appendString:(NSString *)text;
- (void)appendString:(NSString *)text singleTap:(nullable HTextBlock)singleTap;

- (void)insertString:(NSString *)text atIndex:(NSUInteger)loc;
- (void)insertString:(NSString *)text atIndex:(NSUInteger)loc singleTap:(nullable HTextBlock)singleTap;

- (void)appendAttachment:(HTextAttachment *)attachment;
- (void)appendAttachment:(HTextAttachment *)attachment singleTap:(nullable HTextBlock)singleTap;

- (void)insertAttachment:(HTextAttachment *)attachment atIndex:(NSUInteger)loc;
- (void)insertAttachment:(HTextAttachment *)attachment atIndex:(NSUInteger)loc singleTap:(nullable HTextBlock)singleTap;

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)text singleTap:(nullable HTextBlock)singleTap;
@end

NS_ASSUME_NONNULL_END
