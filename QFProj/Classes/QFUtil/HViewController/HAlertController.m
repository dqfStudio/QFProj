//
//  HAlertController.m
//  QFProj
//
//  Created by wind on 2020/3/11.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HAlertController.h"

@interface HAlertController ()

@end

@implementation HAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
    [self.topBar setHidden:YES];
    
    self.tupleView.backgroundColor = HColorHex(#F5F3F5);
    self.tupleView.layer.cornerRadius = 10;
    [self.tupleView setTupleDelegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = CGRectMake(0, 0, 250, 122);
    if (!CGRectEqualToRect(frame, self.tupleView.bounds)) {
        self.tupleView.frame = frame;
        self.tupleView.center = [[UIApplication sharedApplication] getKeyWindow].center;
    }
}

- (void)back {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (NSInteger)numberOfSectionsInTupleView {
    return 1;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 4;
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell0:
            return CGSizeMake(self.tupleView.width, 42.5);
            break;
        case HCell1:
            return CGSizeMake(self.tupleView.width, 35);
            break;
        case HCell2:
            return CGSizeMake(self.tupleView.width, 2);
            break;
        case HCell3:
            return CGSizeMake(self.tupleView.width, 42.5);
            break;
            
        default:
            break;
    }
    return CGSizeZero;
}
- (UIEdgeInsets)edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell0:
            return UIEdgeInsetsMake(0, 15, 2.5, 15);
        case HCell1:
            return UIEdgeInsetsMake(2.5, 15, 0, 15);
        case HCell2:
            return UIEdgeInsetsZero;
        case HCell3:
            return UIEdgeInsetsZero;
            
        default:
            break;
    }
    return UIEdgeInsetsZero;
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell0: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            cell.label.font = [UIFont boldSystemFontOfSize:17.f];
            cell.label.textAlignment = NSTextAlignmentCenter;
            cell.label.textVerticalAlignment = HTextVerticalAlignmentBottom;
            cell.label.textColor = HColorHex(#0B0A0C);
            cell.label.text = @"过期提醒";
        }
            break;
        case HCell1: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            cell.label.font = [UIFont systemFontOfSize:12.f];
            cell.label.textAlignment = NSTextAlignmentCenter;
            cell.label.textVerticalAlignment = HTextVerticalAlignmentTop;
            cell.label.numberOfLines = 0;
            cell.label.textColor = HColorHex(#070507);
            cell.label.text = @"您的会员资格已不足3天，请及时充值!";
        }
            break;
        case HCell2: {
            HTupleBlankCell *cell = itemBlock(nil, HTupleBlankCell.class, nil, YES);
            UIColor *color = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
            cell.view.backgroundColor = color;
        }
            break;
        case HCell3: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            cell.label.font = [UIFont boldSystemFontOfSize:17.f];
            cell.label.textAlignment = NSTextAlignmentCenter;
            cell.label.textColor = HColorHex(#3184DD);
            cell.label.text = @"确定";
        }
            break;
            
        default:
            break;
    }
    
}
- (void)didSelectCell:(HTupleBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == HCell3) {
        [self back];
    }
}

@end

