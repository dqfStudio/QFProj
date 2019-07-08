//
//  HTableController.m
//  QFProj
//
//  Created by dqf on 2019/7/7.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTableController.h"

@interface HTableController ()

@end

@implementation HTableController
- (HTableView *)tableView {
    if (!_tableView) {
        _tableView = [[HTableView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _autoLayout = YES;
    _topExtendedLayout = YES;
    _bottomExtendedLayout = NO;
    _extendedInset = UIEdgeInsetsZero;
    [self.view addSubview:self.tableView];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (_autoLayout) {//默认为YES
        CGRect frame = self.view.bounds;
        if (_topExtendedLayout) {//默认为YES
            frame.origin.y += UIDevice.topBarHeight;
            frame.size.height -= UIDevice.topBarHeight;
        }
        if (_bottomExtendedLayout) {//默认为NO
            frame.size.height -= UIDevice.bottomBarHeight;
        }
        [_tableView setFrame:frame];
        if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, _extendedInset)) {
            if (!UIEdgeInsetsEqualToEdgeInsets(_tableView.contentInset, _extendedInset)) {
                [_tableView setContentInset:_extendedInset];
            }
        }
    }
}
@end
