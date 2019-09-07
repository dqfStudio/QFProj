//
//  HMainController3+HSection0.m
//  QFProj
//
//  Created by wind on 2019/9/7.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HMainController3+HSection0.h"

@implementation HMainController3 (HSection0)

- (NSInteger)section0_tupleView:(HTupleView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)section0_tupleView:(HTupleView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.tupleView.width, 65);
}
- (UIEdgeInsets)section0_tupleView:(HTupleView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)section0_tupleView:(HTupleView *)tupleView tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
    [cell setBackgroundColor:UIColor.grayColor];
    [cell setShouldShowSeparator:YES];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    
    CGRect frame = [cell getContentBounds];
    
    CGRect tmpFrame = frame;
    tmpFrame.size.width = CGRectGetHeight(tmpFrame);
    [cell.imageView setFrame:tmpFrame];
    [cell.imageView setBackgroundColor:UIColor.redColor];
    [cell.imageView setImageWithName:@"icon_no_server"];
    
    CGRect tmpFrame2 = frame;
    tmpFrame2.origin.x += CGRectGetMaxX(tmpFrame)+10;
    tmpFrame2.size.width = CGRectGetWidth(frame)-CGRectGetMinX(tmpFrame2);
    tmpFrame2.size.height = CGRectGetHeight(tmpFrame)/3;
    [cell.label setFrame:tmpFrame2];
    [cell.label setBackgroundColor:UIColor.redColor];
    
    CGRect tmpFrame3 = tmpFrame2;
    tmpFrame3.origin.y += CGRectGetMaxY(tmpFrame2);
    [cell.detailLabel setFrame:tmpFrame3];
    [cell.detailLabel setBackgroundColor:UIColor.yellowColor];
    
    CGRect tmpFrame4 = tmpFrame2;
    tmpFrame4.origin.y += CGRectGetMaxY(tmpFrame3);
    [cell.accessoryLabel setFrame:tmpFrame4];
    [cell.accessoryLabel setBackgroundColor:UIColor.greenColor];
}
@end
