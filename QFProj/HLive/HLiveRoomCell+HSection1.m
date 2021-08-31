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
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 12;
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
    return 3;
}
- (CGSize)tupleExa1_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return CGSizeMake(self.liveRightView.width-20, 60);
            break;
        case 1:
            return CGSizeMake(self.liveRightView.width-20, 60);
            break;
        case 2: {
            NSInteger height = UIScreen.height;
            height -= 35*3+18+40;
            height -= 120;
            height -= UIScreen.statusBarHeight+5+UIScreen.bottomBarHeight+5;
            return CGSizeMake(self.liveRightView.width, height);
        }
            break;
            
        default:
            break;
    }
    return CGSizeZero;
}
- (UIEdgeInsets)tupleExa1_edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return UIEdgeInsetsMake(10, 0, 5, 0);
            break;
        case 1:
            return UIEdgeInsetsMake(5, 0, 10, 0);
            break;
        case 2:
            return UIEdgeInsetsZero;
            break;
            
        default:
            break;
    }
    return UIEdgeInsetsZero;
}
- (void)tupleExa1_tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            HTupleBaseCell *cell = itemBlock(nil, HTupleBaseCell.class, nil, YES);
            HWebButtonView *buttonView = [cell viewWithTag:123456];
            if (!buttonView) {
                HRect *tmpFrame = HRectFor(cell.layoutViewBounds);
                tmpFrame.x = tmpFrame.width - tmpFrame.height;
                tmpFrame.width = tmpFrame.height;
                buttonView = [[HWebButtonView alloc] initWithFrame:tmpFrame.frame];
                [buttonView setBackgroundColor:UIColor.redColor];
                [buttonView setCornerRadius:buttonView.viewWidth/2];
                [buttonView setTag:123456];
                [cell addSubview:buttonView];
                [buttonView setPressed:^(id sender, id data) {
                    NSLog(@"");
                }];
            }
        }
            break;
        case 1: {
            HTupleBaseCell *cell = itemBlock(nil, HTupleBaseCell.class, nil, YES);
            HWebButtonView *buttonView = [cell viewWithTag:123456];
            if (!buttonView) {
                HRect *tmpFrame = HRectFor(cell.layoutViewBounds);
                tmpFrame.x = tmpFrame.width - tmpFrame.height;
                tmpFrame.width = tmpFrame.height;
                buttonView = [[HWebButtonView alloc] initWithFrame:tmpFrame.frame];
                [buttonView setBackgroundColor:UIColor.redColor];
                [buttonView setCornerRadius:buttonView.viewWidth/2];
                [buttonView setTag:123456];
                [cell addSubview:buttonView];
                [buttonView setPressed:^(id sender, id data) {
                    NSLog(@"");
                }];
            }
        }
            break;
        case 2: {
            HTupleBaseCell *cell = itemBlock(nil, HTupleBaseCell.class, nil, YES);
            HLiveRoomMiddleBarView *bottomBarView = [cell viewWithTag:123456];
            if (!bottomBarView) {
                bottomBarView = [[HLiveRoomMiddleBarView alloc] initWithFrame:cell.bounds];
                [bottomBarView setTag:123456];
                [cell addSubview:bottomBarView];
            }
        }
            break;
            
        default:
            break;
    }
}
@end
