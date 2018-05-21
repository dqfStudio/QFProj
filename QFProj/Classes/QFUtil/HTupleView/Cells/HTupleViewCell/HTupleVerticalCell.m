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
    HLayoutTupleView(self.tupleView)
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
//- (UIEdgeInsets)tupleView:(UIView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return UIEdgeInsetsMake(10, 0, 10, 0);
//}
- (void)tupleView:(UIView *)tupleView itemTuple:(id (^)(Class aClass))itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            HTextViewCell *cell = itemBlock(HTextViewCell.class);
            [cell.label setBackgroundColor:[UIColor grayColor]];
            [cell setBackgroundColor:[UIColor blueColor]];
        }
            break;
        case 1:
        {
            HButtonViewCell *cell = itemBlock(HButtonViewCell.class);
            [cell.button setBackgroundColor:[UIColor blueColor]];
            [cell setBackgroundColor:[UIColor redColor]];
            [cell setButtonViewBlock:^(HWebButtonView *webButtonView) {
                
            }];
        }
            break;
        case 2:
        {
            HImageViewCell *cell = itemBlock(HImageViewCell.class);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
            [cell setImageViewBlock:^(HWebImageView *webImageView) {
                
            }];
        }
            break;
        case 3:
        {
            HImageViewCell *cell = itemBlock(HImageViewCell.class);
            [cell.imageView setBackgroundColor:[UIColor redColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
            [cell setImageViewBlock:^(HWebImageView *webImageView) {
                
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
