//
//  HRichLabelContainer.m
//  HRichLabel
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HRichLabelContainer.h"

@implementation HRichLabelContainer

#pragma mark - public
+ (instancetype)container {
    return [[self alloc] init];
}

#pragma mark - properties

- (CGRect)innerRect {
    CGRect rect = (CGRect){CGPointZero, _size};
    return UIEdgeInsetsInsetRect(rect, _insets);
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    switch (lineBreakMode) {
        
        case NSLineBreakByWordWrapping:
        case NSLineBreakByCharWrapping:
        case NSLineBreakByClipping:
            _lineBreakMode = lineBreakMode;
            break;
        case NSLineBreakByTruncatingHead:
        case NSLineBreakByTruncatingMiddle:
        case NSLineBreakByTruncatingTail:
        default:
            _lineBreakMode = NSLineBreakByTruncatingTail;
            break;
    }
}

@end
