//
//  HLiveRoomCell.m
//  QFProj
//
//  Created by dqf on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLiveRoomCell.h"

@implementation HLiveRoomCell
- (UIView *)liveLeftView {
    if (!_liveLeftView) {
        _liveLeftView = [[UIView alloc] initWithFrame:self.bounds];
        _liveLeftView.backgroundColor = UIColor.clearColor;
        [_liveLeftView setHidden:YES];
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipped)];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [_liveLeftView addGestureRecognizer:swipeGesture];
    }
    return _liveLeftView;
}
- (HTupleView *)liveRightView {
    if (!_liveRightView) {
        _liveRightView = [HTupleView tupleFrame:^CGRect{
            return self.bounds;
        } exclusiveSections:^NSArray *_Nullable{
            return @[@0, @1, @2];
        }];
        _liveRightView.backgroundColor = UIColor.clearColor;
        [_liveRightView bounceDisenable];
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipped)];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [_liveRightView addGestureRecognizer:swipeGesture];
    }
    return _liveRightView;
}
//cell初始化是调用的方法
- (void)initUI {
    [super initUI];
    self.backgroundColor = UIColor.clearColor;
    [self.liveRightView setTupleDelegate:self];
    [self addSubview:self.liveRightView];
    [self addSubview:self.liveLeftView];
}
//用于子类更新子视图布局
- (void)relayoutSubviews {
    [super relayoutSubviews];
    HLayoutTableCell(self.liveLeftView);
    CGRect frame = self.layoutViewBounds;
    frame.origin.x = 10;
    frame.size.width -= 20;
    self.liveRightView.frame = frame;
}

- (void)leftSwipped {
    [UIView animateWithDuration:0.3 animations:^{
        self.liveRightView.frame = self.liveRightView.bounds;
    } completion:^(BOOL finished) {
        [self.liveLeftView setHidden:YES];
        [self.tuple setScrollEnabled:YES];
    }];
}

- (void)rightSwipped {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.liveRightView.bounds;
        frame.origin.x = self.liveRightView.viewWidth;
        self.liveRightView.frame = frame;
    } completion:^(BOOL finished) {
        [self.liveLeftView setHidden:NO];
        [self.tuple setScrollEnabled:NO];
    }];
}

- (NSInteger)tuple0_numberOfSectionsInTupleView {
    return 3;
}

@end
