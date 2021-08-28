//
//  HTupleLiveCell.m
//  QFProj
//
//  Created by Jovial on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HTupleLiveCell.h"

@implementation HTupleLiveCell
- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds];
        _tupleView.backgroundColor = UIColor.clearColor;
        [_tupleView bounceDisenable];
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipped)];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [_tupleView addGestureRecognizer:swipeGesture];
    }
    return _tupleView;
}
- (UIView *)liveLeftView {
    if (!_liveLeftView) {
        _liveLeftView = [[UIView alloc] initWithFrame:self.bounds];
        _liveLeftView.backgroundColor = UIColor.clearColor;
        [_liveLeftView setHidden:YES];
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipped)];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [_liveLeftView addGestureRecognizer:swipeGesture];
    }
    return _liveLeftView;
}
//cell初始化是调用的方法
- (void)initUI {
    [super initUI];
    self.backgroundColor = UIColor.clearColor;
    [self.tupleView setTupleDelegate:self];
    [self addSubview:self.tupleView];
    [self addSubview:self.liveLeftView];
}
//用于子类更新子视图布局
- (void)relayoutSubviews {
    [super relayoutSubviews];
    HLayoutTableCell(self.tupleView);
    self.liveLeftView.frame = self.layoutViewBounds;
}

- (void)leftSwipped {
    [UIView animateWithDuration:0.3 animations:^{
        self.tupleView.frame = CGRectMake(0, 0, self.tupleView.viewWidth, self.tupleView.viewHeight);
    } completion:^(BOOL finished) {
        [self.liveLeftView setHidden:YES];
    }];
}

- (void)rightSwipped {
    [UIView animateWithDuration:0.3 animations:^{
        self.tupleView.frame = CGRectMake(self.tupleView.viewWidth, 0, self.tupleView.viewWidth, self.tupleView.viewHeight);
    } completion:^(BOOL finished) {
        [self.liveLeftView setHidden:NO];
    }];
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
            return CGSizeMake(self.tupleView.width, 40);
            break;
        case HCell1:
            return CGSizeMake(self.tupleView.width, 50);
            break;
        case HCell2:
            return CGSizeMake(self.tupleView.width, 50);
            break;
        case HCell3:
            return CGSizeMake(self.tupleView.width, 50);
            break;
            
        default:
            break;
    }
    return CGSizeZero;
}
- (UIEdgeInsets)edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsZero;
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell0: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            [cell addBottomLineWithSize:1.f color:[UIColor colorWithWhite:0.1 alpha:0.2] paddingLeft:0 paddingRight:0];
            cell.label.font = [UIFont boldSystemFontOfSize:17.f];
            cell.label.textAlignment = NSTextAlignmentCenter;
            cell.label.textColor = HColorHex(#0B0A0C);
            cell.label.text = @"过期提醒";
        }
            break;
        case HCell1: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            [cell addBottomLineWithSize:1.f color:[UIColor colorWithWhite:0.1 alpha:0.2] paddingLeft:0 paddingRight:0];
            cell.label.font = [UIFont systemFontOfSize:12.f];
            cell.label.textAlignment = NSTextAlignmentCenter;
            cell.label.numberOfLines = 0;
            cell.label.textColor = HColorHex(#070507);
            cell.label.text = @"您的会员资格已不足3天，请及时充值!";
        }
            break;
        case HCell2: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            [cell addBottomLineWithSize:1.f color:[UIColor colorWithWhite:0.1 alpha:0.2] paddingLeft:0 paddingRight:0];
            cell.label.font = [UIFont systemFontOfSize:12.f];
            cell.label.textAlignment = NSTextAlignmentCenter;
            cell.label.numberOfLines = 0;
            cell.label.textColor = HColorHex(#070507);
            cell.label.text = @"您的会员资格已不足3天，请及时充值!";
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
        
    }
}

@end
