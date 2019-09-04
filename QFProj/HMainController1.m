//
//  HMainController1.m
//  QFProj
//
//  Created by wind on 2019/9/4.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HMainController1.h"

@interface HMainController1 ()

@end

@implementation HMainController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.leftNaviButton setHidden:YES];
    [self setTitle:@"第一页"];
    [self.tupleView setTupleDelegate:self];
}

- (NSInteger)numberOfSectionsInTupleView:(HTupleView *)tupleView {
    return 1;
}
- (NSInteger)tupleView:(HTupleView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 1;
}
//style == HTupleViewStyleSectionColorLayout
//- (UIColor *)tupleView:(HTupleView *)tupleView colorForSectionAtIndex:(NSInteger)section {
//
//}

//- (CGSize)tupleView:(HTupleView *)tupleView sizeForHeaderInSection:(NSInteger)section {
//    return CGSizeZero;
//}
//- (CGSize)tupleView:(HTupleView *)tupleView sizeForFooterInSection:(NSInteger)section {
//    return CGSizeZero;
//}
- (CGSize)tupleView:(HTupleView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.tupleView.width, 65);
}

//- (UIEdgeInsets)tupleView:(HTupleView *)tupleView edgeInsetsForHeaderInSection:(NSInteger)section {
//    return UIEdgeInsetsZero;
//}
//- (UIEdgeInsets)tupleView:(HTupleView *)tupleView edgeInsetsForFooterInSection:(NSInteger)section {
//    return UIEdgeInsetsZero;
//}
- (UIEdgeInsets)tupleView:(HTupleView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//- (void)tupleView:(HTupleView *)tupleView tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section {
//
//}
//- (void)tupleView:(HTupleView *)tupleView tupleFooter:(HTupleFooter)footerBlock inSection:(NSInteger)section {
//
//}
- (void)tupleView:(HTupleView *)tupleView tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
    [cell setBackgroundColor:UIColor.grayColor];
    
    CGRect frame = [cell getContentBounds];
    
    CGRect tmpFrame = frame;
    tmpFrame.size.width = tmpFrame.size.height;
    [cell.imageView setFrame:tmpFrame];
    [cell.imageView setBackgroundColor:UIColor.redColor];
    
    CGRect tmpFrame2 = tmpFrame;
    tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame);
    [cell.detailView setFrame:tmpFrame2];
    [cell.detailView setBackgroundColor:UIColor.greenColor];
    
    CGRect tmpFrame3 = frame;
    tmpFrame3.origin.x += CGRectGetMaxX(tmpFrame)+10;
    tmpFrame3.size.width = CGRectGetWidth(frame)-tmpFrame3.origin.x-CGRectGetWidth(tmpFrame2)-10;
    tmpFrame3.size.height = tmpFrame.size.height/2;
    [cell.label setFrame:tmpFrame3];
    [cell.label setBackgroundColor:UIColor.redColor];
    
    CGRect tmpFrame4 = tmpFrame3;
    tmpFrame4.origin.y += CGRectGetMaxY(tmpFrame3);
    [cell.detailLabel setFrame:tmpFrame4];
    [cell.detailLabel setBackgroundColor:UIColor.yellowColor];
    
}

//- (void)tupleView:(HTupleView *)tupleView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//
//}
- (void)tupleView:(HTupleView *)tupleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

@end
