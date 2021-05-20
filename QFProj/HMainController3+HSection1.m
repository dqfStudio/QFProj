//
//  HMainController3+HSection1.m
//  QFProj
//
//  Created by dqf on 2019/9/7.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HMainController3+HSection1.h"

@implementation HMainController3 (HSection1)

- (NSInteger)tupleExa1_numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)tupleExa1_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.tupleView.width, 65);
}
- (UIEdgeInsets)tupleExa1_edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)tupleExa1_tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
    [cell setBackgroundColor:UIColor.grayColor];
    [cell setShouldShowSeparator:YES];
    [cell setSeparatorInset:UILREdgeInsetsMake(10, 10)];
    
    HRect *frame = HRectFor(cell.layoutViewBounds);
    
    HRect *tmpFrame = HRectFor(frame.frame);
    tmpFrame.width = tmpFrame.height;
    [cell.imageView setFrame:tmpFrame.frame];
    [cell.imageView setBackgroundColor:UIColor.redColor];
    [cell.imageView setImageWithName:@"icon_no_server"];
    
    HRect *tmpFrame2 = HRectFor(CGRectMake(0, 0, 7, 13));
    tmpFrame2.x = frame.width-tmpFrame2.width;
    tmpFrame2.y = frame.height/2-tmpFrame2.height/2;
    [cell.accessoryImageView setFrame:tmpFrame2.frame];
    [cell.accessoryImageView setImageWithName:@"icon_tuple_arrow_right"];
    
    HRect *tmpFrame3 = HRectFor(frame.frame);
    tmpFrame3.x += tmpFrame.maxX+10;
    tmpFrame3.width = tmpFrame2.minX-tmpFrame3.minX-10;
    tmpFrame3.height = tmpFrame.height/2;
    [cell.label setFrame:tmpFrame3.frame];
    [cell.label setBackgroundColor:UIColor.redColor];
    
    HRect *tmpFrame4 = HRectFor(tmpFrame3.frame);;
    tmpFrame4.y += tmpFrame3.maxY;
    [cell.detailLabel setFrame:tmpFrame4.frame];
    [cell.detailLabel setBackgroundColor:UIColor.yellowColor];
}
@end
