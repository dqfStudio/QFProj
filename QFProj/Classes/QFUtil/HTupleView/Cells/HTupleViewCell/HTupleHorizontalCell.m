//
//  HTupleHorizontalCell.m
//  QFProj
//
//  Created by dqf on 2018/5/21.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleHorizontalCell.h"

@implementation HTupleHorizontalCell

- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.frame scrollDirection:HTupleViewScrollDirectionHorizontal];
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
    return 5;
}

- (CGSize)tupleView:(UIView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return CGSizeMake(290, 100);
    }
    return CGSizeMake(290, 30);
}
- (CGSize)tupleView:(UIView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(30, 70);
    }
    return CGSizeMake(0, 0);
}
- (CGSize)tupleView:(UIView *)tupleView sizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
- (UIEdgeInsets)tupleView:(UIView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(10, 0, 10, 0);
}
- (void)tupleView:(UIView *)tupleView itemTuple:(id (^)(Class aClass))itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            HTextViewCell *cell = itemBlock(HTextViewCell.class);
            [cell.label setBackgroundColor:[UIColor redColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
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

- (void)tupleView:(UIView *)tupleView headerTuple:(id (^)(Class aClass))headerBlock inSection:(NSInteger)section {
    switch (section) {
        case 0:{
            HReusableTextView *cell = headerBlock(HReusableTextView.class);
            [cell.label setBackgroundColor:[UIColor yellowColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
        case 1:
        {
            HReusableButtonView *cell = headerBlock(HReusableButtonView.class);
            [cell.button setBackgroundColor:[UIColor blueColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
        case 2:
        {
            HReusableImageView *cell = headerBlock(HReusableImageView.class);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
            
        default:
        {
            HReusableImageView *cell = headerBlock(HReusableImageView.class);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
    }
}

//- (void)tupleView:(UIView *)tupleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end
