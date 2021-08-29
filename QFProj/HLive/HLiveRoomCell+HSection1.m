//
//  HLiveRoomCell+HSection1.m
//  QFProj
//
//  Created by Jovial on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLiveRoomCell+HSection1.h"

@implementation HLiveRoomCell (HSection1)
- (NSInteger)tupleExa1_numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)tupleExa1_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger height = UIScreen.height;
    height -= 50+50;
    height -= UIScreen.statusBarHeight+UIScreen.bottomBarHeight;
    return CGSizeMake(self.liveRightView.width, height);
}
- (void)tupleExa1_tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HTupleBlankCell *cell = itemBlock(nil, HTupleBlankCell.class, nil, YES);
    cell.backgroundColor = UIColor.clearColor;
}
@end
