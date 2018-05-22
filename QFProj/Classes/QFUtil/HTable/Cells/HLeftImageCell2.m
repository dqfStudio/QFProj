//
//  HLeftImageCell2.m
//  QFTableProject
//
//  Created by dqf on 2018/5/22.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HLeftImageCell2.h"

#define KHeaderWidth   80
#define KFooterWidth   35
#define KCornerWidth  (KHeaderWidth-20)

#define KCellWidth  CGRectGetWidth(self.frame)
#define KCellHeight CGRectGetHeight(self.frame)

@implementation HLeftImageCell2

- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:CGRectZero scrollDirection:HTupleViewScrollDirectionHorizontal];
        [_tupleView setTupleDelegate:self];
        [_tupleView setScrollEnabled:NO];
        [self addSubview:_tupleView];
    }
    return _tupleView;
}

- (void)initUI {
    [self addSubview:self.tupleView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:[UIColor yellowColor]];
}

- (void)setModel:(HCellModel *)model {
    [super setModel:model];
    if (model.height != CGRectGetHeight(self.tupleView.frame)) {
        CGRect frame = self.bounds;
        frame.size.height = model.height;
        [self.tupleView setFrame:frame];
    }
}

- (NSInteger)tupleView:(UIView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (CGSize)tupleView:(UIView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(KCellWidth-KHeaderWidth-KFooterWidth, KCellHeight/3);
}
- (CGSize)tupleView:(UIView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(KHeaderWidth, KCellHeight);
}
- (CGSize)tupleView:(UIView *)tupleView sizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(KFooterWidth, KCellHeight);
}
- (UIEdgeInsets)tupleView:(UIView *)tupleView edgeInsetsForHeaderInSection:(NSInteger)section {
    return UIEdgeInsetsMake(KCellHeight/2-KCornerWidth/2, 10.f, KCellHeight/2-KCornerWidth/2, 10.f);
}
- (UIEdgeInsets)tupleView:(UIView *)tupleView edgeInsetsForFooterInSection:(NSInteger)section {
    return UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
}
- (UIEdgeInsets)tupleView:(UIView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return UIEdgeInsetsMake(10.f, 0.f, 0.f, 0.f);
            break;
        case 1:
            return UIEdgeInsetsMake(5.f, 0.f, 5.f, 0.f);
            break;
        case 2:
            return UIEdgeInsetsMake(0.f, 0.f, 10.f, 0.f);
            break;

        default:
            break;
    }
    return UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
}
- (void)tupleView:(UIView *)tupleView itemTuple:(id (^)(Class aClass))itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            HTextViewCell *cell = itemBlock(HTextViewCell.class);
            [cell.label setBackgroundColor:[UIColor greenColor]];
            [cell.label setText:@"第一个label"];
        }
            break;
        case 1: {
            HTextViewCell *cell = itemBlock(HTextViewCell.class);
            [cell.label setText:@"第二个label"];
            [cell.label setBackgroundColor:[UIColor grayColor]];
        }
            break;
        case 2: {
            HTextViewCell *cell = itemBlock(HTextViewCell.class);
            [cell.label setText:@"第三个label"];
            [cell.label setBackgroundColor:[UIColor redColor]];
        }
            break;
            
        default:
            break;
    }
}

- (void)tupleView:(UIView *)tupleView headerTuple:(id (^)(Class aClass))headerBlock inSection:(NSInteger)section {
    HReusableImageView *cell = headerBlock(HReusableImageView.class);
    [cell.imageView setBackgroundColor:[UIColor greenColor]];
    cell.imageView.layer.cornerRadius = KCornerWidth/2;
}


- (void)tupleView:(UIView *)tupleView footerTuple:(id (^)(Class aClass))footerBlock inSection:(NSInteger)section {
    HReusableButtonView *cell = footerBlock(HReusableButtonView.class);
    [cell.button setBackgroundColor:[UIColor clearColor]];
    [cell.button.button setImage:[UIImage imageNamed:@"icon_tuple_arrow_right"] forState:UIControlStateNormal];
    
}

@end
