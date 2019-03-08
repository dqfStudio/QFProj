//
//  HTupleImageTextCell.m
//  QFProj
//
//  Created by wind on 2019/3/8.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import "HTupleImageTextCell.h"

@implementation HTupleImageTextCell

- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds];
        [_tupleView setTupleDelegate:self];
        [self addSubview:_tupleView];
    }
    return _tupleView;
}

- (void)initUI {
    self.textHeight = 25;
}

- (void)layoutContentView {
    HLayoutTupleView(self.tupleView)
}

- (void)setModel:(HTupleImageTextModel *)model {
    if (_model != model) {
        _model = nil;
        _model = model;
        [self.tupleView reloadData];
    }
}

- (NSInteger)tupleView:(UICollectionView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 2;
}
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: return CGSizeMake(tupleView.width, tupleView.height-self.textHeight);
        case 1: return CGSizeMake(tupleView.width, self.textHeight);
        default: return CGSizeZero;
    }
}
- (void)tupleView:(UICollectionView *)tupleView itemTuple:(id (^)(id iblk, Class cls, id pre, bool idx))itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            HImageViewCell *cell = itemBlock(nil, HImageViewCell.class, nil, YES);
            [cell.imageView setImageUrlString:self.model.cellImage];
        }
            break;
        case 1: {
            HLabelViewCell *cell = itemBlock(nil, HLabelViewCell.class, nil, YES);
            [cell.label setText:self.model.cellText];
        }
            break;
            
        default:
            break;
    }
}

- (void)tupleView:(UICollectionView *)tupleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end

