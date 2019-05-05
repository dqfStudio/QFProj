//
//  HRichLabelText.m
//  HRichLabel
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HRichLabelText.h"
#import <objc/runtime.h>

@implementation NSAttributedString (HRichLabel)
- (CGSize)getSize {
    CGSize boundingSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    return [self boundingRectWithSize:boundingSize
                              options:NSStringDrawingUsesLineFragmentOrigin|
            NSStringDrawingUsesFontLeading|
            NSStringDrawingUsesDeviceMetrics|
            NSStringDrawingTruncatesLastVisibleLine
                              context:nil].size;
}
- (CGFloat)getWidth {
    return [self getSize].width;
}
- (CGFloat)getHeight {
    return [self getSize].height;
}
@end


@implementation NSMutableAttributedString (HRichLabel)

static void const * HTextHighlightKey = &HTextHighlightKey;
static void const * HTextBorderKey = &HTextBorderKey;
static void const * HTextSingleTapKey = &HTextSingleTapKey;
static void const * HTextLongPressKey = &HTextLongPressKey;


- (void)setHighlight:(HTextHighlight *)highlight {
    if (!highlight) return;
    objc_setAssociatedObject(self, HTextHighlightKey, highlight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addAttribute:HTextHighlightAttributeKey value:highlight range:NSMakeRange(0, self.length)];
}

- (HTextHighlight *)highlight {
    return objc_getAssociatedObject(self, HTextHighlightKey);
}

- (void)setBorder:(HTextBorder *)border {
    if (!border) return;
    objc_setAssociatedObject(self, HTextBorderKey, border, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addAttribute:HTextBorderAttributeKey value:border range:NSMakeRange(0, self.length)];
}

- (HTextBorder *)border {
    return objc_getAssociatedObject(self, HTextBorderKey);
}

- (void)setSingleTap:(HTextBlock)singleTap {
    if (!singleTap) return;
    objc_setAssociatedObject(self, HTextSingleTapKey, [singleTap copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addAttribute:HTextSingleTapAttributeKey value:self.singleTap range:NSMakeRange(0, self.length)];
}

- (HTextBlock)singleTap {
    return objc_getAssociatedObject(self, HTextSingleTapKey);
}

- (void)setLongPress:(HTextBlock)longPress {
    if (!longPress) return;
    objc_setAssociatedObject(self, HTextLongPressKey, [longPress copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addAttribute:HTextLongPressAttributeKey value:self.longPress range:NSMakeRange(0, self.length)];
}

- (HTextBlock)longPress {
    return objc_getAssociatedObject(self, HTextLongPressKey);
}


- (void)setUnderlineStyle:(NSUnderlineStyle)style color:(UIColor *)color {
    NSMutableDictionary *attrs = @{}.mutableCopy;
    [attrs setValue:@(style) forKey:NSUnderlineStyleAttributeName];
    [attrs setValue:color forKey:NSUnderlineColorAttributeName];
    [self addAttributes:attrs range:NSMakeRange(0, self.length)];
}

- (void)setDefaultUnderlineStyleAndColor {
    [self setUnderlineStyle:NSUnderlineStyleSingle color:[UIColor blackColor]];
}

- (void)setDefaultLinkColor {
    UIColor *linkColor = [UIColor blueColor];
    [self setUnderlineStyle:NSUnderlineStyleSingle color:linkColor];
    [self addAttribute:NSForegroundColorAttributeName value:linkColor range:NSMakeRange(0, self.length)];
}

- (void)setDefaultLink {
    [self setDefaultLinkColor];
    self.singleTap = ^(UIView * _Nonnull targetView, NSAttributedString * _Nonnull attributeString, HTextAttachment * _Nullable attachment) {
        NSURL *url = [NSURL URLWithString:attributeString.string];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[UIApplication sharedApplication] openURL:url];
#pragma clang diagnostic pop
        }
    };
}

- (void)setDefaultLinkWithSucceed:(dispatch_block_t)sBlock failed:(dispatch_block_t)fBlock {
    [self setDefaultLinkColor];
    self.singleTap = ^(UIView * _Nonnull targetView, NSAttributedString * _Nonnull attributeString, HTextAttachment * _Nullable attachment) {
        NSURL *url = [NSURL URLWithString:attributeString.string];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    !sBlock ? : sBlock();
                } else {
                    !fBlock ? : fBlock();
                }
            }];
        }
    };
}

- (void)h_setFont:(id)font {
    [self h_setFont:font inRange:NSMakeRange(0, self.length)];
}

- (void)h_setFont:(id)font inRange:(NSRange)range {
    [self addAttribute:NSFontAttributeName value:font range:range];
}

- (void)h_setTextColor:(UIColor *)color {
    [self h_setTextColor:color inRange:NSMakeRange(0, self.length)];
}

- (void)h_setTextColor:(UIColor *)color inRange:(NSRange)range {
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}


- (instancetype)initWithString:(NSString *)str singleTap:(nullable HTextBlock)singleTap {
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:str];
    if (singleTap) {
        one.singleTap = singleTap;
    }
    return one;
}

- (instancetype)initWithString:(NSString *)str singleTap:(nullable HTextBlock)singleTap longPress:(nullable HTextBlock)longPress {
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:str singleTap:singleTap];
    if (longPress) {
        one.longPress = longPress;
    }
    return one;
}

- (instancetype)initWithAttributeString:(NSAttributedString *)str singleTap:(nullable HTextBlock)singleTap {
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithAttributedString:str];
    if (singleTap) {
        one.singleTap = singleTap;
    }
    return one;
}

- (instancetype)initWithAttributeString:(NSAttributedString *)str singleTap:(nullable HTextBlock)singleTap longPress:(nullable HTextBlock)longPress {
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithAttributeString:str singleTap:singleTap];
    if (longPress) {
        one.longPress = longPress;
    }
    return one;
}

- (instancetype)initWithAttachment:(HTextAttachment *)attachment singleTap:(nullable HTextBlock)singleTap {
    NSMutableAttributedString *attachmentToken = [[NSMutableAttributedString alloc] initWithString:HTextAttachmentToken];
    
    NSMutableDictionary *attrs = @{}.mutableCopy;
    [attrs setObject:attachment forKey:HTextAttachmentAttributeKey];
    if (singleTap) {
        attachmentToken.singleTap = singleTap;
    }
    
    CTRunDelegateRef runDelegate = attachment.runDelegate;
    
    [attrs setValue:(__bridge id _Nullable)(runDelegate) forKey:(__bridge_transfer NSString *)kCTRunDelegateAttributeName];
    
    [attachmentToken addAttributes:attrs range:NSMakeRange(0, attachmentToken.length)];
    CFRelease(runDelegate);
    
    return attachmentToken;
}

- (instancetype)initWithAttachment:(HTextAttachment *)attachment singleTap:(nullable HTextBlock)singleTap longPress:(nullable HTextBlock)longPress {
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithAttachment:attachment singleTap:singleTap];
    if (longPress) {
        one.longPress = longPress;
    }
    return one;
}

- (void)appendString:(NSString *)text {
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:text];
    [self appendAttributedString:str];
}
- (void)appendString:(NSString *)text singleTap:(nullable HTextBlock)singleTap {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text singleTap:singleTap];
    [self appendAttributedString:str];
}

- (void)insertString:(NSString *)text atIndex:(NSUInteger)loc {
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:text];
    [self insertAttributedString:str atIndex:loc];
}
- (void)insertString:(NSString *)text atIndex:(NSUInteger)loc singleTap:(nullable HTextBlock)singleTap {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text singleTap:singleTap];
    [self insertAttributedString:str atIndex:loc];
}


- (void)appendAttachment:(HTextAttachment *)attachment {
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithAttachment:attachment singleTap:nil];
    [self appendAttributedString:one];
}
- (void)appendAttachment:(HTextAttachment *)attachment singleTap:(nullable HTextBlock)singleTap {
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithAttachment:attachment singleTap:singleTap];
    [self appendAttributedString:one];
}

- (void)insertAttachment:(HTextAttachment *)attachment atIndex:(NSUInteger)loc {
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithAttachment:attachment singleTap:nil];
    [self insertAttributedString:one atIndex:loc];
}
- (void)insertAttachment:(HTextAttachment *)attachment atIndex:(NSUInteger)loc singleTap:(nullable HTextBlock)singleTap {
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithAttachment:attachment singleTap:singleTap];
    [self insertAttributedString:one atIndex:loc];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)text singleTap:(nullable HTextBlock)singleTap {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text singleTap:singleTap];
    [self replaceCharactersInRange:range withAttributedString:str];
}

@end
