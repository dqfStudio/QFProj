//
//  HLiveRoomCell+HSection2.m
//  QFProj
//
//  Created by Jovial on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLiveRoomCell+HSection2.h"

@implementation HLiveRoomCell (HSection2)
- (NSInteger)tupleExa2_numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)tupleExa2_sizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.liveRightView.width, UIScreen.bottomBarHeight);
}
- (CGSize)tupleExa2_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.liveRightView.width, 50);
}
- (void)tupleExa2_tupleFooter:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    HTupleBaseApex *cell = footerBlock(nil, HTupleBaseApex.class, nil, YES);
    [cell setBackgroundColor:UIColor.clearColor];
}
- (void)tupleExa2_tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
    [cell addTopLineWithSize:1.f color:[UIColor colorWithWhite:0.1 alpha:0.2] paddingLeft:0 paddingRight:0];
    cell.label.font = [UIFont systemFontOfSize:14.f];
    cell.label.textAlignment = NSTextAlignmentCenter;
    cell.label.textColor = HColorHex(#070507);
    cell.label.text = @"bottom bar";
}
@end
