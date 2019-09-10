//
//  HTupleViewCellDefault.m
//  QFProj
//
//  Created by wind on 2019/9/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCellDefault.h"

@implementation HTupleViewCellDefault
@dynamic label;
- (void)frameChanged {
    CGRect frame = [self getContentBounds];
    [self.label setFrame:frame];
}
@end

@implementation HTupleViewCellDefault2
@dynamic imageView, label;
- (void)frameChanged {
    CGRect frame = [self getContentBounds];
    
    CGRect tmpFrame = frame;
    tmpFrame.size.width = CGRectGetHeight(tmpFrame);
    [self.imageView setFrame:tmpFrame];
    
    CGRect tmpFrame2 = frame;
    tmpFrame2.origin.x += CGRectGetMaxX(tmpFrame)+10;
    tmpFrame2.size.width = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame)-10;
    tmpFrame2.size.height = CGRectGetHeight(tmpFrame);
    [self.label setFrame:tmpFrame2];
}
@end

@implementation HTupleViewCellDefault3
@dynamic imageView, label, accessoryView;
- (void)frameChanged {
    CGRect frame = [self getContentBounds];
    
    CGRect tmpFrame = frame;
    tmpFrame.size.width = CGRectGetHeight(tmpFrame);
    [self.imageView setFrame:tmpFrame];
    
    CGRect tmpFrame2 = CGRectMake(0, 0, 10, 18);
    tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
    tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
    [self.accessoryView setFrame:tmpFrame2];
    [self.accessoryView setImageWithName:@"icon_tuple_arrow_right"];
    
    CGRect tmpFrame3 = frame;
    tmpFrame3.origin.x += CGRectGetMaxX(tmpFrame)+10;
    tmpFrame3.size.width = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame)-10-10;
    tmpFrame3.size.height = CGRectGetHeight(tmpFrame);
    [self.label setFrame:tmpFrame3];
}
@end

@implementation HTupleViewCellDefault4
@dynamic imageView, label;
@dynamic detailView, accessoryView;
- (void)frameChanged {
    CGRect frame = [self getContentBounds];
    
    CGRect tmpFrame = frame;
    tmpFrame.size.width = CGRectGetHeight(tmpFrame);
    [self.imageView setFrame:tmpFrame];
    
    CGRect tmpFrame2 = CGRectMake(0, 0, 10, 18);
    tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
    tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
    [self.accessoryView setFrame:tmpFrame2];
    [self.accessoryView setImageWithName:@"icon_tuple_arrow_right"];
    
    CGRect tmpFrame3 = tmpFrame;
    tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3)-10;
    [self.detailView setFrame:tmpFrame3];
    
    CGRect tmpFrame4 = frame;
    tmpFrame4.origin.x += CGRectGetMaxX(tmpFrame)+10;
    tmpFrame4.size.width = CGRectGetMinX(tmpFrame3)-CGRectGetWidth(tmpFrame)-10-10;
    tmpFrame4.size.height = CGRectGetHeight(tmpFrame);
    [self.label setFrame:tmpFrame4];
}
@end
