//
//  HTableController.m
//  QFProj
//
//  Created by wind on 2019/7/7.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTableController.h"

@interface HTableController ()

@end

@implementation HTableController
- (HTableView *)tableView {
    if (!_tableView) {
        CGRect frame = self.view.bounds;
        frame.origin.y += UIDevice.topBarHeight;
        frame.size.height -= UIDevice.topBarHeight;
        _tableView = [[HTableView alloc] initWithFrame:frame];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (!CGRectEqualToRect(self.view.frame, _tableView.frame)) {
        CGRect frame = self.view.bounds;
        frame.origin.y += UIDevice.topBarHeight;
        frame.size.height -= UIDevice.topBarHeight;
        [_tableView setFrame:frame];
    }
}
@end
