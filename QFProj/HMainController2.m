//
//  HMainController2.m
//  QFProj
//
//  Created by wind on 2019/9/4.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HMainController2.h"

@interface HMainController2 ()

@end

@implementation HMainController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.leftNaviButton setHidden:YES];
    [self setTitle:@"第二页"];
    [self.tupleView setTupleDelegate:self];
}

- (NSInteger)numberOfSectionsInTupleView:(HTupleView *)tupleView {
    return 1;
}
- (NSInteger)tupleView:(HTupleView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 7;
}
- (CGSize)tupleView:(HTupleView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
            return CGSizeMake(self.tupleView.width, 65);
            break;
        case 3:
        case 4:
        case 5:
            return CGSizeMake(self.tupleView.width/3, 120);
            break;
            
        default:
            break;
    }
    return CGSizeMake(self.tupleView.width, 65);
}
- (UIEdgeInsets)tupleView:(HTupleView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 3:
            return UIEdgeInsetsMake(10, 10, 10, 5);
        case 4:
            return UIEdgeInsetsMake(10, 5, 10, 5);
        case 5:
            return UIEdgeInsetsMake(10, 5, 10, 10);
        default:
            break;
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)tupleView:(HTupleView *)tupleView tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
//            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
//            [cell setBackgroundColor:UIColor.grayColor];
//            [cell setShouldShowSeparator:YES];
//            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
//
//            CGRect frame = [cell getContentBounds];
//
//            CGRect tmpFrame = frame;
//            tmpFrame.size.width = tmpFrame.size.height;
//            [cell.imageView setFrame:tmpFrame];
//            [cell.imageView setBackgroundColor:UIColor.redColor];
//
//            CGRect tmpFrame2 = frame;
//            tmpFrame2.origin.x += CGRectGetMaxX(tmpFrame)+10;
//            tmpFrame2.size.width = CGRectGetWidth(frame)-tmpFrame2.origin.x;
//            tmpFrame2.size.height = tmpFrame.size.height/3;
//            [cell.label setFrame:tmpFrame2];
//            [cell.label setBackgroundColor:UIColor.redColor];
//
//            CGRect tmpFrame3 = tmpFrame2;
//            tmpFrame3.origin.y += CGRectGetMaxY(tmpFrame2);
//            [cell.detailLabel setFrame:tmpFrame3];
//            [cell.detailLabel setBackgroundColor:UIColor.yellowColor];
//
//            CGRect tmpFrame4 = tmpFrame2;
//            tmpFrame4.origin.y += CGRectGetMaxY(tmpFrame3);
//            [cell.accessoryLabel setFrame:tmpFrame4];
//            [cell.accessoryLabel setBackgroundColor:UIColor.greenColor];
            HTupleHorizontalCell *cell = itemBlock(nil, HTupleHorizontalCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
            
            CGRect frame = [cell getContentBounds];
            
            [cell.tupleView tupleWithSections:^CGFloat{
                return 1;
            } items:^CGFloat(NSInteger section) {
                return 3;
            } color:^UIColor * _Nullable(NSInteger section) {
                return nil;
            } inset:^UIEdgeInsets(NSInteger section) {
                return UIEdgeInsetsZero;
            }];
            
            [cell.tupleView headerWithSize:^CGSize(NSInteger section) {
                return CGSizeMake(CGRectGetHeight(frame), CGRectGetHeight(frame));
            } edgeInsets:^UIEdgeInsets(NSInteger section) {
                return UIEdgeInsetsZero;
            } tupleHeader:^(HTupleHeader  _Nonnull headerBlock, NSInteger section) {
                HTupleImageView *cell = headerBlock(nil, HTupleImageView.class, nil, YES);
                [cell setBackgroundColor:UIColor.redColor];
            }];
            
            [cell.tupleView itemWithSize:^CGSize(NSIndexPath * _Nonnull indexPath) {
                return CGSizeMake(CGRectGetWidth(frame)-CGRectGetHeight(frame), CGRectGetHeight(frame)/3);
            } edgeInsets:^UIEdgeInsets(NSIndexPath * _Nonnull indexPath) {
                return UIEdgeInsetsMake(0, 10, 0, 0);
            } tupleItem:^(HTupleItem  _Nonnull itemBlock, NSIndexPath * _Nonnull indexPath) {
                HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                switch (indexPath.row) {
                    case 0: {
                        [cell.label setBackgroundColor:UIColor.redColor];
                    }
                        break;
                    case 1: {
                        [cell.label setBackgroundColor:UIColor.yellowColor];
                    }
                        break;
                    case 2: {
                        [cell.label setBackgroundColor:UIColor.greenColor];
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
        
        }
            break;
        case 1: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
            
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
            tmpFrame3.size.width = CGRectGetMinX(tmpFrame2)-tmpFrame3.origin.x-10;
            tmpFrame3.size.height = tmpFrame.size.height/2;
            [cell.label setFrame:tmpFrame3];
            [cell.label setBackgroundColor:UIColor.redColor];
            
            CGRect tmpFrame4 = tmpFrame3;
            tmpFrame4.origin.y += CGRectGetMaxY(tmpFrame3);
            [cell.detailLabel setFrame:tmpFrame4];
            [cell.detailLabel setBackgroundColor:UIColor.yellowColor];
        }
            break;
        case 2: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
            
            CGRect frame = [cell getContentBounds];
            
            CGRect tmpFrame = frame;
            tmpFrame.size.width = tmpFrame.size.height;
            [cell.imageView setFrame:tmpFrame];
            [cell.imageView setBackgroundColor:UIColor.redColor];
            
            CGRect tmpFrame2 = tmpFrame;
            tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
            [cell.detailView setFrame:tmpFrame2];
            [cell.detailView setBackgroundColor:UIColor.redColor];
            
            CGRect tmpFrame3 = tmpFrame;
            tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3)-10;
            [cell.accessoryView setFrame:tmpFrame3];
            [cell.accessoryView setBackgroundColor:UIColor.redColor];
            
            CGRect tmpFrame4 = frame;
            tmpFrame4.origin.x += CGRectGetMaxX(tmpFrame)+10;
            tmpFrame4.size.width = CGRectGetMinX(tmpFrame3)-CGRectGetWidth(tmpFrame)-10-10;
            tmpFrame4.size.height = tmpFrame.size.height/2;
            [cell.label setFrame:tmpFrame4];
            [cell.label setBackgroundColor:UIColor.redColor];
            
            CGRect tmpFrame5 = tmpFrame4;
            tmpFrame5.origin.y += CGRectGetMaxY(tmpFrame4);
            [cell.detailLabel setFrame:tmpFrame5];
            [cell.detailLabel setBackgroundColor:UIColor.yellowColor];
        }
            break;
        case 3: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
            
            CGRect frame = [cell getContentBounds];
            
            CGRect tmpFrame = frame;
            tmpFrame.size.height = CGRectGetHeight(frame)-20;
            [cell.imageView setFrame:tmpFrame];
            [cell.imageView setBackgroundColor:UIColor.redColor];
            
            CGRect tmpFrame2 = frame;
            tmpFrame2.origin.y += CGRectGetMaxY(tmpFrame);
            tmpFrame2.size.height = 20;
            [cell.label setFrame:tmpFrame2];
            [cell.label setBackgroundColor:UIColor.greenColor];
        }
            break;
        case 4: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            
            CGRect frame = [cell getContentBounds];
            
            CGRect tmpFrame = frame;
            tmpFrame.size.height = CGRectGetHeight(frame)-20;
            [cell.imageView setFrame:tmpFrame];
            [cell.imageView setBackgroundColor:UIColor.redColor];
            
            CGRect tmpFrame2 = frame;
            tmpFrame2.origin.y += CGRectGetMaxY(tmpFrame);
            tmpFrame2.size.height = 20;
            [cell.label setFrame:tmpFrame2];
            [cell.label setBackgroundColor:UIColor.greenColor];
        }
            break;
        case 5: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 10)];
            
            CGRect frame = [cell getContentBounds];
            
            CGRect tmpFrame = frame;
            tmpFrame.size.height = CGRectGetHeight(frame)-20;
            [cell.imageView setFrame:tmpFrame];
            [cell.imageView setBackgroundColor:UIColor.redColor];
            
            CGRect tmpFrame2 = frame;
            tmpFrame2.origin.y += CGRectGetMaxY(tmpFrame);
            tmpFrame2.size.height = 20;
            [cell.label setFrame:tmpFrame2];
            [cell.label setBackgroundColor:UIColor.greenColor];
        }
            break;
        case 6: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            //            [cell setShouldShowSeparator:YES];
            //            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
            
            CGRect frame = [cell getContentBounds];
            
            CGRect tmpFrame = frame;
            tmpFrame.size.width = tmpFrame.size.width/3-20/3;
            [cell.label setFrame:tmpFrame];
            [cell.label setBackgroundColor:UIColor.greenColor];
            
            CGRect tmpFrame2 = frame;
            tmpFrame2.origin.x = CGRectGetMaxX(tmpFrame)+10;
            tmpFrame2.size.width = tmpFrame.size.width;
            [cell.detailLabel setFrame:tmpFrame2];
            [cell.detailLabel setBackgroundColor:UIColor.redColor];
            
            CGRect tmpFrame3 = frame;
            tmpFrame3.origin.x = CGRectGetMaxX(tmpFrame2)+10;
            tmpFrame3.size.width = tmpFrame.size.width;
            [cell.accessoryLabel setFrame:tmpFrame3];
            [cell.accessoryLabel setBackgroundColor:UIColor.yellowColor];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)tupleView:(HTupleView *)tupleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
