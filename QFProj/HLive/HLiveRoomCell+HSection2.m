//
//  HLiveRoomCell+HSection2.m
//  QFProj
//
//  Created by Jovial on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLiveRoomCell+HSection2.h"

@interface HLiveRoomBottomBarCell : HTupleBaseCell <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@end

@implementation HLiveRoomBottomBarCell
- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds scrollDirection:HTupleDirectionHorizontal];
        _tupleView.backgroundColor = UIColor.clearColor;
        [_tupleView bounceDisenable];
    }
    return _tupleView;
}
//cell初始化是调用的方法
- (void)initUI {
    [super initUI];
    self.backgroundColor = UIColor.clearColor;
    [self.tupleView setTupleDelegate:self];
    [self addSubview:self.tupleView];
}
//用于子类更新子视图布局
- (void)relayoutSubviews {
    [super relayoutSubviews];
    HLayoutTableCell(self.tupleView);
}
- (UIEdgeInsets)insetForSection:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 4;
}
- (UIEdgeInsets)edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return UIEdgeInsetsMake(5, 5, 5, 5);
            break;
        case 1:
            return UIEdgeInsetsZero;
            break;
        case 2:
            return UIEdgeInsetsMake(5, 5, 5, 5);
            break;
        case 3:
            return UIEdgeInsetsMake(5, 5, 5, 5);
            break;

        default:
            break;
    }
    return UIEdgeInsetsZero;
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return CGSizeMake(self.tupleView.height, self.tupleView.height);
            break;
        case 1:
            return CGSizeMake(self.tupleView.width-20-self.tupleView.height*3, self.tupleView.height);
            break;
        case 2:
            return CGSizeMake(self.tupleView.height, self.tupleView.height);
            break;
        case 3:
            return CGSizeMake(self.tupleView.height, self.tupleView.height);
            break;
            
        default:
            break;
    }
    return CGSizeMake(self.tupleView.width, self.tupleView.height);
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            HTupleButtonCell *cell = itemBlock(nil, HTupleButtonCell.class, nil, YES);
            cell.buttonView.backgroundColor = UIColor.blackColor;
            [cell.buttonView setCornerRadius:cell.buttonView.viewHeight/2];
        }
            break;
        case 1: {
            itemBlock(nil, HTupleBlankCell.class, nil, YES);
        }
            break;
        case 2: {
            HTupleButtonCell *cell = itemBlock(nil, HTupleButtonCell.class, nil, YES);
            cell.buttonView.backgroundColor = UIColor.blackColor;
            [cell.buttonView setCornerRadius:cell.buttonView.viewHeight/2];
        }
            break;
        case 3: {
            HTupleButtonCell *cell = itemBlock(nil, HTupleButtonCell.class, nil, YES);
            cell.buttonView.backgroundColor = UIColor.blackColor;
            [cell.buttonView setCornerRadius:cell.buttonView.viewHeight/2];
        }
            break;
            
        default:
            break;
    }
}
@end

@implementation HLiveRoomCell (HSection2)
- (NSInteger)tupleExa2_numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)tupleExa2_sizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.liveRightView.width, UIScreen.bottomBarHeight+5);
}
- (CGSize)tupleExa2_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.liveRightView.width, 40);
}
- (void)tupleExa2_tupleFooter:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    HTupleBaseApex *cell = footerBlock(nil, HTupleBaseApex.class, nil, YES);
    [cell setBackgroundColor:UIColor.clearColor];
}
- (void)tupleExa2_tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    itemBlock(nil, HLiveRoomBottomBarCell.class, nil, YES);
}
@end
