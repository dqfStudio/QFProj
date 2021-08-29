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
- (UIEdgeInsets)insetForSection:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 2;
}
- (UIEdgeInsets)edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return UIEdgeInsetsMake(5, 5, 5, 5);
            break;
        case 1:
            return UIEdgeInsetsZero;
            break;
            
        default:
            break;
    }
    return UIEdgeInsetsZero;
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return CGSizeMake(135, self.tupleView.height);
            break;
        case 1:
            return CGSizeMake(self.tupleView.width-135, self.tupleView.height);
            break;
            
        default:
            break;
    }
    return CGSizeMake(self.tupleView.width, self.tupleView.height);
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            cell.backgroundColor = UIColor.blackColor;
            [cell setCornerRadius:cell.viewHeight/2];
            
            CGRect frame = [cell layoutViewBounds];
            
            HRect *tmpFrame = HRectFor(frame);
            tmpFrame.width = tmpFrame.height;
            cell.imageView.frame = tmpFrame.frame;
            cell.imageView.backgroundColor = UIColor.redColor;
            [cell.imageView setFillet:YES];
            [cell.imageView setImageWithName:@"icon_no_server"];
            
            
            HRect *tmpFrame2 = HRectFor(frame);
            tmpFrame2.x = tmpFrame2.width - 40;
            tmpFrame2.width = 40;
            
            cell.buttonView.frame = tmpFrame2.frame;
            cell.buttonView.backgroundColor = UIColor.redColor;
            [cell.buttonView setTitle:@"关注"];
            [cell.buttonView setTitleColor:UIColor.whiteColor];
            [cell.buttonView setFont:[UIFont systemFontOfSize:12.f]];
            [cell.buttonView setCornerRadius:cell.buttonView.viewHeight/2];
            
            
            HRect *tmpFrame3 = HRectFor(frame);
            tmpFrame3.x = tmpFrame.width + 5;
            tmpFrame3.width -= tmpFrame.width + tmpFrame2.width + 10;
            tmpFrame3.height /= 2;
            
            cell.label.frame = tmpFrame3.frame;
            cell.label.font = [UIFont boldSystemFontOfSize:9.f];
            cell.label.textAlignment = NSTextAlignmentLeft;
            cell.label.textColor = UIColor.whiteColor;
            cell.label.text = @"游客 56738";
            
            HRect *tmpFrame4 = HRectFor(tmpFrame3.frame);
            tmpFrame4.y = tmpFrame4.height;
            cell.detailLabel.frame = tmpFrame4.frame;
            cell.detailLabel.font = [UIFont boldSystemFontOfSize:9.f];
            cell.detailLabel.textAlignment = NSTextAlignmentLeft;
            cell.detailLabel.textColor = UIColor.whiteColor;
            cell.detailLabel.text = @"ID 56738";
            
        }
            break;
        case 1: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            cell.label.font = [UIFont boldSystemFontOfSize:14.f];
            cell.label.textAlignment = NSTextAlignmentCenter;
            cell.label.textColor = HColorHex(#0B0A0C);
            //cell.label.text = @"top bar";
        }
            break;
            
        default:
            break;
    }
}
@end

@implementation HLiveRoomCell (HSection0)
- (NSInteger)tupleExa0_numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)tupleExa0_sizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.liveRightView.width, UIScreen.statusBarHeight+5);
}
- (CGSize)tupleExa0_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.liveRightView.width, 35);
}
- (void)tupleExa0_tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    HTupleBaseApex *cell = headerBlock(nil, HTupleBaseApex.class, nil, YES);
    [cell setBackgroundColor:UIColor.clearColor];
}
- (void)tupleExa0_tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    itemBlock(nil, HLiveRoomTopBarCell.class, nil, YES);
}
@end
