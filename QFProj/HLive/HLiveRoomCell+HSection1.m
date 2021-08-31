//
//  HLiveRoomCell+HSection1.m
//  QFProj
//
//  Created by Jovial on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLiveRoomCell+HSection1.h"

@interface HLiveRoomMiddleBarView : UIView <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@end

@implementation HLiveRoomMiddleBarView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.tupleView setTupleDelegate:self];
        [self addSubview:self.tupleView];
    }
    return self;
}
- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds];
        _tupleView.backgroundColor = UIColor.clearColor;
        [_tupleView verticalBounceEnabled];
    }
    return _tupleView;
}
- (UIEdgeInsets)insetForSection:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 12;
}
- (UIEdgeInsets)edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.tupleView.width, 25);
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HTupleNoteCell *cell = itemBlock(nil, HTupleNoteCell.class, nil, YES);
    [cell addBottomLineWithSize:1.f color:[UIColor colorWithWhite:0.1 alpha:0.2] paddingLeft:10 paddingRight:10];
    [cell.label setText:@"黑客帝国"];
    [cell.label setTextColor:UIColor.whiteColor];
    [cell.label setFont:[UIFont systemFontOfSize:12.f]];
}
@end

@implementation HLiveRoomCell (HSection1)
- (UIEdgeInsets)tupleExa1_insetForSection:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (NSInteger)tupleExa1_numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)tupleExa1_sizeForHeaderInSection:(NSInteger)section {
    NSInteger height = UIScreen.height;
    height -= 35*3+18+40;
    height -= 25*12;
    height -= UIScreen.statusBarHeight+5+UIScreen.bottomBarHeight+5;
    return CGSizeMake(self.liveRightView.width, height);
}
- (CGSize)tupleExa1_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.liveRightView.width, 25*12);
}
- (void)tupleExa1_tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    HTupleBaseApex *cell = headerBlock(nil, HTupleBaseApex.class, nil, YES);
    [cell setBackgroundColor:UIColor.clearColor];
}
- (void)tupleExa1_tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HTupleBaseCell *cell = itemBlock(nil, HTupleBaseCell.class, nil, YES);
    HLiveRoomMiddleBarView *bottomBarView = [cell viewWithTag:123456];
    if (!bottomBarView) {
        bottomBarView = [[HLiveRoomMiddleBarView alloc] initWithFrame:cell.bounds];
        [cell addSubview:bottomBarView];
    }
}
@end
