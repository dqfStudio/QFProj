//
//  HMainController3+HSection2.m
//  QFProj
//
//  Created by dqf on 2019/9/7.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HMainController3+HSection2.h"

@implementation HMainController3 (HSection2)

- (NSInteger)tupleExa2_numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)tupleExa2_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.tupleView.width, 65);
}
- (UIEdgeInsets)tupleExa2_edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)tupleExa2_tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
    [cell setBackgroundColor:UIColor.grayColor];
    [cell setShouldShowSeparator:YES];
    [cell setSeparatorInset:UILREdgeInsetsMake(10, 10)];
    
    CGRect frame = [cell layoutViewBounds];
    
    CGRect tmpFrame = frame;
    tmpFrame.size.width = CGRectGetHeight(tmpFrame);
    [cell.imageView setFrame:tmpFrame];
    [cell.imageView setBackgroundColor:UIColor.redColor];
    [cell.imageView setImageWithName:@"icon_no_server"];
    
    CGRect tmpFrame2 = CGRectMake(0, 0, 7, 13);;
    tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
    tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
    [cell.accessoryImageView setFrame:tmpFrame2];
    [cell.accessoryImageView setImageWithName:@"icon_tuple_arrow_right"];
    
    CGRect tmpFrame3 = tmpFrame;
    tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3)-10;
    [cell.detailImageView setFrame:tmpFrame3];
    [cell.detailImageView setBackgroundColor:UIColor.redColor];
    [cell.detailImageView setImageWithName:@"icon_no_server"];
    
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
