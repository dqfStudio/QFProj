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
        _tupleView = [[HTupleView alloc] initWithFrame:CGRectZero style:HTupleViewStyleSectionColorLayout];
    }
    return _tupleView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _autoLayout = YES;
    _topExtendedLayout = YES;
    _bottomExtendedHeight = 0.f;
    _extendedInset = UIEdgeInsetsZero;
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
        if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, _extendedInset)) {
            if (!UIEdgeInsetsEqualToEdgeInsets(_tupleView.contentInset, _extendedInset)) {
                [_tupleView setContentInset:_extendedInset];
            }
        }
    }
}
@end
