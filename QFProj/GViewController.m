//
//  GViewController.m
//  QFProj
//
//  Created by txkj_mac on 2018/9/11.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "GViewController.h"
@interface GViewController () <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@end

@implementation GViewController

- (HTupleView *)tupleView {
    if (!_tupleView) {
        CGRect frame = self.view.bounds;
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
    [self setTitle:@"首页"];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.view addSubview:self.tupleView];
}

- (NSInteger)tupleView:(UICollectionView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 11;
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(tupleView.frame)/4-20/4, CGRectGetWidth(tupleView.frame)/4-20/4);
}
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView layout:(UICollectionViewLayout *)layout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (void)tupleView:(UICollectionView *)tupleView itemTuple:(id (^)(Class aClass))itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            HTextViewCell *cell = itemBlock(HTextViewCell.class);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            [cell.label setText:@"+86"];
            [cell.label setFont:[UIFont systemFontOfSize:14]];
        }
            break;
        case 1:
        {
            HTextFieldCell *cell = itemBlock(HTextFieldCell.class);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.textField setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
            [cell.textField setPlaceholder:@"请输入手机号"];
            [cell.textField setTintColor:[UIColor colorWithString:@"#BABABF"]];
            [cell.textField setFont:[UIFont systemFontOfSize:14]];
        }
            break;
        case 2:
        {
            HTextViewCell *cell = itemBlock(HTextViewCell.class);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            [cell.label setText:@"昵称"];
            [cell.label setFont:[UIFont systemFontOfSize:14]];
        }
            break;
            
        default:
        {
            HTextViewCell *cell = itemBlock(HTextViewCell.class);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.label setBackgroundColor:[UIColor redColor]];
        }
            break;
    }
}

@end
