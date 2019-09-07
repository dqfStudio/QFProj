//
//  HMainController3+HSection2.m
//  QFProj
//
//  Created by wind on 2019/9/7.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HMainController3+HSection2.h"

@implementation HMainController3 (HSection2)

- (NSInteger)section2_tupleView:(HTupleView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)section2_tupleView:(HTupleView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.tupleView.width, 65);
}
- (UIEdgeInsets)section2_tupleView:(HTupleView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)section2_tupleView:(HTupleView *)tupleView tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
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
    
    CGRect tmpFrame2 = CGRectMake(0, 0, 10, 18);;
    tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
    tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
    [cell.accessoryView setFrame:tmpFrame2];
    [cell.accessoryView setImageWithName:@"icon_tuple_arrow_right"];
    
    CGRect tmpFrame3 = tmpFrame;
    tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3)-10;
    [cell.detailView setFrame:tmpFrame3];
    [cell.detailView setBackgroundColor:UIColor.redColor];
    [cell.detailView setImageWithName:@"icon_no_server"];
    
    CGRect tmpFrame4 = frame;
    tmpFrame4.origin.x += CGRectGetMaxX(tmpFrame)+10;
    tmpFrame4.size.width = CGRectGetMinX(tmpFrame3)-CGRectGetWidth(tmpFrame)-10-10;
    tmpFrame4.size.height = CGRectGetHeight(tmpFrame)/2;
    [cell.label setFrame:tmpFrame4];
    [cell.label setBackgroundColor:UIColor.redColor];
    
    CGRect tmpFrame5 = tmpFrame4;
    tmpFrame5.origin.y += CGRectGetMaxY(tmpFrame4);
    [cell.detailLabel setFrame:tmpFrame5];
    [cell.detailLabel setBackgroundColor:UIColor.yellowColor];
}
@end
