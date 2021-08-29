//
//  HLiveRoomCell+HSection0.m
//  QFProj
//
//  Created by Jovial on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLiveRoomCell+HSection0.h"

@interface HLiveRoomTopBarCell : HTupleBaseCell <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@end

@implementation HLiveRoomTopBarCell
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
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.tupleView.width, self.tupleView.height);
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
    cell.label.font = [UIFont boldSystemFontOfSize:14.f];
    cell.label.textAlignment = NSTextAlignmentCenter;
    cell.label.textColor = HColorHex(#0B0A0C);
    cell.label.text = @"top bar";
}
@end

@implementation HLiveRoomCell (HSection0)
- (NSInteger)tupleExa0_numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)tupleExa0_sizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.liveRightView.width, UIScreen.statusBarHeight);
}
- (CGSize)tupleExa0_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.liveRightView.width, 50);
}
- (void)tupleExa0_tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    HTupleBaseApex *cell = headerBlock(nil, HTupleBaseApex.class, nil, YES);
    [cell setBackgroundColor:UIColor.clearColor];
}
- (void)tupleExa0_tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HLiveRoomTopBarCell *cell = itemBlock(nil, HLiveRoomTopBarCell.class, nil, YES);
    [cell addBottomLineWithSize:1.f color:[UIColor colorWithWhite:0.1 alpha:0.2] paddingLeft:0 paddingRight:0];
}
@end
