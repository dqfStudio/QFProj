//
//  HLiveRoomCell+HSection0.m
//  QFProj
//
//  Created by Jovial on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLiveRoomCell+HSection0.h"

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
    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
    [cell addBottomLineWithSize:1.f color:[UIColor colorWithWhite:0.1 alpha:0.2] paddingLeft:0 paddingRight:0];
    cell.label.font = [UIFont boldSystemFontOfSize:14.f];
    cell.label.textAlignment = NSTextAlignmentCenter;
    cell.label.textColor = HColorHex(#0B0A0C);
    cell.label.text = @"top bar";
}
@end
