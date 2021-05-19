//
//  HRect.m
//  QFProj
//
//  Created by Wind on 2021/5/19.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HRect.h"

@interface HRect ()
@property (nonatomic) CGRect _rect1;
@property (nonatomic) CGRect _rect2;
@end

@implementation HRect

- (instancetype)init {
    self = [super init];
    if (self) {
        __rect1 = CGRectZero;
        __rect2 = CGRectZero;
    }
    return self;
}

- (HRect *)rect1 {
    HRect *hRect = HRect.new;
    hRect._rect1 = self._rect1;
    return hRect;
}

- (HRect *)rect2 {
    HRect *hRect = HRect.new;
    hRect._rect1 = self._rect2;
    return hRect;
}

HRect *HRectFor(CGRect rect) {
    HRect *hRect = HRect.new;
    hRect._rect1 = rect;
    return hRect;
}

HRect *HRect2For(CGRect rect1, CGRect rect2) {
    HRect *hRect = HRect.new;
    hRect._rect1 = rect1;
    hRect._rect2 = rect2;
    return hRect;
}

- (CGRect)makeRect:(void(^)(HRect *make))block {
    if (block) block(self);
    return self._rect1;
}

- (CGRect)makeRect2:(void(^)(HRect *make1, HRect *make2))block {
    if (block) block(self.rect1, self.rect2);
    return self._rect1;
}

#pragma mark - Frame
#pragma mark -

- (CGFloat)x {
    return self._rect1.origin.x;
}
- (void)setX:(CGFloat)x {
    CGRect frame = self._rect1;
    frame.origin.x = x;
    self._rect1 = frame;
}

- (CGFloat)y {
    return self._rect1.origin.y;
}
- (void)setY:(CGFloat)y {
    CGRect frame = self._rect1;
    frame.origin.y = y;
    self._rect1 = frame;
}

- (CGFloat)width {
    return self._rect1.size.width;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self._rect1;
    frame.size.width = width;
    self._rect1 = frame;
}

- (CGFloat)height {
    return self._rect1.size.height;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self._rect1;
    frame.size.height = height;
    self._rect1 = frame;
}



- (CGPoint)origin {
    return self._rect1.origin;
}
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self._rect1;
    frame.origin = origin;
    self._rect1 = frame;
}

- (CGSize)size {
    return self._rect1.size;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self._rect1;
    frame.size = size;
    self._rect1 = frame;
}



- (CGFloat)minX {
    return CGRectGetMinX(self._rect1);
}
- (CGFloat)minY {
    return CGRectGetMinY(self._rect1);
}

- (CGFloat)midX {
    return CGRectGetMidX(self._rect1);
}
- (CGFloat)midY {
    return CGRectGetMidY(self._rect1);
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self._rect1);
}
- (CGFloat)maxY {
    return CGRectGetMaxY(self._rect1);
}

@end
