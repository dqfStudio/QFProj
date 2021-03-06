//
//  HMainController3+HSection1.m
//  QFProj
//
//  Created by wind on 2019/9/7.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HMainController3+HSection1.h"

@implementation HMainController3 (HSection1)

- (NSInteger)section1_tupleView:(HTupleView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)section1_tupleView:(HTupleView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.tupleView.width, 65);
}
- (UIEdgeInsets)section1_tupleView:(HTupleView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)section1_tupleView:(HTupleView *)tupleView tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
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
    
    CGRect tmpFrame2 = CGRectMake(0, 0, 10, 18);
    tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
    tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
    [cell.accessoryView setFrame:tmpFrame2];
    [cell.accessoryView setImageWithName:@"icon_tuple_arrow_right"];
    
    CGRect tmpFrame3 = frame;
    tmpFrame3.origin.x += CGRectGetMaxX(tmpFrame)+10;
    tmpFrame3.size.width = CGRectGetMinX(tmpFrame2)-CGRectGetMinX(tmpFrame3)-10;
    tmpFrame3.size.height = tmpFrame.size.height/2;
    [cell.label setFrame:tmpFrame3];
    [cell.label setBackgroundColor:UIColor.redColor];
    
    CGRect tmpFrame4 = tmpFrame3;
    tmpFrame4.origin.y += CGRectGetMaxY(tmpFrame3);
    [cell.detailLabel setFrame:tmpFrame4];
    [cell.detailLabel setBackgroundColor:UIColor.yellowColor];
}
@end
