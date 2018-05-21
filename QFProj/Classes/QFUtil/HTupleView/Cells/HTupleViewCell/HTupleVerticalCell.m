//
//  HTupleVerticalCell.m
//  QFProj
//
//  Created by dqf on 2018/5/21.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleVerticalCell.h"

@implementation HTupleVerticalCell

- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.frame];
        [_tupleView setTupleDelegate:self];
        [self addSubview:_tupleView];
    }
    return _tupleView;
}
- (void)layoutContentView {
    if(!CGRectEqualToRect(self.tupleView.frame, [self getContentView])) {
        [self.tupleView setFrame:[self getContentView]];
    }
}

- (NSInteger)tupleView:(UIView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (CGSize)tupleView:(UIView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return CGSizeMake(290/3, 30);
    }
    return CGSizeMake(290/3, 30);
}
//- (UIEdgeInsets)tupleView:(UIView *)tupleView edgeInsetsForCellAtIndexPath:(NSIndexPath *)indexPath {
//    return UIEdgeInsetsMake(10, 0, 10, 0);
//}
- (void)tupleView:(UIView *)tupleView cellTuple:(id (^)(Class aClass))cellBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            HTextViewCell *cell = cellBlock(HTextViewCell.class);
            [cell.label setBackgroundColor:[UIColor grayColor]];
            [cell setBackgroundColor:[UIColor blueColor]];
        }
            break;
        case 1:
        {
            HButtonViewCell *cell = cellBlock(HButtonViewCell.class);
            [cell.button setBackgroundColor:[UIColor blueColor]];
            [cell setBackgroundColor:[UIColor redColor]];
            [cell setButtonViewBlock:^(UIButton *btn) {
                
            }];
        }
            break;
        case 2:
        {
            HImageViewCell *cell = cellBlock(HImageViewCell.class);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
            [cell setImageViewBlock:^(UIImageView *imageView) {
                
            }];
        }
            break;
        case 3:
        {
            HImageViewCell *cell = cellBlock(HImageViewCell.class);
            [cell.imageView setBackgroundColor:[UIColor redColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
            [cell setImageViewBlock:^(UIImageView *imageView) {
                
            }];
        }
            break;
            
        default:
        {
            HImageViewCell *cell = cellBlock(HImageViewCell.class);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
    }
}

@end
