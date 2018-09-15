//
//  HTupleDoubleImageCell.m
//  QFProj
//
//  Created by txkj_mac on 2018/9/15.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleDoubleImageCell.h"

@implementation HTupleDoubleImageCell

- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.frame];
        [_tupleView setTupleDelegate:self];
        [self addSubview:_tupleView];
    }
    return _tupleView;
}
- (void)layoutContentView {
    HLayoutTupleView(self.tupleView)
}

- (NSInteger)tupleView:(UICollectionView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(tupleView.frame), CGRectGetHeight(tupleView.frame)/2);
}
- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return UIEdgeInsetsMake(0, 0, 5, 0);
            break;
        case 1:
            return UIEdgeInsetsMake(5, 0, 0, 0);
            break;
            
        default:
            break;
    }
    return UIEdgeInsetsZero;
}
- (void)tupleView:(UICollectionView *)tupleView itemTuple:(id (^)(Class aClass))itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            HImageViewCell *cell = itemBlock(HImageViewCell.class);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
        }
            break;
        case 1:
        {
            HImageViewCell *cell = itemBlock(HImageViewCell.class);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
        }
            break;
            
        default:
        {
            HViewCell *cell = itemBlock(HViewCell.class);
            [cell setBackgroundColor:[UIColor clearColor]];
        }
            break;
    }
}

- (void)tupleView:(UICollectionView *)tupleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            NSLog(@"");
            break;
        case 1:
            NSLog(@"");
            break;
            
        default:
            break;
    }
}

@end

