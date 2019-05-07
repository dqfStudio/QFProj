//
//  UIPasteboard+HText.m
//
//  Created by ibireme on 15/4/2.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIPasteboard+HText.h"
#import "NSAttributedString+HText.h"
#import <MobileCoreServices/MobileCoreServices.h>


#if __has_include("HImage.h")
#import "HImage.h"
#define HTextAnimatedImageAvailable 1
#elif __has_include(<HImage/HImage.h>)
#import <HImage/HImage.h>
#define HTextAnimatedImageAvailable 1
#elif __has_include(<HWebImage/HImage.h>)
#import <HWebImage/HImage.h>
#define HTextAnimatedImageAvailable 1
#else
#define HTextAnimatedImageAvailable 0
#endif


// Dummy class for category
@interface UIPasteboard_HText : NSObject @end
@implementation UIPasteboard_HText @end


NSString *const HTextPasteboardTypeAttributedString = @"com.ibireme.NSAttributedString";
NSString *const HTextUTTypeWEBP = @"com.google.webp";

@implementation UIPasteboard (HText)


- (void)setH_PNGData:(NSData *)PNGData {
    [self setData:PNGData forPasteboardType:(id)kUTTypePNG];
}

- (NSData *)h_PNGData {
    return [self dataForPasteboardType:(id)kUTTypePNG];
}

- (void)setH_JPEGData:(NSData *)JPEGData {
    [self setData:JPEGData forPasteboardType:(id)kUTTypeJPEG];
}

- (NSData *)h_JPEGData {
    return [self dataForPasteboardType:(id)kUTTypeJPEG];
}

- (void)setH_GIFData:(NSData *)GIFData {
    [self setData:GIFData forPasteboardType:(id)kUTTypeGIF];
}

- (NSData *)h_GIFData {
    return [self dataForPasteboardType:(id)kUTTypeGIF];
}

- (void)setH_WEBPData:(NSData *)WEBPData {
    [self setData:WEBPData forPasteboardType:HTextUTTypeWEBP];
}

- (NSData *)h_WEBPData {
    return [self dataForPasteboardType:HTextUTTypeWEBP];
}

- (void)setH_ImageData:(NSData *)imageData {
    [self setData:imageData forPasteboardType:(id)kUTTypeImage];
}

- (NSData *)h_ImageData {
    return [self dataForPasteboardType:(id)kUTTypeImage];
}

- (void)setH_AttributedString:(NSAttributedString *)attributedString {
    self.string = [attributedString h_plainTextForRange:NSMakeRange(0, attributedString.length)];
    NSData *data = [attributedString h_archiveToData];
    if (data) {
        NSDictionary *item = @{HTextPasteboardTypeAttributedString : data};
        [self addItems:@[item]];
    }
    [attributedString enumerateAttribute:HTextAttachmentAttributeName inRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(HTextAttachment *attachment, NSRange range, BOOL *stop) {
        
        // save image
        UIImage *simpleImage = nil;
        if ([attachment.content isKindOfClass:[UIImage class]]) {
            simpleImage = attachment.content;
        } else if ([attachment.content isKindOfClass:[UIImageView class]]) {
            simpleImage = ((UIImageView *)attachment.content).image;
        }
        if (simpleImage) {
            NSDictionary *item = @{@"com.apple.uikit.image" : simpleImage};
            [self addItems:@[item]];
        }
        
#if HTextAnimatedImageAvailable
        // save animated image
        if ([attachment.content isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = attachment.content;
            Class aniImageClass = NSClassFromString(@"HImage");
            UIImage *image = imageView.image;
            if (aniImageClass && [image isKindOfClass:aniImageClass]) {
                NSData *data = [image valueForKey:@"animatedImageData"];
                NSNumber *type = [image valueForKey:@"animatedImageType"];
                if (data) {
                    switch (type.unsignedIntegerValue) {
                        case HImageTypeGIF: {
                            NSDictionary *item = @{(id)kUTTypeGIF : data};
                            [self addItems:@[item]];
                        } break;
                        case HImageTypePNG: { // APNG
                            NSDictionary *item = @{(id)kUTTypePNG : data};
                            [self addItems:@[item]];
                        } break;
                        case HImageTypeWebP: {
                            NSDictionary *item = @{(id)HTextUTTypeWEBP : data};
                            [self addItems:@[item]];
                        } break;
                        default: break;
                    }
                }
            }
        }
#endif
        
    }];
}

- (NSAttributedString *)h_AttributedString {
    for (NSDictionary *items in self.items) {
        NSData *data = items[HTextPasteboardTypeAttributedString];
        if (data) {
            return [NSAttributedString h_unarchiveFromData:data];
        }
    }
    return nil;
}

@end
