//
//  HRichLabelAttribute.h
//  HRichLabel
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - const

UIKIT_EXTERN NSString *const HTextTruncationToken;
UIKIT_EXTERN NSString *const HTextAttachmentToken;

UIKIT_EXTERN NSString *const HTextAttachmentAttributeKey;
UIKIT_EXTERN NSString *const HTextSingleTapAttributeKey;
UIKIT_EXTERN NSString *const HTextLongPressAttributeKey;

UIKIT_EXTERN NSString *const HTextHighlightAttributeKey;
UIKIT_EXTERN NSString *const HTextBorderAttributeKey;

#pragma mark - function

static inline NSArray* HTextCustomAttributeNames() {
    return @[
             HTextAttachmentAttributeKey,
             HTextSingleTapAttributeKey,
             HTextLongPressAttributeKey,
             HTextHighlightAttributeKey,
             HTextBorderAttributeKey
             ];
}

static inline void HTextRemoveCustomAttributes(NSMutableDictionary *_Nullable* _Nonnull attrs) {
    for (NSString *key in HTextCustomAttributeNames()) {
        [*attrs removeObjectForKey:key];
    }
}

static inline CFRange HTextCFRangeFromNSRange(NSRange range) {
    return CFRangeMake(range.location, range.length);
}

static inline NSRange HTextNSRangeFromCFRange(CFRange range) {
    return NSMakeRange(range.location, range.length);
}

static inline CGRect HTextTransformatCoordinateSystem(CGRect rect) {
    CGAffineTransform transform = CGAffineTransformMakeScale(1.f, -1.f);
    return CGRectApplyAffineTransform(rect, transform);
}

static inline CGPoint HTextRoundPoint(CGPoint p) {
    CGFloat x = roundf(p.x);
    CGFloat y = roundf(p.y);
    return CGPointMake(x, y);
}

static inline CGSize HTextRoundSize(CGSize s) {
    CGFloat w = roundf(s.width);
    CGFloat h = roundf(s.height);
    return CGSizeMake(w, h);
}

static inline CGRect HTextRoundRect(CGRect r) {
    CGPoint p = HTextRoundPoint(r.origin);
    CGSize s = HTextRoundSize(r.size);
    return (CGRect){p, s};
}

static inline CGSize HTextCeilSize(CGSize s) {
    CGFloat w = ceilf(s.width);
    CGFloat h = ceilf(s.height);
    return CGSizeMake(w, h);
}


#pragma mark - enum

typedef NS_ENUM(NSInteger, HTextVerticalAlignment) {
    HTextVerticalAlignmentTop = 0,
    HTextVerticalAlignmentCenter,
    HTextVerticalAlignmentBottom
};

typedef NS_ENUM(NSInteger, HTextAttachmentAlignment) {
    HTextAttachmentAlignmentTop = 0,
    HTextAttachmentAlignmentCenter,
    HTextAttachmentAlignmentBottom
};


#pragma mark - class

@interface HTextHighlight : NSObject
@property (nullable, nonatomic, strong) UIColor *textColor;
@property (nullable, nonatomic, strong) UIColor *underlineColor;
@property (nullable, nonatomic, strong) UIColor *innerColor;
@property (nullable, nonatomic, strong) UIColor *borderColor;
@end

@interface HTextBorder : NSObject

// default is 1.f
@property (nonatomic) CGFloat width;
// default is black color
@property (nonatomic, strong) UIColor *color;
// default is 5.f
@property (nonatomic) CGFloat cornerRadius;
// default is UIEdgeInsetsZero
@property (nonatomic) UIEdgeInsets insets;

@property (nullable, nonatomic, strong) UIColor *innerColor;

+ (instancetype)defaultBorder;
+ (instancetype)borderWithWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

@end


@interface HTextAttachment : NSObject

// supported type: UIImage/UIView/CALayer
@property (nonatomic, strong, readonly) id content;

// default is content's size
@property (nonatomic, readonly) CGSize contentSize;

// default is HTextAttachmentAlignmentCenter
@property (nonatomic) HTextAttachmentAlignment alignment;

@property (nonatomic, readonly) CGFloat runDelegateAsent;
@property (nonatomic, readonly) CGFloat runDelegateDesent;
@property (nonatomic, readonly) CGFloat runDelegateWidth;

@property (nonatomic, strong) NSDictionary *infoDictionary;

+ (instancetype)attachmentWithContent:(id)content contentSize:(CGSize)contentSize alignToFont:(nullable UIFont *)font;

- (CTRunDelegateRef)runDelegate;

@end



typedef void(^HTextBlock)(UIView *targetView, NSAttributedString *attributeString, HTextAttachment *_Nullable attachment);

@interface HTextInfo : NSObject

@property (nonatomic, strong) NSAttributedString *text;
@property (nonatomic, strong) NSValue *rectValue;
@property (nonatomic, strong) NSValue *rangeValue;

@property (nullable, nonatomic, strong) HTextAttachment *attachment;
@property (nullable, nonatomic, copy) HTextBlock singleTap;
@property (nullable, nonatomic, copy) HTextBlock longPress;

@property (nullable, nonatomic, strong) HTextHighlight *highlight;
@property (nullable, nonatomic, strong) HTextBorder *border;

@end

@interface HTextInfoContainer : NSObject

@property (nonatomic, strong, readonly) NSArray<NSAttributedString *> *texts;
@property (nonatomic, strong, readonly) NSArray<NSValue *> *rects;
@property (nonatomic, strong, readonly) NSArray<NSValue *> *ranges;

@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, HTextAttachment *> *attachmentDict;
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, HTextBlock> *singleTapDict;
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, HTextBlock> *longPressDict;

@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, HTextHighlight *> *highlightDict;
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, HTextBorder *> *borderDict;

@property (nullable, nonatomic, strong, readonly) HTextInfo *responseInfo;

+ (instancetype)infoContainer;

- (void)addObjectFromInfo:(HTextInfo *)info;
- (void)addObjectFromInfoContainer:(HTextInfoContainer *)infoContainer;

- (BOOL)canResponseUserActionAtPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
