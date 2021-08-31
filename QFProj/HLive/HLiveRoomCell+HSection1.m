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
@property (nonatomic) NSMutableArray *mutableArr;
@end

@implementation HLiveRoomMiddleBarView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.tupleView setTupleDelegate:self];
        [self addSubview:self.tupleView];
        self.mutableArr = NSMutableArray.array;
        for (int i=0; i<5; i++) {
            NSString *string = [@"黑客帝国" stringByAppendingFormat:@"%d", i];
            [self.mutableArr addObject:string];
        }
        NSTimer *timer = [NSTimer timerWithTimeInterval:2.f repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSString *string = [@"黑客帝国" stringByAppendingFormat:@"%lu", self.mutableArr.count];
            [self.mutableArr addObject:string];
            [self.tupleView reloadData];
        }];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    return self;
}
- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds];
        _tupleView.backgroundColor = UIColor.clearColor;
        [_tupleView verticalBounceEnabled];
        //将tupleView倒置
        _tupleView.transform = CGAffineTransformMakeScale (1,-1);
    }
    return _tupleView;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.mutableArr.count;
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.tupleView.width, 25);
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HTupleNoteCell *cell = itemBlock(nil, HTupleNoteCell.class, nil, YES);
    //将cell.contentView倒置
    cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
    [cell addTopLineWithSize:1.f color:[UIColor colorWithWhite:0.1 alpha:0.2] paddingLeft:0 paddingRight:20];
    [cell.label setTextColor:UIColor.whiteColor];
    [cell.label setFont:[UIFont systemFontOfSize:12.f]];
    //此处数据源需要倒着加载
    NSInteger index = self.mutableArr.count - 1 - indexPath.row;
    NSString *string = self.mutableArr[index];
    [cell.label setText:string];
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
