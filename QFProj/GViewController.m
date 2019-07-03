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
        _tupleView = [[HTupleView alloc] initWithFrame:frame collectionViewLayout:UICollectionViewFlowLayout.new];
        [_tupleView setTupleDelegate:self];
        [_tupleView setBackgroundColor:[UIColor yellowColor]];
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

- (NSInteger)numberOfSectionsInTupleView:(UICollectionView *)tupleView {
//    return 2;
    return 1;
}

- (NSInteger)tupleView:(UICollectionView *)tupleView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
//            return 10;
            return 1;
            break;
        case 1:
            return 3;
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                return CGSizeMake(CGRectGetWidth(tupleView.frame)-20, 50);
            }else {
                return CGSizeMake(CGRectGetWidth(tupleView.frame)/4-20/4, CGRectGetWidth(tupleView.frame)/4-20/4);
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                return CGSizeMake(CGRectGetWidth(tupleView.frame)-20, 50);
            }else {
                return CGSizeMake(CGRectGetWidth(tupleView.frame)/2-20/2, CGRectGetWidth(tupleView.frame)/2-20/2);
            }
            break;
            
        default:
            break;
    }
    return CGSizeZero;
}
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (void)tupleView:(UICollectionView *)tupleView itemTuple:(HItemTuple)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
            /********************************section == 0*************************************/
        case 0:
        {
            switch (indexPath.row) {
                case 0:{
                    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor clearColor]];
//                    [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
                    [cell.label setBackgroundColor:[UIColor greenColor]];
                    [cell.label setTextAlignment:NSTextAlignmentCenter];
                    [cell.label setText:@"+86655655555555553"];
                    [cell.label setFont:[UIFont systemFontOfSize:24]];
                    [cell.label setTextColor:[UIColor redColor]];
                }
                    break;
                case 1:
                {
                    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor clearColor]];
                    [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
                    [cell.label setTextAlignment:NSTextAlignmentCenter];
//                    [cell.label setText:@"+86"];
                    [cell.label setFont:[UIFont systemFontOfSize:14]];
                }
                    break;
                case 2:
                {
                    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor clearColor]];
                    [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
                    [cell.label setTextAlignment:NSTextAlignmentCenter];
//                    [cell.label setText:@"昵称"];
                    [cell.label setFont:[UIFont systemFontOfSize:14]];
                    [cell.label setTextColor:[UIColor blackColor]];
                }
                    break;
                case 3:
                {
                    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor clearColor]];
                    [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
                    [cell.label setTextAlignment:NSTextAlignmentCenter];
//                    [cell.label setText:@"昵称"];
                    [cell.label setFont:[UIFont systemFontOfSize:14]];
                    [cell.label setTextColor:[UIColor blackColor]];
                }
                    break;
                case 4:
                {
                    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor lightGrayColor]];
                    [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
                    [cell.label setTextAlignment:NSTextAlignmentCenter];
//                    [cell.label setText:@"昵称"];
                    [cell.label setFont:[UIFont systemFontOfSize:14]];
                    [cell.label setTextColor:[UIColor blackColor]];
                }
                    break;
                case 5:
                {
                    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor clearColor]];
                    [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
                    [cell.label setTextAlignment:NSTextAlignmentCenter];
//                    [cell.label setText:@"昵称"];
                    [cell.label setFont:[UIFont systemFontOfSize:14]];
                    [cell.label setTextColor:[UIColor blackColor]];
                }
                    break;
                case 6:
                {
                    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor clearColor]];
                    [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
                    [cell.label setTextAlignment:NSTextAlignmentCenter];
//                    [cell.label setText:@"昵称"];
                    [cell.label setFont:[UIFont systemFontOfSize:14]];
                    [cell.label setTextColor:[UIColor blackColor]];
                }
                    break;
                case 7:
                {
                    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor greenColor]];
                    [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
                    [cell.label setTextAlignment:NSTextAlignmentCenter];
//                    [cell.label setText:@"昵称"];
                    [cell.label setFont:[UIFont systemFontOfSize:14]];
                    [cell.label setTextColor:[UIColor blackColor]];
                }
                    break;
                case 8:
                {
                    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor yellowColor]];
                    [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
                    [cell.label setTextAlignment:NSTextAlignmentCenter];
//                    [cell.label setText:@"昵称"];
                    [cell.label setFont:[UIFont systemFontOfSize:14]];
                    [cell.label setTextColor:[UIColor blackColor]];
                }
                    break;
                case 9:
                {
                    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor redColor]];
                    [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
                    [cell.label setTextAlignment:NSTextAlignmentCenter];
//                    [cell.label setText:@"昵称"];
                    [cell.label setFont:[UIFont systemFontOfSize:14]];
                    [cell.label setTextColor:[UIColor blackColor]];
                }
                    break;
                case 10:
                {
                    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor blueColor]];
                    [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
                    [cell.label setTextAlignment:NSTextAlignmentCenter];
//                    [cell.label setText:@"昵称"];
                    [cell.label setFont:[UIFont systemFontOfSize:14]];
                    [cell.label setTextColor:[UIColor blackColor]];
                }
                    break;
                case 11:
                {
                    HTupleButtonCell *cell = itemBlock(nil, HTupleButtonCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor blackColor]];
                    //            [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
                    //            [cell.label setTextAlignment:NSTextAlignmentCenter];
                    //            [cell.label setText:@"昵称"];
                    //            [cell.label setFont:[UIFont systemFontOfSize:14]];
                    //            [cell.label setTextColor:[UIColor blackColor]];
                }
                    break;
                    
                default:
                {
                    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor clearColor]];
                    [cell.label setBackgroundColor:[UIColor redColor]];
                    NSLog(@"%@",@(indexPath.row));
                    //NSString *str = [NSString stringWithFormat:@"%@",@(indexPath.row)];
//                    [cell.label setText:str];
                    [cell.label setTextColor:[UIColor blackColor]];
                }
                    break;
            }
        }
            break;
            /********************************section == 1*************************************/
        case 1:
        {
            switch (indexPath.row) {
                case 0:{
                    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor clearColor]];
                    [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
                    [cell.label setTextAlignment:NSTextAlignmentCenter];
//                    [cell.label setText:@"+86"];
                    [cell.label setFont:[UIFont systemFontOfSize:14]];
                }
                    break;
                case 1:{
                    HTupleImageCell *cell = itemBlock(nil, HTupleImageCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor clearColor]];
                }
                    break;
                case 2:
                {
//                    HTupleDoubleImageCell *cell = itemBlock(HTupleDoubleImageCell.class);
//                    [cell setBackgroundColor:[UIColor clearColor]];
                    HTupleImageCell *cell = itemBlock(nil, HTupleImageCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor clearColor]];
                }
                    break;
                    
                default:
                {
                    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                    [cell setBackgroundColor:[UIColor clearColor]];
                    [cell.label setBackgroundColor:[UIColor redColor]];
                    NSLog(@"%@",@(indexPath.row));
                    //NSString *str = [NSString stringWithFormat:@"%@",@(indexPath.row)];
//                    [cell.label setText:str];
                    [cell.label setTextColor:[UIColor blackColor]];
                }
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

@end
