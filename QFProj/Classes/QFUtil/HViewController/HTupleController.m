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
    _topExtendedLayout = YES;
    [self.view addSubview:self.tupleView];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect frame = self.view.bounds;
    if (_topExtendedLayout) {//默认为YES
        frame.origin.y += UIDevice.topBarHeight;
        frame.size.height -= UIDevice.topBarHeight;
    }
    if (_bottomExtendedLayout) {//默认为NO
        frame.size.height -= UIDevice.bottomBarHeight;
    }
    [_tupleView setFrame:frame];
}
@end
