//
//  HTupleVerticalCell.m
//  QFProj
//
//  Created by dqf on 2018/5/21.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleVerticalCell.h"

@implementation HTupleVerticalModel

@end

@implementation HTupleVerticalCell

- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds];
        [_tupleView setTupleDelegate:self];
        [self addSubview:_tupleView];
    }
    return _tupleView;
}

- (void)layoutContentView {
    HLayoutTupleView(self.tupleView)
}

- (void)setModel:(HTupleVerticalModel *)model {
    if (_model != model) {
        _model = nil;
        _model = model;
        [self.tupleView reloadData];
    }
}

- (NSInteger)tupleView:(UICollectionView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return CGSizeMake(290/3, 30);
    }
    return CGSizeMake(290/3, 30);
}
//- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return UIEdgeInsetsMake(10, 0, 10, 0);
//}
- (void)tupleView:(UICollectionView *)tupleView initTuple:(void (^)(HTupleCellInitBlock initBlock))initBlock itemTuple:(id (^)(Class aClass))itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            HLabelViewCell *cell = itemBlock(HLabelViewCell.class);
            [cell.label setBackgroundColor:[UIColor grayColor]];
            [cell setBackgroundColor:[UIColor blueColor]];
        }
            break;
        case 1:
        {
            HButtonViewCell *cell = itemBlock(HButtonViewCell.class);
            [cell.buttonView setBackgroundColor:[UIColor blueColor]];
            [cell setBackgroundColor:[UIColor redColor]];
            [cell setButtonViewBlock:^(HWebButtonView *webButtonView, HButtonViewCell *buttonCell) {
                
            }];
        }
            break;
        case 2:
        {
            HImageViewCell *cell = itemBlock(HImageViewCell.class);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
            [cell setImageViewBlock:^(HWebImageView *webImageView, HImageViewCell *imageCell) {
                
            }];
        }
            break;
        case 3:
        {
            HImageViewCell *cell = itemBlock(HImageViewCell.class);
            [cell.imageView setBackgroundColor:[UIColor redColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
            [cell setImageViewBlock:^(HWebImageView *webImageView, HImageViewCell *imageCell) {
                
            }];
        }
            break;
            
        default:
        {
            HImageViewCell *cell = itemBlock(HImageViewCell.class);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
    }
}

@end
