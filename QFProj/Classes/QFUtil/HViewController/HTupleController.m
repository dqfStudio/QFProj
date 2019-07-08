//
//  HTupleController.m
//  QFProj
//
//  Created by wind on 2019/7/7.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleController.h"

@interface HTupleController ()

@end

@implementation HTupleController
- (HTupleView *)tupleView {
    if (!_tupleView) {
        CGRect frame = self.view.bounds;
        frame.origin.y += UIDevice.topBarHeight;
        frame.size.height -= UIDevice.topBarHeight;
        _tupleView = [[HTupleView alloc] initWithFrame:frame style:HTupleViewStyleSectionColorLayout];
    }
    return _tupleView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tupleView];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect frame = self.view.bounds;
    frame.origin.y += UIDevice.topBarHeight;
    frame.size.height -= UIDevice.topBarHeight;
    if (!CGRectEqualToRect(frame, _tupleView.frame)) {
        [_tupleView setFrame:frame];
    }
}
@end
