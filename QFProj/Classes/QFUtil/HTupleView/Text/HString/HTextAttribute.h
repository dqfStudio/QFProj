//
//  HTextAttribute.h
//
//  Created by ibireme on 14/10/26.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum Define

/// The attribute type
typedef NS_OPTIONS(NSInteger, HTextAttributeType) {
    HTextAttributeTypeNone     = 0,
    HTextAttributeTypeUIKit    = 1 << 0, ///< UIKit attributes, such as UILabel/UITextField/drawInRect.
    HTextAttributeTypeCoreText = 1 << 1, ///< CoreText attributes, used by CoreText.
    HTextAttributeTypeHText   = 1 << 2, ///< HText attributes, used by HText.
};

/// Get the attribute type from an attribute name.
extern HTextAttributeType HTextAttributeGetType(NSString *attributeName);

/**
 Line style in HText (similar to NSUnderlineStyle).
 */
typedef NS_OPTIONS (NSInteger, HTextLineStyle) {
    // basic style (bitmask:0xFF)
    HTextLineStyleNone       = 0x00, ///< (        ) Do not draw a line (Default).
    HTextLineStyleSingle     = 0x01, ///< (──────) Draw a single line.
    HTextLineStyleThick      = 0x02, ///< (━━━━━━━) Draw a thick line.
    HTextLineStyleDouble     = 0x09, ///< (══════) Draw a double line.
    
    // style pattern (bitmask:0xF00)
    HTextLineStylePatternSolid      = 0x000, ///< (────────) Draw a solid line (Default).
    HTextLineStylePatternDot        = 0x100, ///< (‑ ‑ ‑ ‑ ‑ ‑) Draw a line of dots.
    HTextLineStylePatternDash       = 0x200, ///< (— — — —) Draw a line of dashes.
    HTextLineStylePatternDashDot    = 0x300, ///< (— ‑ — ‑ — ‑) Draw a line of alternating dashes and dots.
    HTextLineStylePatternDashDotDot = 0x400, ///< (— ‑ ‑ — ‑ ‑) Draw a line of alternating dashes and two dots.
    HTextLineStylePatternCircleDot  = 0x900, ///< (••••••••••••) Draw a line of small circle dots.
};

/**
 Text vertical alignment.
 */
typedef NS_ENUM(NSInteger, HTextVerticalAlignment) {
    HTextVerticalAlignmentTop =    0, ///< Top alignment.
    HTextVerticalAlignmentCenter = 1, ///< Center alignment.
    HTextVerticalAlignmentBottom = 2, ///< Bottom alignment.
};

/**
 The direction define in HText.
 */
typedef NS_OPTIONS(NSUInteger, HTextDirection) {
    HTextDirectionNone   = 0,
    HTextDirectionTop    = 1 << 0,
    HTextDirectionRight  = 1 << 1,
    HTextDirectionBottom = 1 << 2,
    HTextDirectionLeft   = 1 << 3,
};

/**
 The trunction type, tells the truncation engine which type of truncation is being requested.
 */
typedef NS_ENUM (NSUInteger, HTextTruncationType) {
    /// No truncate.
    HTextTruncationTypeNone   = 0,
    
    /// Truncate at the beginning of the line, leaving the end portion visible.
    HTextTruncationTypeStart  = 1,
    
    /// Truncate at the end of the line, leaving the start portion visible.
    HTextTruncationTypeEnd    = 2,
    
    /// Truncate in the middle of the line, leaving both the start and the end portions visible.
    HTextTruncationTypeMiddle = 3,
};



#pragma mark - Attribute Name Defined in HText

/// The value of this attribute is a `HTextBackedString` object.
/// Use this attribute to store the original plain text if it is replaced by something else (such as attachment).
UIKIT_EXTERN NSString *const HTextBackedStringAttributeName;

/// The value of this attribute is a `HTextBinding` object.
/// Use this attribute to bind a range of text together, as if it was a single charactor.
UIKIT_EXTERN NSString *const HTextBindingAttributeName;

/// The value of this attribute is a `HTextShadow` object.
/// Use this attribute to add shadow to a range of text.
/// Shadow will be drawn below text glyphs. Use HTextShadow.subShadow to add multi-shadow.
UIKIT_EXTERN NSString *const HTextShadowAttributeName;

/// The value of this attribute is a `HTextShadow` object.
/// Use this attribute to add inner shadow to a range of text.
/// Inner shadow will be drawn above text glyphs. Use HTextShadow.subShadow to add multi-shadow.
UIKIT_EXTERN NSString *const HTextInnerShadowAttributeName;

/// The value of this attribute is a `HTextDecoration` object.
/// Use this attribute to add underline to a range of text.
/// The underline will be drawn below text glyphs.
UIKIT_EXTERN NSString *const HTextUnderlineAttributeName;

/// The value of this attribute is a `HTextDecoration` object.
/// Use this attribute to add strikethrough (delete line) to a range of text.
/// The strikethrough will be drawn above text glyphs.
UIKIT_EXTERN NSString *const HTextStrikethroughAttributeName;

/// The value of this attribute is a `HTextBorder` object.
/// Use this attribute to add cover border or cover color to a range of text.
/// The border will be drawn above the text glyphs.
UIKIT_EXTERN NSString *const HTextBorderAttributeName;

/// The value of this attribute is a `HTextBorder` object.
/// Use this attribute to add background border or background color to a range of text.
/// The border will be drawn below the text glyphs.
UIKIT_EXTERN NSString *const HTextBackgroundBorderAttributeName;

/// The value of this attribute is a `HTextBorder` object.
/// Use this attribute to add a code block border to one or more line of text.
/// The border will be drawn below the text glyphs.
UIKIT_EXTERN NSString *const HTextBlockBorderAttributeName;

/// The value of this attribute is a `HTextAttachment` object.
/// Use this attribute to add attachment to text.
/// It should be used in conjunction with a CTRunDelegate.
UIKIT_EXTERN NSString *const HTextAttachmentAttributeName;

/// The value of this attribute is a `HTextHighlight` object.
/// Use this attribute to add a touchable highlight state to a range of text.
UIKIT_EXTERN NSString *const HTextHighlightAttributeName;

/// The value of this attribute is a `NSValue` object stores CGAffineTransform.
/// Use this attribute to add transform to each glyph in a range of text.
UIKIT_EXTERN NSString *const HTextGlyphTransformAttributeName;



#pragma mark - String Token Define

UIKIT_EXTERN NSString *const HTextAttachmentToken; ///< Object replacement character (U+FFFC), used for text attachment.
UIKIT_EXTERN NSString *const HTextTruncationToken; ///< Horizontal ellipsis (U+2026), used for text truncation  "…".



#pragma mark - Attribute Value Define

/**
 The tap/long press action callback defined in HText.
 
 @param containerView The text container view (such as HLabel/HTextView).
 @param text          The whole text.
 @param range         The text range in `text` (if no range, the range.location is NSNotFound).
 @param rect          The text frame in `containerView` (if no data, the rect is CGRectNull).
 */
typedef void(^HTextAction)(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect);


/**
 HTextBackedString objects are used by the NSAttributedString class cluster
 as the values for text backed string attributes (stored in the attributed 
 string under the key named HTextBackedStringAttributeName).
 
 It may used for copy/paste plain text from attributed string.
 Example: If :) is replace by a custom emoji (such as😊), the backed string can be set to @":)".
 */
@interface HTextBackedString : NSObject <NSCoding, NSCopying>
+ (instancetype)stringWithString:(nullable NSString *)string;
@property (nullable, nonatomic, copy) NSString *string; ///< backed string
@end


/**
 HTextBinding objects are used by the NSAttributedString class cluster
 as the values for shadow attributes (stored in the attributed string under
 the key named HTextBindingAttributeName).
 
 Add this to a range of text will make the specified characters 'binding together'.
 HTextView will treat the range of text as a single character during text
 selection and edit.
 */
@interface HTextBinding : NSObject <NSCoding, NSCopying>
+ (instancetype)bindingWithDeleteConfirm:(BOOL)deleteConfirm;
@property (nonatomic) BOOL deleteConfirm; ///< confirm the range when delete in HTextView
@end


/**
 HTextShadow objects are used by the NSAttributedString class cluster
 as the values for shadow attributes (stored in the attributed string under
 the key named HTextShadowAttributeName or HTextInnerShadowAttributeName).
 
 It's similar to `NSShadow`, but offers more options.
 */
@interface HTextShadow : NSObject <NSCoding, NSCopying>
+ (instancetype)shadowWithColor:(nullable UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

@property (nullable, nonatomic, strong) UIColor *color; ///< shadow color
@property (nonatomic) CGSize offset;                    ///< shadow offset
@property (nonatomic) CGFloat radius;                   ///< shadow blur radius
@property (nonatomic) CGBlendMode blendMode;            ///< shadow blend mode
@property (nullable, nonatomic, strong) HTextShadow *subShadow;  ///< a sub shadow which will be added above the parent shadow

+ (instancetype)shadowWithNSShadow:(NSShadow *)nsShadow; ///< convert NSShadow to HTextShadow
- (NSShadow *)nsShadow; ///< convert HTextShadow to NSShadow
@end


/**
 HTextDecorationLine objects are used by the NSAttributedString class cluster
 as the values for decoration line attributes (stored in the attributed string under
 the key named HTextUnderlineAttributeName or HTextStrikethroughAttributeName).
 
 When it's used as underline, the line is drawn below text glyphs;
 when it's used as strikethrough, the line is drawn above text glyphs.
 */
@interface HTextDecoration : NSObject <NSCoding, NSCopying>
+ (instancetype)decorationWithStyle:(HTextLineStyle)style;
+ (instancetype)decorationWithStyle:(HTextLineStyle)style width:(nullable NSNumber *)width color:(nullable UIColor *)color;
@property (nonatomic) HTextLineStyle style;                   ///< line style
@property (nullable, nonatomic, strong) NSNumber *width;       ///< line width (nil means automatic width)
@property (nullable, nonatomic, strong) UIColor *color;        ///< line color (nil means automatic color)
@property (nullable, nonatomic, strong) HTextShadow *shadow;  ///< line shadow
@end


/**
 HTextBorder objects are used by the NSAttributedString class cluster
 as the values for border attributes (stored in the attributed string under
 the key named HTextBorderAttributeName or HTextBackgroundBorderAttributeName).
 
 It can be used to draw a border around a range of text, or draw a background
 to a range of text.
 
 Example:
    ╭──────╮
    │ Text │
    ╰──────╯
 */
@interface HTextBorder : NSObject <NSCoding, NSCopying>
+ (instancetype)borderWithLineStyle:(HTextLineStyle)lineStyle lineWidth:(CGFloat)width strokeColor:(nullable UIColor *)color;
+ (instancetype)borderWithFillColor:(nullable UIColor *)color cornerRadius:(CGFloat)cornerRadius;
@property (nonatomic) HTextLineStyle lineStyle;              ///< border line style
@property (nonatomic) CGFloat strokeWidth;                    ///< border line width
@property (nullable, nonatomic, strong) UIColor *strokeColor; ///< border line color
@property (nonatomic) CGLineJoin lineJoin;                    ///< border line join
@property (nonatomic) UIEdgeInsets insets;                    ///< border insets for text bounds
@property (nonatomic) CGFloat cornerRadius;                   ///< border corder radius
@property (nullable, nonatomic, strong) HTextShadow *shadow; ///< border shadow
@property (nullable, nonatomic, strong) UIColor *fillColor;   ///< inner fill color
@end


/**
 HTextAttachment objects are used by the NSAttributedString class cluster
 as the values for attachment attributes (stored in the attributed string under 
 the key named HTextAttachmentAttributeName).
 
 When display an attributed string which contains `HTextAttachment` object,
 the content will be placed in text metric. If the content is `UIImage`, 
 then it will be drawn to CGContext; if the content is `UIView` or `CALayer`, 
 then it will be added to the text container's view or layer.
 */
@interface HTextAttachment : NSObject<NSCoding, NSCopying>
+ (instancetype)attachmentWithContent:(nullable id)content;
@property (nullable, nonatomic, strong) id content;             ///< Supported type: UIImage, UIView, CALayer
@property (nonatomic) UIViewContentMode contentMode;            ///< Content display mode.
@property (nonatomic) UIEdgeInsets contentInsets;               ///< The insets when drawing content.
@property (nullable, nonatomic, strong) NSDictionary *userInfo; ///< The user information dictionary.
@end


/**
 HTextHighlight objects are used by the NSAttributedString class cluster
 as the values for touchable highlight attributes (stored in the attributed string
 under the key named HTextHighlightAttributeName).
 
 When display an attributed string in `HLabel` or `HTextView`, the range of
 highlight text can be toucheds down by users. If a range of text is turned into 
 highlighted state, the `attributes` in `HTextHighlight` will be used to modify 
 (set or remove) the original attributes in the range for display.
 */
@interface HTextHighlight : NSObject <NSCoding, NSCopying>

/**
 Attributes that you can apply to text in an attributed string when highlight.
 Key:   Same as CoreText/HText Attribute Name.
 Value: Modify attribute value when highlight (NSNull for remove attribute).
 */
@property (nullable, nonatomic, copy) NSDictionary<NSString *, id> *attributes;

/**
 Creates a highlight object with specified attributes.
 
 @param attributes The attributes which will replace original attributes when highlight,
        If the value is NSNull, it will removed when highlight.
 */
+ (instancetype)highlightWithAttributes:(nullable NSDictionary<NSString *, id> *)attributes;

/**
 Convenience methods to create a default highlight with the specifeid background color.
 
 @param color The background border color.
 */
+ (instancetype)highlightWithBackgroundColor:(nullable UIColor *)color;

// Convenience methods below to set the `attributes`.
- (void)setFont:(nullable UIFont *)font;
- (void)setColor:(nullable UIColor *)color;
- (void)setStrokeWidth:(nullable NSNumber *)width;
- (void)setStrokeColor:(nullable UIColor *)color;
- (void)setShadow:(nullable HTextShadow *)shadow;
- (void)setInnerShadow:(nullable HTextShadow *)shadow;
- (void)setUnderline:(nullable HTextDecoration *)underline;
- (void)setStrikethrough:(nullable HTextDecoration *)strikethrough;
- (void)setBackgroundBorder:(nullable HTextBorder *)border;
- (void)setBorder:(nullable HTextBorder *)border;
- (void)setAttachment:(nullable HTextAttachment *)attachment;

/**
 The user information dictionary, default is nil.
 */
@property (nullable, nonatomic, copy) NSDictionary *userInfo;

/**
 Tap action when user tap the highlight, default is nil.
 If the value is nil, HTextView or HLabel will ask it's delegate to handle the tap action.
 */
@property (nullable, nonatomic, copy) HTextAction tapAction;

/**
 Long press action when user long press the highlight, default is nil.
 If the value is nil, HTextView or HLabel will ask it's delegate to handle the long press action.
 */
@property (nullable, nonatomic, copy) HTextAction longPressAction;

@end

NS_ASSUME_NONNULL_END
