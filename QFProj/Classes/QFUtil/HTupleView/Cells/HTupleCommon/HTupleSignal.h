//
//  HTupleSignal.h
//  QFProj
//
//  Created by dqf on 2018/5/23.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define KTupleSkinNotify @"tupleSkinNotify"

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

@class HTupleSignal;

typedef void(^HTupleCellInitBlock)(id target);
typedef void(^HTupleCellSignalBlock)(id target, HTupleSignal *signal);

@interface HTupleSignal : NSObject
@property (nonatomic) id signal;
@property (nonatomic) NSInteger tag;
@property (nonatomic) NSString *name;
@end
