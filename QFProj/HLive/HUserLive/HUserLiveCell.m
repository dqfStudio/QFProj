//
//  HUserLiveCell.m
//  QFProj
//
//  Created by dqf on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HUserLiveCell.h"

@implementation HUserLiveBgCell
//cell初始化是调用的方法
- (void)initUI {
    [super initUI];
    [self.imageView setImageWithName:@"live_bg_icon"];
    //添加模态效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _effectView.alpha = 0.9;
    _effectView.frame = self.imageView.bounds;
    [self.imageView addSubview:_effectView];
    //添加转圈等待效果
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self addSubview:_activityIndicator];
}
//用于子类更新子视图布局
- (void)relayoutSubviews {
    [super relayoutSubviews];
    HLayoutTupleCell(self.imageView)
    HLayoutTupleCell(self.effectView)
    HLayoutTupleCell(self.activityIndicator)
}
@end


@implementation HUserLiveCell
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
    // 隐藏模态效果
    [self.effectView setHidden:YES];
    
    //设置liveRightView release key
    [self.liveRightView setReleaseTupleKey:KLiveRoomReleaseTupleKey];
}
//用于子类更新子视图布局
- (void)relayoutSubviews {
    [super relayoutSubviews];
    HLayoutTableCell(self.liveLeftView);
    HLayoutTableCell(self.liveRightView);
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
