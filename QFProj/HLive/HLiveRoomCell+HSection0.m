//
//  HLiveRoomCell+HSection0.m
//  QFProj
//
//  Created by Jovial on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLiveRoomCell+HSection0.h"

@interface HLiveRoomTopHeaderView : UIView <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@end

@implementation HLiveRoomTopHeaderView
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
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds scrollDirection:HTupleDirectionHorizontal];
        _tupleView.backgroundColor = UIColor.clearColor;
        [_tupleView bounceDisenable];
    }
    return _tupleView;
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
            [cell.buttonView setPressed:^(id sender, id data) {
                NSLog(@"");
            }];
            
            
            HRect *tmpFrame3 = HRectFor(frame);
            tmpFrame3.x = tmpFrame.width + 5;
            tmpFrame3.width -= tmpFrame.width + tmpFrame2.width + 10;
            tmpFrame3.height /= 2;
            
            cell.label.frame = tmpFrame3.frame;
            cell.label.font = [UIFont systemFontOfSize:9.f];
            cell.label.textAlignment = NSTextAlignmentLeft;
            cell.label.textColor = UIColor.whiteColor;
            cell.label.text = @"游客 56738";
            
            HRect *tmpFrame4 = HRectFor(tmpFrame3.frame);
            tmpFrame4.y = tmpFrame4.height;
            cell.detailLabel.frame = tmpFrame4.frame;
            cell.detailLabel.font = [UIFont systemFontOfSize:9.f];
            cell.detailLabel.textAlignment = NSTextAlignmentLeft;
            cell.detailLabel.textColor = UIColor.whiteColor;
            cell.detailLabel.text = @"ID 56738";
            
        }
            break;
        case 1: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            cell.label.font = [UIFont systemFontOfSize:14.f];
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

@interface HLiveRoomTopHonorView : UIView <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@end

@implementation HLiveRoomTopHonorView
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
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds scrollDirection:HTupleDirectionHorizontal];
        _tupleView.backgroundColor = UIColor.clearColor;
        [_tupleView bounceDisenable];
    }
    return _tupleView;
}
- (UIEdgeInsets)insetForSection:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (UIEdgeInsets)edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(7.5, 5, 7.5, 5);
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return CGSizeMake(100, self.tupleView.height);
            break;
        case 1:
            return CGSizeMake(100, self.tupleView.height);
            break;
        case 2:
            return CGSizeMake(self.tupleView.width-200-20, self.tupleView.height);
            break;
            
        default:
            break;
    }
    return CGSizeMake(self.tupleView.width, self.tupleView.height);
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            HTupleViewCellHoriValue3 *cell = itemBlock(nil, HTupleViewCellHoriValue3.class, nil, YES);
            cell.layoutView.backgroundColor = UIColor.blackColor;
            [cell.layoutView setCornerRadius:cell.layoutView.viewHeight/2];
            
            cell.label.font = [UIFont systemFontOfSize:10.f];
            cell.label.textAlignment = NSTextAlignmentRight;
            cell.label.textColor = UIColor.whiteColor;
            cell.label.text = @"魅力值 202";

            cell.detailWidth = 20;
            cell.detailLabel.font = [UIFont systemFontOfSize:18.f];
            cell.detailLabel.textAlignment = NSTextAlignmentRight;
            cell.detailLabel.textColor = UIColor.whiteColor;
            cell.detailLabelInsets = UILREdgeInsetsMake(0, 5);
            [cell.detailLabel setTextVerticalAlignment:HTextVerticalAlignmentBottom];
            cell.detailLabel.text = @"›";
        }
            break;
        case 1: {
            HTupleViewCellHoriValue3 *cell = itemBlock(nil, HTupleViewCellHoriValue3.class, nil, YES);
            cell.layoutView.backgroundColor = UIColor.blackColor;
            [cell.layoutView setCornerRadius:cell.layoutView.viewHeight/2];
            
            cell.label.font = [UIFont systemFontOfSize:10.f];
            cell.label.textAlignment = NSTextAlignmentRight;
            cell.label.textColor = UIColor.whiteColor;
            cell.label.text = @"守护 虚位以待";

            cell.detailWidth = 18;
            cell.detailLabel.font = [UIFont systemFontOfSize:18.f];
            cell.detailLabel.textAlignment = NSTextAlignmentRight;
            cell.detailLabel.textColor = UIColor.whiteColor;
            cell.detailLabelInsets = UILREdgeInsetsMake(0, 5);
            [cell.detailLabel setTextVerticalAlignment:HTextVerticalAlignmentBottom];
            cell.detailLabel.text = @"›";
        }
            break;
        case 2: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            cell.label.font = [UIFont systemFontOfSize:10.f];
            cell.label.textAlignment = NSTextAlignmentCenter;
            cell.label.textColor = UIColor.whiteColor;
        }
            break;
            
        default:
            break;
    }
}
@end

@implementation HLiveRoomCell (HSection0)
- (NSInteger)tupleExa0_numberOfItemsInSection:(NSInteger)section {
    return 4;
}
- (CGSize)tupleExa0_sizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.liveRightView.width, UIScreen.statusBarHeight+5);
}
- (CGSize)tupleExa0_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return CGSizeMake(self.liveRightView.width, 35);
            break;
        case 1:
            return CGSizeMake(self.liveRightView.width, 35);
            break;
        case 2:
            return CGSizeMake(self.liveRightView.width, 35);
            break;
        case 3:
            return CGSizeMake(self.liveRightView.width, 35);
            break;
            
        default:
            break;
    }
    return CGSizeZero;
}
- (void)tupleExa0_tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    HTupleBaseApex *cell = headerBlock(nil, HTupleBaseApex.class, nil, YES);
    [cell setBackgroundColor:UIColor.clearColor];
}
- (void)tupleExa0_tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            HTupleBaseCell *cell = itemBlock(nil, HTupleBaseCell.class, nil, YES);
            HLiveRoomTopHeaderView *topHeaderView = [cell viewWithTag:123456];
            if (!topHeaderView) {
                topHeaderView = [[HLiveRoomTopHeaderView alloc] initWithFrame:cell.bounds];
                [cell addSubview:topHeaderView];
            }
        }
            break;
        case 1: {
            HTupleBaseCell *cell = itemBlock(nil, HTupleBaseCell.class, nil, YES);
            HLiveRoomTopHonorView *topHonorView = [cell viewWithTag:234567];
            if (!topHonorView) {
                topHonorView = [[HLiveRoomTopHonorView alloc] initWithFrame:cell.bounds];
                [cell addSubview:topHonorView];
            }
        }
            break;
        case 2: {
            HTupleBaseCell *cell = itemBlock(nil, HTupleBaseCell.class, nil, YES);
        }
            break;
        case 3: {
            HTupleBaseCell *cell = itemBlock(nil, HTupleBaseCell.class, nil, YES);
        }
            break;
            
        default:
            break;
    }
}
@end
