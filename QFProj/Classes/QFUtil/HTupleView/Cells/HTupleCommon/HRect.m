//
//  HRect.m
//  QFProj
//
//  Created by Wind on 2021/5/20.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HRect.h"

@implementation HRect

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectZero;
    }
    return self;
}

- (CGFloat)x {
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}



- (CGPoint)origin {
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}



- (CGFloat)minX {
    return CGRectGetMinX(self.frame);
}
- (CGFloat)minY {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)midX {
    return CGRectGetMidX(self.frame);
}
- (CGFloat)midY {
    return CGRectGetMidY(self.frame);
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}


HRect *HRectFor(CGRect rect) {
    HRect *hRect = HRect.new;
    hRect.frame = rect;
    return hRect;
}

CGRect CGBoundsFor(CGRect rect) {
    CGRect frame = rect;
    frame.origin = CGPointZero;
    return frame;
}

CGRect HBoundsFor(HRect *rect) {
    CGRect frame = rect.frame;
    frame.origin = CGPointZero;
    return frame;
}

@end
