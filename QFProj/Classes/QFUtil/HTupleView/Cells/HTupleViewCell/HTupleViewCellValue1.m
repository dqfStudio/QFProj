//
//  HTupleViewCellValue1.m
//  QFProj
//
//  Created by wind on 2019/9/10.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCellValue1.h"

@implementation HTupleViewCellValue1
@dynamic label, detailLabel, accessoryLabel;
- (void)frameChanged {
    CGRect frame = [self getContentBounds];
    
    if (self.leftWidth > 0) {
        CGRect tmpFrame = frame;
        tmpFrame.size.width = self.leftWidth;
        [self.label setFrame:tmpFrame];
    }
    
    if (self.rightWidth > 0) {
        CGRect tmpFrame = frame;
        tmpFrame.origin.x = CGRectGetWidth(frame)-self.rightWidth;
        tmpFrame.size.width = self.rightWidth;
        [self.accessoryLabel setFrame:tmpFrame];
    }
    
    CGRect tmpFrame = frame;
    tmpFrame.origin.x = self.leftWidth;
    tmpFrame.size.width = CGRectGetWidth(frame)-self.leftWidth-self.rightWidth;
    [self.detailLabel setFrame:tmpFrame];
}
- (void)setLeftWidth:(CGFloat)leftWidth {
    if (_leftWidth != leftWidth) {
        _leftWidth = leftWidth;
        [self frameChanged];
    }
}
- (void)setRightWidth:(CGFloat)rightWidth {
    if (_rightWidth != rightWidth) {
        _rightWidth = rightWidth;
        [self frameChanged];
    }
}
@end

@implementation HTupleViewCellValue2
@dynamic imageView, label;
@dynamic detailLabel, accessoryLabel;
- (void)frameChanged {
    CGRect frame = [self getContentBounds];
    
    CGRect tmpFrame = frame;
    tmpFrame.size.width = CGRectGetHeight(tmpFrame);
    [self.imageView setFrame:tmpFrame];
    
    if (self.leftWidth > 0) {
        CGRect tmpFrame2 = frame;
        tmpFrame.origin.x = CGRectGetMaxX(tmpFrame)+10;
        tmpFrame2.size.width = self.leftWidth;
        [self.label setFrame:tmpFrame2];
    }
    
    if (self.rightWidth > 0) {
        CGRect tmpFrame3 = frame;
        tmpFrame3.origin.x = CGRectGetWidth(frame)-self.rightWidth;
        tmpFrame3.size.width = self.rightWidth;
        [self.accessoryLabel setFrame:tmpFrame3];
    }
    
    CGRect tmpFrame4 = frame;
    if (self.leftWidth > 0) {
        tmpFrame4.origin.x += CGRectGetMaxX(tmpFrame)+10;
    }
    tmpFrame4.origin.x += self.leftWidth;
    tmpFrame4.size.width = CGRectGetWidth(frame)-self.leftWidth-self.rightWidth;
    [self.detailLabel setFrame:tmpFrame4];
}
- (void)setLeftWidth:(CGFloat)leftWidth {
    if (_leftWidth != leftWidth) {
        _leftWidth = leftWidth;
        [self frameChanged];
    }
}
- (void)setRightWidth:(CGFloat)rightWidth {
    if (_rightWidth != rightWidth) {
        _rightWidth = rightWidth;
        [self frameChanged];
    }
}
@end

@implementation HTupleViewCellValue3
@dynamic label, detailLabel, accessoryLabel;
- (void)frameChanged {
    CGRect frame = [self getContentBounds];
    
    if (self.leftWidth > 0) {
        CGRect tmpFrame = frame;
        tmpFrame.size.width = self.leftWidth;
        [self.label setFrame:tmpFrame];
    }
    
    if (self.rightWidth > 0) {
        CGRect tmpFrame = frame;
        tmpFrame.origin.x = CGRectGetWidth(frame)-self.rightWidth;
        tmpFrame.size.width = self.rightWidth;
        [self.accessoryLabel setFrame:tmpFrame];
    }
    
    CGRect tmpFrame = frame;
    tmpFrame.origin.x = self.leftWidth;
    tmpFrame.size.width = CGRectGetWidth(frame)-self.leftWidth-self.rightWidth;
    [self.detailLabel setFrame:tmpFrame];
}
- (void)setLeftWidth:(CGFloat)leftWidth {
    if (_leftWidth != leftWidth) {
        _leftWidth = leftWidth;
        [self frameChanged];
    }
}
- (void)setRightWidth:(CGFloat)rightWidth {
    if (_rightWidth != rightWidth) {
        _rightWidth = rightWidth;
        [self frameChanged];
    }
}
@end

@implementation HTupleViewCellValue4
@dynamic label, detailLabel, accessoryLabel;
- (void)frameChanged {
    CGRect frame = [self getContentBounds];
    
    if (self.leftWidth > 0) {
        CGRect tmpFrame = frame;
        tmpFrame.size.width = self.leftWidth;
        [self.label setFrame:tmpFrame];
    }
    
    if (self.rightWidth > 0) {
        CGRect tmpFrame = frame;
        tmpFrame.origin.x = CGRectGetWidth(frame)-self.rightWidth;
        tmpFrame.size.width = self.rightWidth;
        [self.accessoryLabel setFrame:tmpFrame];
    }
    
    CGRect tmpFrame = frame;
    tmpFrame.origin.x = self.leftWidth;
    tmpFrame.size.width = CGRectGetWidth(frame)-self.leftWidth-self.rightWidth;
    [self.detailLabel setFrame:tmpFrame];
}
- (void)setLeftWidth:(CGFloat)leftWidth {
    if (_leftWidth != leftWidth) {
        _leftWidth = leftWidth;
        [self frameChanged];
    }
}
- (void)setRightWidth:(CGFloat)rightWidth {
    if (_rightWidth != rightWidth) {
        _rightWidth = rightWidth;
        [self frameChanged];
    }
}
@end
