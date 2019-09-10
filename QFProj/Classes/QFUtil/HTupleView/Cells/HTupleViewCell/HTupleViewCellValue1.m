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
