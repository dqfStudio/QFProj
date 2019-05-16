//
//  NSAttributedString+HText.m
//
//  Created by ibireme on 14/10/7.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSAttributedString+HText.h"
#import "NSParagraphStyle+HText.h"
#import "HTextArchiver.h"
#import "HTextRunDelegate.h"
#import "HTextUtilities.h"
#import <CoreFoundation/CoreFoundation.h>


// Dummy class for category
@interface NSAttributedString_HText : NSObject @end
@implementation NSAttributedString_HText @end


static double _HDeviceSystemVersion() {
    static double version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion.doubleValue;
    });
    return version;
}

#ifndef kHSystemVersion
#define kHSystemVersion _HDeviceSystemVersion()
#endif

#ifndef kHiOS6Later
#define kHiOS6Later (kHSystemVersion >= 6)
#endif

#ifndef kHiOS7Later
#define kHiOS7Later (kHSystemVersion >= 7)
#endif

#ifndef kHiOS8Later
#define kHiOS8Later (kHSystemVersion >= 8)
#endif

#ifndef kHiOS9Later
#define kHiOS9Later (kHSystemVersion >= 9)
#endif



@implementation NSAttributedString (HText)

- (NSData *)h_archiveToData {
    NSData *data = nil;
    @try {
        data = [HTextArchiver archivedDataWithRootObject:self];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    return data;
}

+ (instancetype)h_unarchiveFromData:(NSData *)data {
    NSAttributedString *one = nil;
    @try {
        one = [HTextUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    return one;
}

- (NSDictionary *)h_attributesAtIndex:(NSUInteger)index {
    if (index > self.length || self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attributesAtIndex:index effectiveRange:NULL];
}

- (id)h_attribute:(NSString *)attributeName atIndex:(NSUInteger)index {
    if (!attributeName) return nil;
    if (index > self.length || self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attribute:attributeName atIndex:index effectiveRange:NULL];
}

- (NSDictionary *)h_attributes {
    return [self h_attributesAtIndex:0];
}

- (UIFont *)h_font {
    return [self h_fontAtIndex:0];
}

- (UIFont *)h_fontAtIndex:(NSUInteger)index {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    UIFont *font = [self h_attribute:NSFontAttributeName atIndex:index];
    if (kHSystemVersion <= 6) {
        if (font) {
            if (CFGetTypeID((__bridge CFTypeRef)(font)) == CTFontGetTypeID()) {
                CTFontRef CTFont = (__bridge CTFontRef)(font);
                CFStringRef name = CTFontCopyPostScriptName(CTFont);
                CGFloat size = CTFontGetSize(CTFont);
                if (!name) {
                    font = nil;
                } else {
                    font = [UIFont fontWithName:(__bridge NSString *)(name) size:size];
                    CFRelease(name);
                }
            }
        }
    }
    return font;
}

- (NSNumber *)h_kern {
    return [self h_kernAtIndex:0];
}

- (NSNumber *)h_kernAtIndex:(NSUInteger)index {
    return [self h_attribute:NSKernAttributeName atIndex:index];
}

- (UIColor *)h_color {
    return [self h_colorAtIndex:0];
}

- (UIColor *)h_colorAtIndex:(NSUInteger)index {
    UIColor *color = [self h_attribute:NSForegroundColorAttributeName atIndex:index];
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self h_attribute:(NSString *)kCTForegroundColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    if (color && ![color isKindOfClass:[UIColor class]]) {
        if (CFGetTypeID((__bridge CFTypeRef)(color)) == CGColorGetTypeID()) {
            color = [UIColor colorWithCGColor:(__bridge CGColorRef)(color)];
        } else {
            color = nil;
        }
    }
    return color;
}

- (UIColor *)h_backgroundColor {
    return [self h_backgroundColorAtIndex:0];
}

- (UIColor *)h_backgroundColorAtIndex:(NSUInteger)index {
    return [self h_attribute:NSBackgroundColorAttributeName atIndex:index];
}

- (NSNumber *)h_strokeWidth {
    return [self h_strokeWidthAtIndex:0];
}

- (NSNumber *)h_strokeWidthAtIndex:(NSUInteger)index {
    return [self h_attribute:NSStrokeWidthAttributeName atIndex:index];
}

- (UIColor *)h_strokeColor {
    return [self h_strokeColorAtIndex:0];
}

- (UIColor *)h_strokeColorAtIndex:(NSUInteger)index {
    UIColor *color = [self h_attribute:NSStrokeColorAttributeName atIndex:index];
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self h_attribute:(NSString *)kCTStrokeColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    return color;
}

- (NSShadow *)h_shadow {
    return [self h_shadowAtIndex:0];
}

- (NSShadow *)h_shadowAtIndex:(NSUInteger)index {
    return [self h_attribute:NSShadowAttributeName atIndex:index];
}

- (NSUnderlineStyle)h_strikethroughStyle {
    return [self h_strikethroughStyleAtIndex:0];
}

- (NSUnderlineStyle)h_strikethroughStyleAtIndex:(NSUInteger)index {
    NSNumber *style = [self h_attribute:NSStrikethroughStyleAttributeName atIndex:index];
    return style.integerValue;
}

- (UIColor *)h_strikethroughColor {
    return [self h_strikethroughColorAtIndex:0];
}

- (UIColor *)h_strikethroughColorAtIndex:(NSUInteger)index {
    if (kHSystemVersion >= 7) {
        return [self h_attribute:NSStrikethroughColorAttributeName atIndex:index];
    }
    return nil;
}

- (NSUnderlineStyle)h_underlineStyle {
    return [self h_underlineStyleAtIndex:0];
}

- (NSUnderlineStyle)h_underlineStyleAtIndex:(NSUInteger)index {
    NSNumber *style = [self h_attribute:NSUnderlineStyleAttributeName atIndex:index];
    return style.integerValue;
}

- (UIColor *)h_underlineColor {
    return [self h_underlineColorAtIndex:0];
}

- (UIColor *)h_underlineColorAtIndex:(NSUInteger)index {
    UIColor *color = nil;
    if (kHSystemVersion >= 7) {
        color = [self h_attribute:NSUnderlineColorAttributeName atIndex:index];
    }
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self h_attribute:(NSString *)kCTUnderlineColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    return color;
}

- (NSNumber *)h_ligature {
    return [self h_ligatureAtIndex:0];
}

- (NSNumber *)h_ligatureAtIndex:(NSUInteger)index {
    return [self h_attribute:NSLigatureAttributeName atIndex:index];
}

- (NSString *)h_textEffect {
    return [self h_textEffectAtIndex:0];
}

- (NSString *)h_textEffectAtIndex:(NSUInteger)index {
    if (kHSystemVersion >= 7) {
        return [self h_attribute:NSTextEffectAttributeName atIndex:index];
    }
    return nil;
}

- (NSNumber *)h_obliqueness {
    return [self h_obliquenessAtIndex:0];
}

- (NSNumber *)h_obliquenessAtIndex:(NSUInteger)index {
    if (kHSystemVersion >= 7) {
        return [self h_attribute:NSObliquenessAttributeName atIndex:index];
    }
    return nil;
}

- (NSNumber *)h_expansion {
    return [self h_expansionAtIndex:0];
}

- (NSNumber *)h_expansionAtIndex:(NSUInteger)index {
    if (kHSystemVersion >= 7) {
        return [self h_attribute:NSExpansionAttributeName atIndex:index];
    }
    return nil;
}

- (NSNumber *)h_baselineOffset {
    return [self h_baselineOffsetAtIndex:0];
}

- (NSNumber *)h_baselineOffsetAtIndex:(NSUInteger)index {
    if (kHSystemVersion >= 7) {
        return [self h_attribute:NSBaselineOffsetAttributeName atIndex:index];
    }
    return nil;
}

- (BOOL)h_verticalGlyphForm {
    return [self h_verticalGlyphFormAtIndex:0];
}

- (BOOL)h_verticalGlyphFormAtIndex:(NSUInteger)index {
    NSNumber *num = [self h_attribute:NSVerticalGlyphFormAttributeName atIndex:index];
    return num.boolValue;
}

- (NSString *)h_language {
    return [self h_languageAtIndex:0];
}

- (NSString *)h_languageAtIndex:(NSUInteger)index {
    if (kHSystemVersion >= 7) {
        return [self h_attribute:(id)kCTLanguageAttributeName atIndex:index];
    }
    return nil;
}

- (NSArray *)h_writingDirection {
    return [self h_writingDirectionAtIndex:0];
}

- (NSArray *)h_writingDirectionAtIndex:(NSUInteger)index {
    return [self h_attribute:(id)kCTWritingDirectionAttributeName atIndex:index];
}

- (NSParagraphStyle *)h_paragraphStyle {
    return [self h_paragraphStyleAtIndex:0];
}

- (NSParagraphStyle *)h_paragraphStyleAtIndex:(NSUInteger)index {
    /*
     NSParagraphStyle is NOT toll-free bridged to CTParagraphStyleRef.
     
     CoreText can use both NSParagraphStyle and CTParagraphStyleRef,
     but UILabel/UITextView can only use NSParagraphStyle.
     
     We use NSParagraphStyle in both CoreText and UIKit.
     */
    NSParagraphStyle *style = [self h_attribute:NSParagraphStyleAttributeName atIndex:index];
    if (style) {
        if (CFGetTypeID((__bridge CFTypeRef)(style)) == CTParagraphStyleGetTypeID()) { \
            style = [NSParagraphStyle h_styleWithCTStyle:(__bridge CTParagraphStyleRef)(style)];
        }
    }
    return style;
}

#define HParagraphAttribute(_attr_) \
NSParagraphStyle *style = self.h_paragraphStyle; \
if (!style) style = [NSParagraphStyle defaultParagraphStyle]; \
return style. _attr_;

#define HParagraphAttributeAtIndex(_attr_) \
NSParagraphStyle *style = [self h_paragraphStyleAtIndex:index]; \
if (!style) style = [NSParagraphStyle defaultParagraphStyle]; \
return style. _attr_;

- (NSTextAlignment)h_alignment {
    HParagraphAttribute(alignment);
}

- (NSLineBreakMode)h_lineBreakMode {
    HParagraphAttribute(lineBreakMode);
}

- (CGFloat)h_lineSpacing {
    HParagraphAttribute(lineSpacing);
}

- (CGFloat)h_paragraphSpacing {
    HParagraphAttribute(paragraphSpacing);
}

- (CGFloat)h_paragraphSpacingBefore {
    HParagraphAttribute(paragraphSpacingBefore);
}

- (CGFloat)h_firstLineHeadIndent {
    HParagraphAttribute(firstLineHeadIndent);
}

- (CGFloat)h_headIndent {
    HParagraphAttribute(headIndent);
}

- (CGFloat)h_tailIndent {
    HParagraphAttribute(tailIndent);
}

- (CGFloat)h_minimumLineHeight {
    HParagraphAttribute(minimumLineHeight);
}

- (CGFloat)h_maximumLineHeight {
    HParagraphAttribute(maximumLineHeight);
}

- (CGFloat)h_lineHeightMultiple {
    HParagraphAttribute(lineHeightMultiple);
}

- (NSWritingDirection)h_baseWritingDirection {
    HParagraphAttribute(baseWritingDirection);
}

- (float)h_hyphenationFactor {
    HParagraphAttribute(hyphenationFactor);
}

- (CGFloat)h_defaultTabInterval {
    if (!kHiOS7Later) return 0;
    HParagraphAttribute(defaultTabInterval);
}

- (NSArray *)h_tabStops {
    if (!kHiOS7Later) return nil;
    HParagraphAttribute(tabStops);
}

- (NSTextAlignment)h_alignmentAtIndex:(NSUInteger)index {
    HParagraphAttributeAtIndex(alignment);
}

- (NSLineBreakMode)h_lineBreakModeAtIndex:(NSUInteger)index {
    HParagraphAttributeAtIndex(lineBreakMode);
}

- (CGFloat)h_lineSpacingAtIndex:(NSUInteger)index {
    HParagraphAttributeAtIndex(lineSpacing);
}

- (CGFloat)h_paragraphSpacingAtIndex:(NSUInteger)index {
    HParagraphAttributeAtIndex(paragraphSpacing);
}

- (CGFloat)h_paragraphSpacingBeforeAtIndex:(NSUInteger)index {
    HParagraphAttributeAtIndex(paragraphSpacingBefore);
}

- (CGFloat)h_firstLineHeadIndentAtIndex:(NSUInteger)index {
    HParagraphAttributeAtIndex(firstLineHeadIndent);
}

- (CGFloat)h_headIndentAtIndex:(NSUInteger)index {
    HParagraphAttributeAtIndex(headIndent);
}

- (CGFloat)h_tailIndentAtIndex:(NSUInteger)index {
    HParagraphAttributeAtIndex(tailIndent);
}

- (CGFloat)h_minimumLineHeightAtIndex:(NSUInteger)index {
    HParagraphAttributeAtIndex(minimumLineHeight);
}

- (CGFloat)h_maximumLineHeightAtIndex:(NSUInteger)index {
    HParagraphAttributeAtIndex(maximumLineHeight);
}

- (CGFloat)h_lineHeightMultipleAtIndex:(NSUInteger)index {
    HParagraphAttributeAtIndex(lineHeightMultiple);
}

- (NSWritingDirection)h_baseWritingDirectionAtIndex:(NSUInteger)index {
    HParagraphAttributeAtIndex(baseWritingDirection);
}

- (float)h_hyphenationFactorAtIndex:(NSUInteger)index {
    HParagraphAttributeAtIndex(hyphenationFactor);
}

- (CGFloat)h_defaultTabIntervalAtIndex:(NSUInteger)index {
    if (!kHiOS7Later) return 0;
    HParagraphAttributeAtIndex(defaultTabInterval);
}

- (NSArray *)h_tabStopsAtIndex:(NSUInteger)index {
    if (!kHiOS7Later) return nil;
    HParagraphAttributeAtIndex(tabStops);
}

#undef HParagraphAttribute
#undef HParagraphAttributeAtIndex

- (HTextShadow *)h_textShadow {
    return [self h_textShadowAtIndex:0];
}

- (HTextShadow *)h_textShadowAtIndex:(NSUInteger)index {
    return [self h_attribute:HTextShadowAttributeName atIndex:index];
}

- (HTextShadow *)h_textInnerShadow {
    return [self h_textInnerShadowAtIndex:0];
}

- (HTextShadow *)h_textInnerShadowAtIndex:(NSUInteger)index {
    return [self h_attribute:HTextInnerShadowAttributeName atIndex:index];
}

- (HTextDecoration *)h_textUnderline {
    return [self h_textUnderlineAtIndex:0];
}

- (HTextDecoration *)h_textUnderlineAtIndex:(NSUInteger)index {
    return [self h_attribute:HTextUnderlineAttributeName atIndex:index];
}

- (HTextDecoration *)h_textStrikethrough {
    return [self h_textStrikethroughAtIndex:0];
}

- (HTextDecoration *)h_textStrikethroughAtIndex:(NSUInteger)index {
    return [self h_attribute:HTextStrikethroughAttributeName atIndex:index];
}

- (HTextBorder *)h_textBorder {
    return [self h_textBorderAtIndex:0];
}

- (HTextBorder *)h_textBorderAtIndex:(NSUInteger)index {
    return [self h_attribute:HTextBorderAttributeName atIndex:index];
}

- (HTextBorder *)h_textBackgroundBorder {
    return [self h_textBackgroundBorderAtIndex:0];
}

- (HTextBorder *)h_textBackgroundBorderAtIndex:(NSUInteger)index {
    return [self h_attribute:HTextBackedStringAttributeName atIndex:index];
}

- (CGAffineTransform)h_textGlyphTransform {
    return [self h_textGlyphTransformAtIndex:0];
}

- (CGAffineTransform)h_textGlyphTransformAtIndex:(NSUInteger)index {
    NSValue *value = [self h_attribute:HTextGlyphTransformAttributeName atIndex:index];
    if (!value) return CGAffineTransformIdentity;
    return [value CGAffineTransformValue];
}

- (NSString *)h_plainTextForRange:(NSRange)range {
    if (range.location == NSNotFound ||range.length == NSNotFound) return nil;
    NSMutableString *result = [NSMutableString string];
    if (range.length == 0) return result;
    NSString *string = self.string;
    [self enumerateAttribute:HTextBackedStringAttributeName inRange:range options:kNilOptions usingBlock:^(id value, NSRange range, BOOL *stop) {
        HTextBackedString *backed = value;
        if (backed && backed.string) {
            [result appendString:backed.string];
        } else {
            [result appendString:[string substringWithRange:range]];
        }
    }];
    return result;
}

+ (NSMutableAttributedString *)h_attachmentStringWithContent:(id)content
                                                  contentMode:(UIViewContentMode)contentMode
                                                        width:(CGFloat)width
                                                       ascent:(CGFloat)ascent
                                                      descent:(CGFloat)descent {
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:HTextAttachmentToken];
    
    HTextAttachment *attach = [HTextAttachment new];
    attach.content = content;
    attach.contentMode = contentMode;
    [atr h_setTextAttachment:attach range:NSMakeRange(0, atr.length)];
    
    HTextRunDelegate *delegate = [HTextRunDelegate new];
    delegate.width = width;
    delegate.ascent = ascent;
    delegate.descent = descent;
    CTRunDelegateRef delegateRef = delegate.CTRunDelegate;
    [atr h_setRunDelegate:delegateRef range:NSMakeRange(0, atr.length)];
    if (delegate) CFRelease(delegateRef);
    
    return atr;
}

+ (NSMutableAttributedString *)h_attachmentStringWithContent:(id)content
                                                  contentMode:(UIViewContentMode)contentMode
                                               attachmentSize:(CGSize)attachmentSize
                                                  alignToFont:(UIFont *)font
                                                    alignment:(HTextVerticalAlignment)alignment {
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:HTextAttachmentToken];
    
    HTextAttachment *attach = [HTextAttachment new];
    attach.content = content;
    attach.contentMode = contentMode;
    [atr h_setTextAttachment:attach range:NSMakeRange(0, atr.length)];
    
    HTextRunDelegate *delegate = [HTextRunDelegate new];
    delegate.width = attachmentSize.width;
    switch (alignment) {
        case HTextVerticalAlignmentTop: {
            delegate.ascent = font.ascender;
            delegate.descent = attachmentSize.height - font.ascender;
            if (delegate.descent < 0) {
                delegate.descent = 0;
                delegate.ascent = attachmentSize.height;
            }
        } break;
        case HTextVerticalAlignmentCenter: {
            CGFloat fontHeight = font.ascender - font.descender;
            CGFloat yOffset = font.ascender - fontHeight * 0.5;
            delegate.ascent = attachmentSize.height * 0.5 + yOffset;
            delegate.descent = attachmentSize.height - delegate.ascent;
            if (delegate.descent < 0) {
                delegate.descent = 0;
                delegate.ascent = attachmentSize.height;
            }
        } break;
        case HTextVerticalAlignmentBottom: {
            delegate.ascent = attachmentSize.height + font.descender;
            delegate.descent = -font.descender;
            if (delegate.ascent < 0) {
                delegate.ascent = 0;
                delegate.descent = attachmentSize.height;
            }
        } break;
        default: {
            delegate.ascent = attachmentSize.height;
            delegate.descent = 0;
        } break;
    }
    
    CTRunDelegateRef delegateRef = delegate.CTRunDelegate;
    [atr h_setRunDelegate:delegateRef range:NSMakeRange(0, atr.length)];
    if (delegate) CFRelease(delegateRef);
    
    return atr;
}

+ (NSMutableAttributedString *)h_attachmentStringWithEmojiImage:(UIImage *)image
                                                        fontSize:(CGFloat)fontSize {
    if (!image || fontSize <= 0) return nil;
    
    BOOL hasAnim = NO;
    if (image.images.count > 1) {
        hasAnim = YES;
    } else if (NSProtocolFromString(@"HAnimatedImage") &&
               [image conformsToProtocol:NSProtocolFromString(@"HAnimatedImage")]) {
        NSNumber *frameCount = [image valueForKey:@"animatedImageFrameCount"];
        if (frameCount.intValue > 1) hasAnim = YES;
    }
    
    CGFloat ascent = HTextEmojiGetAscentWithFontSize(fontSize);
    CGFloat descent = HTextEmojiGetDescentWithFontSize(fontSize);
    CGRect bounding = HTextEmojiGetGlyphBoundingRectWithFontSize(fontSize);
    
    HTextRunDelegate *delegate = [HTextRunDelegate new];
    delegate.ascent = ascent;
    delegate.descent = descent;
    delegate.width = bounding.size.width + 2 * bounding.origin.x;
    
    HTextAttachment *attachment = [HTextAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = UIEdgeInsetsMake(ascent - (bounding.size.height + bounding.origin.y), bounding.origin.x, descent + bounding.origin.y, bounding.origin.x);
    if (hasAnim) {
        Class imageClass = NSClassFromString(@"HAnimatedImageView");
        if (!imageClass) imageClass = [UIImageView class];
        UIImageView *view = (id)[imageClass new];
        view.frame = bounding;
        view.image = image;
        view.contentMode = UIViewContentModeScaleAspectFit;
        attachment.content = view;
    } else {
        attachment.content = image;
    }
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:HTextAttachmentToken];
    [atr h_setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr h_setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

- (NSRange)h_rangeOfAll {
    return NSMakeRange(0, self.length);
}

- (BOOL)h_isSharedAttributesInAllRange {
    __block BOOL shared = YES;
    __block NSDictionary *firstAttrs = nil;
    [self enumerateAttributesInRange:self.h_rangeOfAll options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        if (range.location == 0) {
            firstAttrs = attrs;
        } else {
            if (firstAttrs.count != attrs.count) {
                shared = NO;
                *stop = YES;
            } else if (firstAttrs) {
                if (![firstAttrs isEqualToDictionary:attrs]) {
                    shared = NO;
                    *stop = YES;
                }
            }
        }
    }];
    return shared;
}

- (BOOL)h_canDrawWithUIKit {
    static NSMutableSet *failSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        failSet = [NSMutableSet new];
        [failSet addObject:(id)kCTGlyphInfoAttributeName];
        [failSet addObject:(id)kCTCharacterShapeAttributeName];
        if (kHiOS7Later) {
            [failSet addObject:(id)kCTLanguageAttributeName];
        }
        [failSet addObject:(id)kCTRunDelegateAttributeName];
        [failSet addObject:(id)kCTBaselineClassAttributeName];
        [failSet addObject:(id)kCTBaselineInfoAttributeName];
        [failSet addObject:(id)kCTBaselineReferenceInfoAttributeName];
        if (kHiOS8Later) {
            [failSet addObject:(id)kCTRubyAnnotationAttributeName];
        }
        [failSet addObject:HTextShadowAttributeName];
        [failSet addObject:HTextInnerShadowAttributeName];
        [failSet addObject:HTextUnderlineAttributeName];
        [failSet addObject:HTextStrikethroughAttributeName];
        [failSet addObject:HTextBorderAttributeName];
        [failSet addObject:HTextBackgroundBorderAttributeName];
        [failSet addObject:HTextBlockBorderAttributeName];
        [failSet addObject:HTextAttachmentAttributeName];
        [failSet addObject:HTextHighlightAttributeName];
        [failSet addObject:HTextGlyphTransformAttributeName];
    });
    
#define Fail { result = NO; *stop = YES; return; }
    __block BOOL result = YES;
    [self enumerateAttributesInRange:self.h_rangeOfAll options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        if (attrs.count == 0) return;
        for (NSString *str in attrs.allKeys) {
            if ([failSet containsObject:str]) Fail;
        }
        if (!kHiOS7Later) {
            UIFont *font = attrs[NSFontAttributeName];
            if (CFGetTypeID((__bridge CFTypeRef)(font)) == CTFontGetTypeID()) Fail;
        }
        if (attrs[(id)kCTForegroundColorAttributeName] && !attrs[NSForegroundColorAttributeName]) Fail;
        if (attrs[(id)kCTStrokeColorAttributeName] && !attrs[NSStrokeColorAttributeName]) Fail;
        if (attrs[(id)kCTUnderlineColorAttributeName]) {
            if (!kHiOS7Later) Fail;
            if (!attrs[NSUnderlineColorAttributeName]) Fail;
        }
        NSParagraphStyle *style = attrs[NSParagraphStyleAttributeName];
        if (style && CFGetTypeID((__bridge CFTypeRef)(style)) == CTParagraphStyleGetTypeID()) Fail;
    }];
    return result;
#undef Fail
}

@end

@implementation NSMutableAttributedString (HText)

- (void)h_setAttributes:(NSDictionary *)attributes {
    [self setH_attributes:attributes];
}

- (void)setH_attributes:(NSDictionary *)attributes {
    if (attributes == (id)[NSNull null]) attributes = nil;
    [self setAttributes:@{} range:NSMakeRange(0, self.length)];
    [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self h_setAttribute:key value:obj];
    }];
}

- (void)h_setAttribute:(NSString *)name value:(id)value {
    [self h_setAttribute:name value:value range:NSMakeRange(0, self.length)];
}

- (void)h_setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    if (value && ![NSNull isEqual:value]) [self addAttribute:name value:value range:range];
    else [self removeAttribute:name range:range];
}

- (void)h_removeAttributesInRange:(NSRange)range {
    [self setAttributes:nil range:range];
}

#pragma mark - Property Setter

- (void)setH_font:(UIFont *)font {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    [self h_setFont:font range:NSMakeRange(0, self.length)];
}

- (void)setH_kern:(NSNumber *)kern {
    [self h_setKern:kern range:NSMakeRange(0, self.length)];
}

- (void)setH_color:(UIColor *)color {
    [self h_setColor:color range:NSMakeRange(0, self.length)];
}

- (void)setH_backgroundColor:(UIColor *)backgroundColor {
    [self h_setBackgroundColor:backgroundColor range:NSMakeRange(0, self.length)];
}

- (void)setH_strokeWidth:(NSNumber *)strokeWidth {
    [self h_setStrokeWidth:strokeWidth range:NSMakeRange(0, self.length)];
}

- (void)setH_strokeColor:(UIColor *)strokeColor {
    [self h_setStrokeColor:strokeColor range:NSMakeRange(0, self.length)];
}

- (void)setH_shadow:(NSShadow *)shadow {
    [self h_setShadow:shadow range:NSMakeRange(0, self.length)];
}

- (void)setH_strikethroughStyle:(NSUnderlineStyle)strikethroughStyle {
    [self h_setStrikethroughStyle:strikethroughStyle range:NSMakeRange(0, self.length)];
}

- (void)setH_strikethroughColor:(UIColor *)strikethroughColor {
    [self h_setStrikethroughColor:strikethroughColor range:NSMakeRange(0, self.length)];
}

- (void)setH_underlineStyle:(NSUnderlineStyle)underlineStyle {
    [self h_setUnderlineStyle:underlineStyle range:NSMakeRange(0, self.length)];
}

- (void)setH_underlineColor:(UIColor *)underlineColor {
    [self h_setUnderlineColor:underlineColor range:NSMakeRange(0, self.length)];
}

- (void)setH_ligature:(NSNumber *)ligature {
    [self h_setLigature:ligature range:NSMakeRange(0, self.length)];
}

- (void)setH_textEffect:(NSString *)textEffect {
    [self h_setTextEffect:textEffect range:NSMakeRange(0, self.length)];
}

- (void)setH_obliqueness:(NSNumber *)obliqueness {
    [self h_setObliqueness:obliqueness range:NSMakeRange(0, self.length)];
}

- (void)setH_expansion:(NSNumber *)expansion {
    [self h_setExpansion:expansion range:NSMakeRange(0, self.length)];
}

- (void)setH_baselineOffset:(NSNumber *)baselineOffset {
    [self h_setBaselineOffset:baselineOffset range:NSMakeRange(0, self.length)];
}

- (void)setH_verticalGlyphForm:(BOOL)verticalGlyphForm {
    [self h_setVerticalGlyphForm:verticalGlyphForm range:NSMakeRange(0, self.length)];
}

- (void)setH_language:(NSString *)language {
    [self h_setLanguage:language range:NSMakeRange(0, self.length)];
}

- (void)setH_writingDirection:(NSArray *)writingDirection {
    [self h_setWritingDirection:writingDirection range:NSMakeRange(0, self.length)];
}

- (void)setH_paragraphStyle:(NSParagraphStyle *)paragraphStyle {
    /*
     NSParagraphStyle is NOT toll-free bridged to CTParagraphStyleRef.
     
     CoreText can use both NSParagraphStyle and CTParagraphStyleRef,
     but UILabel/UITextView can only use NSParagraphStyle.
     
     We use NSParagraphStyle in both CoreText and UIKit.
     */
    [self h_setParagraphStyle:paragraphStyle range:NSMakeRange(0, self.length)];
}

- (void)setH_alignment:(NSTextAlignment)alignment {
    [self h_setAlignment:alignment range:NSMakeRange(0, self.length)];
}

- (void)setH_baseWritingDirection:(NSWritingDirection)baseWritingDirection {
    [self h_setBaseWritingDirection:baseWritingDirection range:NSMakeRange(0, self.length)];
}

- (void)setH_lineSpacing:(CGFloat)lineSpacing {
    [self h_setLineSpacing:lineSpacing range:NSMakeRange(0, self.length)];
}

- (void)setH_paragraphSpacing:(CGFloat)paragraphSpacing {
    [self h_setParagraphSpacing:paragraphSpacing range:NSMakeRange(0, self.length)];
}

- (void)setH_paragraphSpacingBefore:(CGFloat)paragraphSpacingBefore {
    [self h_setParagraphSpacing:paragraphSpacingBefore range:NSMakeRange(0, self.length)];
}

- (void)setH_firstLineHeadIndent:(CGFloat)firstLineHeadIndent {
    [self h_setFirstLineHeadIndent:firstLineHeadIndent range:NSMakeRange(0, self.length)];
}

- (void)setH_headIndent:(CGFloat)headIndent {
    [self h_setHeadIndent:headIndent range:NSMakeRange(0, self.length)];
}

- (void)setH_tailIndent:(CGFloat)tailIndent {
    [self h_setTailIndent:tailIndent range:NSMakeRange(0, self.length)];
}

- (void)setH_lineBreakMode:(NSLineBreakMode)lineBreakMode {
    [self h_setLineBreakMode:lineBreakMode range:NSMakeRange(0, self.length)];
}

- (void)setH_minimumLineHeight:(CGFloat)minimumLineHeight {
    [self h_setMinimumLineHeight:minimumLineHeight range:NSMakeRange(0, self.length)];
}

- (void)setH_maximumLineHeight:(CGFloat)maximumLineHeight {
    [self h_setMaximumLineHeight:maximumLineHeight range:NSMakeRange(0, self.length)];
}

- (void)setH_lineHeightMultiple:(CGFloat)lineHeightMultiple {
    [self h_setLineHeightMultiple:lineHeightMultiple range:NSMakeRange(0, self.length)];
}

- (void)setH_hyphenationFactor:(float)hyphenationFactor {
    [self h_setHyphenationFactor:hyphenationFactor range:NSMakeRange(0, self.length)];
}

- (void)setH_defaultTabInterval:(CGFloat)defaultTabInterval {
    [self h_setDefaultTabInterval:defaultTabInterval range:NSMakeRange(0, self.length)];
}

- (void)setH_tabStops:(NSArray *)tabStops {
    [self h_setTabStops:tabStops range:NSMakeRange(0, self.length)];
}

- (void)setH_textShadow:(HTextShadow *)textShadow {
    [self h_setTextShadow:textShadow range:NSMakeRange(0, self.length)];
}

- (void)setH_textInnerShadow:(HTextShadow *)textInnerShadow {
    [self h_setTextInnerShadow:textInnerShadow range:NSMakeRange(0, self.length)];
}

- (void)setH_textUnderline:(HTextDecoration *)textUnderline {
    [self h_setTextUnderline:textUnderline range:NSMakeRange(0, self.length)];
}

- (void)setH_textStrikethrough:(HTextDecoration *)textStrikethrough {
    [self h_setTextStrikethrough:textStrikethrough range:NSMakeRange(0, self.length)];
}

- (void)setH_textBorder:(HTextBorder *)textBorder {
    [self h_setTextBorder:textBorder range:NSMakeRange(0, self.length)];
}

- (void)setH_textBackgroundBorder:(HTextBorder *)textBackgroundBorder {
    [self h_setTextBackgroundBorder:textBackgroundBorder range:NSMakeRange(0, self.length)];
}

- (void)setH_textGlyphTransform:(CGAffineTransform)textGlyphTransform {
    [self h_setTextGlyphTransform:textGlyphTransform range:NSMakeRange(0, self.length)];
}

#pragma mark - Range Setter

- (void)h_setFont:(UIFont *)font range:(NSRange)range {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    [self h_setAttribute:NSFontAttributeName value:font range:range];
}

- (void)h_setKern:(NSNumber *)kern range:(NSRange)range {
    [self h_setAttribute:NSKernAttributeName value:kern range:range];
}

- (void)h_setColor:(UIColor *)color range:(NSRange)range {
    [self h_setAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
    [self h_setAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)h_setBackgroundColor:(UIColor *)backgroundColor range:(NSRange)range {
    [self h_setAttribute:NSBackgroundColorAttributeName value:backgroundColor range:range];
}

- (void)h_setStrokeWidth:(NSNumber *)strokeWidth range:(NSRange)range {
    [self h_setAttribute:NSStrokeWidthAttributeName value:strokeWidth range:range];
}

- (void)h_setStrokeColor:(UIColor *)strokeColor range:(NSRange)range {
    [self h_setAttribute:(id)kCTStrokeColorAttributeName value:(id)strokeColor.CGColor range:range];
    [self h_setAttribute:NSStrokeColorAttributeName value:strokeColor range:range];
}

- (void)h_setShadow:(NSShadow *)shadow range:(NSRange)range {
    [self h_setAttribute:NSShadowAttributeName value:shadow range:range];
}

- (void)h_setStrikethroughStyle:(NSUnderlineStyle)strikethroughStyle range:(NSRange)range {
    NSNumber *style = strikethroughStyle == 0 ? nil : @(strikethroughStyle);
    [self h_setAttribute:NSStrikethroughStyleAttributeName value:style range:range];
}

- (void)h_setStrikethroughColor:(UIColor *)strikethroughColor range:(NSRange)range {
    if (kHSystemVersion >= 7) {
        [self h_setAttribute:NSStrikethroughColorAttributeName value:strikethroughColor range:range];
    }
}

- (void)h_setUnderlineStyle:(NSUnderlineStyle)underlineStyle range:(NSRange)range {
    NSNumber *style = underlineStyle == 0 ? nil : @(underlineStyle);
    [self h_setAttribute:NSUnderlineStyleAttributeName value:style range:range];
}

- (void)h_setUnderlineColor:(UIColor *)underlineColor range:(NSRange)range {
    [self h_setAttribute:(id)kCTUnderlineColorAttributeName value:(id)underlineColor.CGColor range:range];
    if (kHSystemVersion >= 7) {
        [self h_setAttribute:NSUnderlineColorAttributeName value:underlineColor range:range];
    }
}

- (void)h_setLigature:(NSNumber *)ligature range:(NSRange)range {
    [self h_setAttribute:NSLigatureAttributeName value:ligature range:range];
}

- (void)h_setTextEffect:(NSString *)textEffect range:(NSRange)range {
    if (kHSystemVersion >= 7) {
        [self h_setAttribute:NSTextEffectAttributeName value:textEffect range:range];
    }
}

- (void)h_setObliqueness:(NSNumber *)obliqueness range:(NSRange)range {
    if (kHSystemVersion >= 7) {
        [self h_setAttribute:NSObliquenessAttributeName value:obliqueness range:range];
    }
}

- (void)h_setExpansion:(NSNumber *)expansion range:(NSRange)range {
    if (kHSystemVersion >= 7) {
        [self h_setAttribute:NSExpansionAttributeName value:expansion range:range];
    }
}

- (void)h_setBaselineOffset:(NSNumber *)baselineOffset range:(NSRange)range {
    if (kHSystemVersion >= 7) {
        [self h_setAttribute:NSBaselineOffsetAttributeName value:baselineOffset range:range];
    }
}

- (void)h_setVerticalGlyphForm:(BOOL)verticalGlyphForm range:(NSRange)range {
    NSNumber *v = verticalGlyphForm ? @(YES) : nil;
    [self h_setAttribute:NSVerticalGlyphFormAttributeName value:v range:range];
}

- (void)h_setLanguage:(NSString *)language range:(NSRange)range {
    if (kHSystemVersion >= 7) {
        [self h_setAttribute:(id)kCTLanguageAttributeName value:language range:range];
    }
}

- (void)h_setWritingDirection:(NSArray *)writingDirection range:(NSRange)range {
    [self h_setAttribute:(id)kCTWritingDirectionAttributeName value:writingDirection range:range];
}

- (void)h_setParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range {
    /*
     NSParagraphStyle is NOT toll-free bridged to CTParagraphStyleRef.
     
     CoreText can use both NSParagraphStyle and CTParagraphStyleRef,
     but UILabel/UITextView can only use NSParagraphStyle.
     
     We use NSParagraphStyle in both CoreText and UIKit.
     */
    [self h_setAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

#define HParagraphStyleSet(_attr_) \
[self enumerateAttribute:NSParagraphStyleAttributeName \
                 inRange:range \
                 options:kNilOptions \
              usingBlock: ^(NSParagraphStyle *value, NSRange subRange, BOOL *stop) { \
                  NSMutableParagraphStyle *style = nil; \
                  if (value) { \
                      if (CFGetTypeID((__bridge CFTypeRef)(value)) == CTParagraphStyleGetTypeID()) { \
                          value = [NSParagraphStyle h_styleWithCTStyle:(__bridge CTParagraphStyleRef)(value)]; \
                      } \
                      if (value. _attr_ == _attr_) return; \
                      if ([value isKindOfClass:[NSMutableParagraphStyle class]]) { \
                          style = (id)value; \
                      } else { \
                          style = value.mutableCopy; \
                      } \
                  } else { \
                      if ([NSParagraphStyle defaultParagraphStyle]. _attr_ == _attr_) return; \
                      style = [NSParagraphStyle defaultParagraphStyle].mutableCopy; \
                  } \
                  style. _attr_ = _attr_; \
                  [self h_setParagraphStyle:style range:subRange]; \
              }];

- (void)h_setAlignment:(NSTextAlignment)alignment range:(NSRange)range {
    HParagraphStyleSet(alignment);
}

- (void)h_setBaseWritingDirection:(NSWritingDirection)baseWritingDirection range:(NSRange)range {
    HParagraphStyleSet(baseWritingDirection);
}

- (void)h_setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range {
    HParagraphStyleSet(lineSpacing);
}

- (void)h_setParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range {
    HParagraphStyleSet(paragraphSpacing);
}

- (void)h_setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore range:(NSRange)range {
    HParagraphStyleSet(paragraphSpacingBefore);
}

- (void)h_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range {
    HParagraphStyleSet(firstLineHeadIndent);
}

- (void)h_setHeadIndent:(CGFloat)headIndent range:(NSRange)range {
    HParagraphStyleSet(headIndent);
}

- (void)h_setTailIndent:(CGFloat)tailIndent range:(NSRange)range {
    HParagraphStyleSet(tailIndent);
}

- (void)h_setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range {
    HParagraphStyleSet(lineBreakMode);
}

- (void)h_setMinimumLineHeight:(CGFloat)minimumLineHeight range:(NSRange)range {
    HParagraphStyleSet(minimumLineHeight);
}

- (void)h_setMaximumLineHeight:(CGFloat)maximumLineHeight range:(NSRange)range {
    HParagraphStyleSet(maximumLineHeight);
}

- (void)h_setLineHeightMultiple:(CGFloat)lineHeightMultiple range:(NSRange)range {
    HParagraphStyleSet(lineHeightMultiple);
}

- (void)h_setHyphenationFactor:(float)hyphenationFactor range:(NSRange)range {
    HParagraphStyleSet(hyphenationFactor);
}

- (void)h_setDefaultTabInterval:(CGFloat)defaultTabInterval range:(NSRange)range {
    if (!kHiOS7Later) return;
    HParagraphStyleSet(defaultTabInterval);
}

- (void)h_setTabStops:(NSArray *)tabStops range:(NSRange)range {
    if (!kHiOS7Later) return;
    HParagraphStyleSet(tabStops);
}

#undef HParagraphStyleSet

- (void)h_setSuperscript:(NSNumber *)superscript range:(NSRange)range {
    if ([superscript isEqualToNumber:@(0)]) {
        superscript = nil;
    }
    [self h_setAttribute:(id)kCTSuperscriptAttributeName value:superscript range:range];
}

- (void)h_setGlyphInfo:(CTGlyphInfoRef)glyphInfo range:(NSRange)range {
    [self h_setAttribute:(id)kCTGlyphInfoAttributeName value:(__bridge id)glyphInfo range:range];
}

- (void)h_setCharacterShape:(NSNumber *)characterShape range:(NSRange)range {
    [self h_setAttribute:(id)kCTCharacterShapeAttributeName value:characterShape range:range];
}

- (void)h_setRunDelegate:(CTRunDelegateRef)runDelegate range:(NSRange)range {
    [self h_setAttribute:(id)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:range];
}

- (void)h_setBaselineClass:(CFStringRef)baselineClass range:(NSRange)range {
    [self h_setAttribute:(id)kCTBaselineClassAttributeName value:(__bridge id)baselineClass range:range];
}

- (void)h_setBaselineInfo:(CFDictionaryRef)baselineInfo range:(NSRange)range {
    [self h_setAttribute:(id)kCTBaselineInfoAttributeName value:(__bridge id)baselineInfo range:range];
}

- (void)h_setBaselineReferenceInfo:(CFDictionaryRef)referenceInfo range:(NSRange)range {
    [self h_setAttribute:(id)kCTBaselineReferenceInfoAttributeName value:(__bridge id)referenceInfo range:range];
}

- (void)h_setRubyAnnotation:(CTRubyAnnotationRef)ruby range:(NSRange)range {
    if (kHSystemVersion >= 8) {
        [self h_setAttribute:(id)kCTRubyAnnotationAttributeName value:(__bridge id)ruby range:range];
    }
}

- (void)h_setAttachment:(NSTextAttachment *)attachment range:(NSRange)range {
    if (kHSystemVersion >= 7) {
        [self h_setAttribute:NSAttachmentAttributeName value:attachment range:range];
    }
}

- (void)h_setLink:(id)link range:(NSRange)range {
    if (kHSystemVersion >= 7) {
        [self h_setAttribute:NSLinkAttributeName value:link range:range];
    }
}

- (void)h_setTextBackedString:(HTextBackedString *)textBackedString range:(NSRange)range {
    [self h_setAttribute:HTextBackedStringAttributeName value:textBackedString range:range];
}

- (void)h_setTextBinding:(HTextBinding *)textBinding range:(NSRange)range {
    [self h_setAttribute:HTextBindingAttributeName value:textBinding range:range];
}

- (void)h_setTextShadow:(HTextShadow *)textShadow range:(NSRange)range {
    [self h_setAttribute:HTextShadowAttributeName value:textShadow range:range];
}

- (void)h_setTextInnerShadow:(HTextShadow *)textInnerShadow range:(NSRange)range {
    [self h_setAttribute:HTextInnerShadowAttributeName value:textInnerShadow range:range];
}

- (void)h_setTextUnderline:(HTextDecoration *)textUnderline range:(NSRange)range {
    [self h_setAttribute:HTextUnderlineAttributeName value:textUnderline range:range];
}

- (void)h_setTextStrikethrough:(HTextDecoration *)textStrikethrough range:(NSRange)range {
    [self h_setAttribute:HTextStrikethroughAttributeName value:textStrikethrough range:range];
}

- (void)h_setTextBorder:(HTextBorder *)textBorder range:(NSRange)range {
    [self h_setAttribute:HTextBorderAttributeName value:textBorder range:range];
}

- (void)h_setTextBackgroundBorder:(HTextBorder *)textBackgroundBorder range:(NSRange)range {
    [self h_setAttribute:HTextBackgroundBorderAttributeName value:textBackgroundBorder range:range];
}

- (void)h_setTextAttachment:(HTextAttachment *)textAttachment range:(NSRange)range {
    [self h_setAttribute:HTextAttachmentAttributeName value:textAttachment range:range];
}

- (void)h_setTextHighlight:(HTextHighlight *)textHighlight range:(NSRange)range {
    [self h_setAttribute:HTextHighlightAttributeName value:textHighlight range:range];
}

- (void)h_setTextBlockBorder:(HTextBorder *)textBlockBorder range:(NSRange)range {
    [self h_setAttribute:HTextBlockBorderAttributeName value:textBlockBorder range:range];
}

- (void)h_setTextRubyAnnotation:(HTextRubyAnnotation *)ruby range:(NSRange)range {
    if (kHiOS8Later) {
        CTRubyAnnotationRef rubyRef = [ruby CTRubyAnnotation];
        [self h_setRubyAnnotation:rubyRef range:range];
        if (rubyRef) CFRelease(rubyRef);
    }
}

- (void)h_setTextGlyphTransform:(CGAffineTransform)textGlyphTransform range:(NSRange)range {
    NSValue *value = CGAffineTransformIsIdentity(textGlyphTransform) ? nil : [NSValue valueWithCGAffineTransform:textGlyphTransform];
    [self h_setAttribute:HTextGlyphTransformAttributeName value:value range:range];
}

- (void)h_setTextHighlightRange:(NSRange)range
                           color:(UIColor *)color
                 backgroundColor:(UIColor *)backgroundColor
                        userInfo:(NSDictionary *)userInfo
                       tapAction:(HTextAction)tapAction
                 longPressAction:(HTextAction)longPressAction {
    HTextHighlight *highlight = [HTextHighlight highlightWithBackgroundColor:backgroundColor];
    highlight.userInfo = userInfo;
    highlight.tapAction = tapAction;
    highlight.longPressAction = longPressAction;
    if (color) [self h_setColor:color range:range];
    [self h_setTextHighlight:highlight range:range];
}

- (void)h_setTextHighlightRange:(NSRange)range
                           color:(UIColor *)color
                 backgroundColor:(UIColor *)backgroundColor
                       tapAction:(HTextAction)tapAction {
    [self h_setTextHighlightRange:range
                         color:color
               backgroundColor:backgroundColor
                      userInfo:nil
                     tapAction:tapAction
               longPressAction:nil];
}

- (void)h_setTextHighlightRange:(NSRange)range
                           color:(UIColor *)color
                 backgroundColor:(UIColor *)backgroundColor
                        userInfo:(NSDictionary *)userInfo {
    [self h_setTextHighlightRange:range
                         color:color
               backgroundColor:backgroundColor
                      userInfo:userInfo
                     tapAction:nil
               longPressAction:nil];
}

- (void)h_insertString:(NSString *)string atIndex:(NSUInteger)location {
    [self replaceCharactersInRange:NSMakeRange(location, 0) withString:string];
    [self h_removeDiscontinuousAttributesInRange:NSMakeRange(location, string.length)];
}

- (void)h_appendString:(NSString *)string {
    NSUInteger length = self.length;
    [self replaceCharactersInRange:NSMakeRange(length, 0) withString:string];
    [self h_removeDiscontinuousAttributesInRange:NSMakeRange(length, string.length)];
}

- (void)h_setClearColorToJoinedEmoji {
    NSString *str = self.string;
    if (str.length < 8) return;
    
    // Most string do not contains the joined-emoji, test the joiner first.
    BOOL containsJoiner = NO;
    {
        CFStringRef cfStr = (__bridge CFStringRef)str;
        BOOL needFree = NO;
        UniChar *chars = NULL;
        chars = (void *)CFStringGetCharactersPtr(cfStr);
        if (!chars) {
            chars = malloc(str.length * sizeof(UniChar));
            if (chars) {
                needFree = YES;
                CFStringGetCharacters(cfStr, CFRangeMake(0, str.length), chars);
            }
        }
        if (!chars) { // fail to get unichar..
            containsJoiner = YES;
        } else {
            for (int i = 0, max = (int)str.length; i < max; i++) {
                if (chars[i] == 0x200D) { // 'ZERO WIDTH JOINER' (U+200D)
                    containsJoiner = YES;
                    break;
                }
            }
            if (needFree) free(chars);
        }
    }
    if (!containsJoiner) return;
    
    // NSRegularExpression is designed to be immutable and thread safe.
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"((👨‍👩‍👧‍👦|👨‍👩‍👦‍👦|👨‍👩‍👧‍👧|👩‍👩‍👧‍👦|👩‍👩‍👦‍👦|👩‍👩‍👧‍👧|👨‍👨‍👧‍👦|👨‍👨‍👦‍👦|👨‍👨‍👧‍👧)+|(👨‍👩‍👧|👩‍👩‍👦|👩‍👩‍👧|👨‍👨‍👦|👨‍👨‍👧))" options:kNilOptions error:nil];
    });
    
    UIColor *clear = [UIColor clearColor];
    [regex enumerateMatchesInString:str options:kNilOptions range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [self h_setColor:clear range:result.range];
    }];
}

- (void)h_removeDiscontinuousAttributesInRange:(NSRange)range {
    NSArray *keys = [NSMutableAttributedString h_allDiscontinuousAttributeKeys];
    for (NSString *key in keys) {
        [self removeAttribute:key range:range];
    }
}

+ (NSArray *)h_allDiscontinuousAttributeKeys {
    static NSMutableArray *keys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keys = @[(id)kCTSuperscriptAttributeName,
                 (id)kCTRunDelegateAttributeName,
                 HTextBackedStringAttributeName,
                 HTextBindingAttributeName,
                 HTextAttachmentAttributeName].mutableCopy;
        if (kHiOS8Later) {
            [keys addObject:(id)kCTRubyAnnotationAttributeName];
        }
        if (kHiOS7Later) {
            [keys addObject:NSAttachmentAttributeName];
        }
    });
    return keys;
}

@end
