//
//  HTupleHorizontalCell.m
//  QFProj
//
//  Created by dqf on 2018/5/21.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleHorizontalCell.h"

@implementation HTupleHorizontalModel

@end

@implementation HTupleHorizontalCell

- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds scrollDirection:HTupleViewScrollDirectionHorizontal];
        [_tupleView setTupleDelegate:self];
        [self addSubview:_tupleView];
    }
    return _tupleView;
}

- (void)layoutContentView {
    HLayoutTupleView(self.tupleView)
}

- (void)setModel:(HTupleHorizontalModel *)model {
    if (_model != model) {
        _model = nil;
        _model = model;
        [self.tupleView reloadData];
    }
}

- (NSInteger)tupleView:(UICollectionView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return CGSizeMake(290, 100);
    }
    return CGSizeMake(290, 30);
}
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(30, 70);
    }
    return CGSizeMake(0, 0);
}
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(10, 0, 10, 0);
}
- (void)tupleView:(UICollectionView *)tupleView itemTuple:(HItemTuple)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            HLabelViewCell *cell = itemBlock(nil, HLabelViewCell.class, nil, YES);
            [cell.label setBackgroundColor:[UIColor redColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
        case 1:
        {
            HButtonViewCell *cell = itemBlock(nil, HButtonViewCell.class, nil, YES);
            [cell.buttonView setBackgroundColor:[UIColor blueColor]];
            [cell setBackgroundColor:[UIColor redColor]];
            [cell setButtonViewBlock:^(HWebButtonView *webButtonView, HButtonViewCell *buttonCell) {
                
            }];
        }
            break;
        case 2:
        {
            HImageViewCell *cell = itemBlock(nil, HImageViewCell.class, nil, YES);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
            [cell setImageViewBlock:^(HWebImageView *webImageView, HImageViewCell *imageCell) {
                
            }];
        }
            break;
        case 3:
        {
            HImageViewCell *cell = itemBlock(nil, HImageViewCell.class, nil, YES);
            [cell.imageView setBackgroundColor:[UIColor redColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
            [cell setImageViewBlock:^(HWebImageView *webImageView, HImageViewCell *imageCell) {
                
            }];
        }
            break;
            
        default:
        {
            HImageViewCell *cell = itemBlock(nil,HImageViewCell.class, nil, YES);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
    }
}

- (void)tupleView:(UICollectionView *)tupleView headerTuple:(HHeaderTuple)headerBlock inSection:(NSInteger)section {
    switch (section) {
        case 0:{
            HReusableLabelView *cell = headerBlock(nil, HReusableLabelView.class, nil, YES);
            [cell.label setBackgroundColor:[UIColor yellowColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
        case 1:
        {
            HReusableButtonView *cell = headerBlock(nil, HReusableButtonView.class, nil, YES);
            [cell.buttonView setBackgroundColor:[UIColor blueColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
        case 2:
        {
            HReusableImageView *cell = headerBlock(nil, HReusableImageView.class, nil, YES);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
            
        default:
        {
            HReusableImageView *cell = headerBlock(nil, HReusableImageView.class, nil, YES);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
    }
}

//- (void)tupleView:(UICollectionView *)tupleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end
