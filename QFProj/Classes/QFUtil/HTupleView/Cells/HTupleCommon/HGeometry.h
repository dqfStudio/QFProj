//
//  HGeometry.h
//  QFProj
//
//  Created by dqf on 2019/9/18.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#ifndef HGeometry_h
#define HGeometry_h

typedef struct UITBEdgeInsets {
    CGFloat top, bottom;
} UITBEdgeInsets;

typedef struct UILREdgeInsets {
    CGFloat left, right;
} UILREdgeInsets;

static UITBEdgeInsets UITBEdgeInsetsZero = {0, 0};
static UILREdgeInsets UILREdgeInsetsZero = {0, 0};

UIKIT_STATIC_INLINE UITBEdgeInsets UITBEdgeInsetsMake(CGFloat top, CGFloat bottom) {
    return (UITBEdgeInsets){top, bottom};
}

UIKIT_STATIC_INLINE UILREdgeInsets UILREdgeInsetsMake(CGFloat left, CGFloat right) {
    return (UILREdgeInsets){left, right};
}

UIKIT_STATIC_INLINE BOOL UITBEdgeInsetsEqualToEdgeInsets(UITBEdgeInsets insets1, UITBEdgeInsets insets2) {
    return insets1.top == insets2.top && insets1.bottom == insets2.bottom;
}

UIKIT_STATIC_INLINE BOOL UILREdgeInsetsEqualToEdgeInsets(UILREdgeInsets insets1, UILREdgeInsets insets2) {
    return insets1.left == insets2.left && insets1.right == insets2.right;
}

UIKIT_STATIC_INLINE CGRect UIRectIntegral(CGRect rect) {
    CGFloat x = floor(rect.origin.x);
    CGFloat y = floor(rect.origin.y);
    CGFloat width = floor(rect.origin.x + rect.size.width - x);
    CGFloat height = floor(rect.origin.y + rect.size.height - y);
    return (CGRect){x, y, width, height};
}

UIKIT_STATIC_INLINE CGSize UISizeIntegral(CGSize size) {
    return (CGSize){floor(size.width), floor(size.height)};
}

#endif /* HGeometry_h */
