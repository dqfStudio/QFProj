//
//  HLoginController.m
//  QFProj
//
//  Created by dqf on 2018/8/25.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HLoginController.h"

@interface HLoginController () <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@end

@implementation HLoginController

- (HTupleView *)tupleView {
    if (!_tupleView) {
        CGRect frame = self.view.frame;
        frame.origin.y += kTopBarHeight;
        frame.size.height -= kTopBarHeight;
        _tupleView = [[HTupleView alloc] initWithFrame:frame scrollDirection:HTupleViewScrollDirectionVertical];
        [_tupleView setTupleDelegate:self];
    }
    return _tupleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.view addSubview:self.tupleView];
}

- (NSInteger)tupleView:(UICollectionView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 11;
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return CGSizeMake(80, 60);
            break;
        case 1:
            return CGSizeMake(CGRectGetWidth(tupleView.frame)-80, 60);
            break;
        case 2:
            return CGSizeMake(80, 60);
            break;
        case 3:
            return CGSizeMake(CGRectGetWidth(tupleView.frame)-80, 60);
            break;
        case 4:
            return CGSizeMake(80, 60);
            break;
        case 5:
            return CGSizeMake(CGRectGetWidth(tupleView.frame)-80-120, 60);
            break;
        case 6:
            return CGSizeMake(120, 50);
            break;
        case 7:
            return CGSizeMake(CGRectGetWidth(tupleView.frame), 40);
            break;
        case 8:
            return CGSizeMake(CGRectGetWidth(tupleView.frame), 50);
            break;
        case 9:
            return CGSizeMake(CGRectGetWidth(tupleView.frame)-120, 20);
            break;
        case 10:
            return CGSizeMake(120, 20);
            break;

        default:
            break;
    }
    return CGSizeMake(0, 0);
}
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return UIEdgeInsetsMake(10, 15, 10, 0);
            break;
        case 1:
            return UIEdgeInsetsMake(10, 10, 10, 15);
            break;
        case 2:
            return UIEdgeInsetsMake(10, 15, 10, 0);
            break;
        case 3:
            return UIEdgeInsetsMake(10, 10, 10, 15);
            break;
        case 4:
            return UIEdgeInsetsMake(10, 15, 10, 0);
            break;
        case 5:
            return UIEdgeInsetsMake(10, 10, 10, 10);
            break;
        case 6:
            return UIEdgeInsetsMake(10, 0, 0, 15);
            break;
        case 7:
            return UIEdgeInsetsMake(0, 15, 0, 15);
            break;
        case 8:
            return UIEdgeInsetsMake(0, 15, 0, 15);
            break;
        case 9:
            return UIEdgeInsetsMake(0, 15, 0, 0);
            break;
        case 10:
            return UIEdgeInsetsMake(0, 0, 0, 15);
            break;
            
        default:
            break;
    }
    return UIEdgeInsetsMake(10, 0, 10, 0);
}
- (void)tupleView:(UICollectionView *)tupleView itemTuple:(id (^)(Class aClass))itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            HTextViewCell *cell = itemBlock(HTextViewCell.class);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.label setBackgroundColor:[UIColor grayColor]];
            [cell.label setText:@"+86"];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
        }
            break;
        case 1:
        {
            HButtonViewCell *cell = itemBlock(HButtonViewCell.class);
            [cell.button setBackgroundColor:[UIColor grayColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setButtonViewBlock:^(HWebButtonView *webButtonView, HButtonViewCell *buttonCell) {
                
            }];
        }
            break;
        case 2:
        {
            HTextViewCell *cell = itemBlock(HTextViewCell.class);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.label setBackgroundColor:[UIColor grayColor]];
            [cell.label setText:@"昵称"];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
        }
            break;
        case 3:
        {
            HImageViewCell *cell = itemBlock(HImageViewCell.class);
            [cell.imageView setBackgroundColor:[UIColor grayColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setImageViewBlock:^(HWebImageView *webImageView, HImageViewCell *imageCell) {
                
            }];
        }
            break;
        case 4:
        {
            HTextViewCell *cell = itemBlock(HTextViewCell.class);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.label setBackgroundColor:[UIColor grayColor]];
            [cell.label setText:@"验证码"];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
        }
            break;
        case 5:
        {
            HImageViewCell *cell = itemBlock(HImageViewCell.class);
            [cell.imageView setBackgroundColor:[UIColor grayColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setImageViewBlock:^(HWebImageView *webImageView, HImageViewCell *imageCell) {
                
            }];
        }
            break;
        case 6:
        {
            HImageViewCell *cell = itemBlock(HImageViewCell.class);
            [cell.imageView setBackgroundColor:[UIColor grayColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setImageViewBlock:^(HWebImageView *webImageView, HImageViewCell *imageCell) {
                
            }];
        }
            break;
        case 7:
        {
            HTextViewCell *cell = itemBlock(HTextViewCell.class);
            [cell setBackgroundColor:[UIColor clearColor]];
        }
            break;
        case 8:
        {
            HButtonViewCell *cell = itemBlock(HButtonViewCell.class);
            [cell.button setBackgroundColor:[UIColor grayColor]];
            [cell.button.button setTitle:@"开始"];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setButtonViewBlock:^(HWebButtonView *webButtonView, HButtonViewCell *buttonCell) {
                
            }];
        }
            break;
        case 9:
        {
            HTextViewCell *cell = itemBlock(HTextViewCell.class);
            [cell.label setBackgroundColor:[UIColor clearColor]];
            [cell.label setText:@"点击开始,即表示已阅读并同意"];
            [cell.label setFont:[UIFont systemFontOfSize:12]];
            [cell.label setTextAlignment:NSTextAlignmentRight];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
            break;
        case 10:
        {
            HButtonViewCell *cell = itemBlock(HButtonViewCell.class);
            [cell.button setBackgroundColor:[UIColor clearColor]];
            [cell.button.button setTitle:@"《服务协议》"];
            [cell.button.button setFont:[UIFont systemFontOfSize:12]];
            [cell.button.button setTitleColor:[UIColor greenColor]];
            [cell.button.button setTextAlignment:NSTextAlignmentLeft];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setButtonViewBlock:^(HWebButtonView *webButtonView, HButtonViewCell *buttonCell) {
                
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
