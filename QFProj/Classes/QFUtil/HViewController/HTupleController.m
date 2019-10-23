//
//  HTupleController.m
//  QFProj
//
//  Created by dqf on 2019/7/7.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleController.h"

@interface HTupleController ()

@end

@implementation HTupleController
- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:CGRectZero];
    }
    return _tupleView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _autoLayout = YES;
    _topExtendedLayout = YES;
    _bottomExtendedHeight = 0.f;
    if (UIDevice.isIPhoneX) {
        _extendedInset = UIEdgeInsetsMake(0, 0, UIDevice.bottomBarHeight, 0);
    }
    [self.view addSubview:self.tupleView];
}
- (void)vcWillDisappear:(HVCDisappearType)type {
    if (type == HVCDisappearTypePop || type == HVCDisappearTypeDismiss) {
        [self.tupleView releaseTupleBlock];
    }
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (_autoLayout) {//默认为YES
        CGRect frame = self.view.bounds;
        if (_topExtendedLayout) {//默认为YES
            frame.origin.y += UIDevice.topBarHeight;
            frame.size.height -= UIDevice.topBarHeight;
        }
        frame.size.height -= _bottomExtendedHeight;
        [_tupleView setFrame:frame];
        if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, _extendedInset)) {//设置过值
            if (!UIEdgeInsetsEqualToEdgeInsets(_tupleView.contentInset, _extendedInset)) {//设置的值与现有的值不相等
                [_tupleView setContentInset:_extendedInset];
            }
        }
    }
}
@end
