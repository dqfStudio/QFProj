//
//  HTupleViewCellDetail.m
//  QFProj
//
//  Created by wind on 2019/9/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCellDetail.h"

@implementation HTupleViewCellDetail1
@dynamic label, detailLabel;
- (void)frameChanged {
    CGRect frame = [self getContentBounds];
    
    CGRect tmpFrame = frame;
    tmpFrame.size.height = CGRectGetHeight(frame)/2;
    [self.label setFrame:tmpFrame];
    
    CGRect tmpFrame2 = tmpFrame;
    tmpFrame2.origin.y += CGRectGetMaxY(tmpFrame);
    [self.detailLabel setFrame:tmpFrame2];
}
@end

@implementation HTupleViewCellDetail2
@dynamic imageView, label, detailLabel;
- (void)frameChanged {
    CGRect frame = [self getContentBounds];
    
    CGRect tmpFrame = frame;
    tmpFrame.size.width = CGRectGetHeight(tmpFrame);
    [self.imageView setFrame:tmpFrame];
    
    CGRect tmpFrame2 = frame;
    tmpFrame2.origin.x += CGRectGetMaxX(tmpFrame)+10;
    tmpFrame2.size.width = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame)-10;
    tmpFrame2.size.height = CGRectGetHeight(tmpFrame)/2;
    [self.label setFrame:tmpFrame2];
    
    CGRect tmpFrame3 = tmpFrame2;
    tmpFrame3.origin.y += CGRectGetMaxY(tmpFrame2);
    [self.detailLabel setFrame:tmpFrame3];
}
@end

@implementation HTupleViewCellDetail3
@dynamic imageView, label;
@dynamic detailLabel, accessoryView;
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
    tmpFrame3.size.height = CGRectGetHeight(tmpFrame)/2;
    [self.label setFrame:tmpFrame3];
    
    CGRect tmpFrame4 = tmpFrame3;
    tmpFrame4.origin.y += CGRectGetMaxY(tmpFrame3);
    [self.detailLabel setFrame:tmpFrame4];
}
@end

@implementation HTupleViewCellDetail4
@dynamic imageView, label, detailLabel;
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
    tmpFrame4.size.height = CGRectGetHeight(tmpFrame)/2;
    [self.label setFrame:tmpFrame4];
    
    CGRect tmpFrame5 = tmpFrame4;
    tmpFrame5.origin.y += CGRectGetMaxY(tmpFrame4);
    [self.detailLabel setFrame:tmpFrame5];
}
@end
