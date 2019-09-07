//
//  HMainController3.m
//  QFProj
//
//  Created by wind on 2019/9/4.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HMainController3.h"

@interface HMainController3 ()

@end

@implementation HMainController3

- (HTupleView *)tupleView {
    if (!_tupleView) {
        CGRect frame = UIScreen.bounds;
        frame.origin.y += UIDevice.topBarHeight;
        frame.size.height -= UIDevice.topBarHeight;
        _tupleView = [HTupleView sectionDesignWith:frame andSections:3];
        [_tupleView verticalBounceEnabled];
    }
    return _tupleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.leftNaviButton setHidden:YES];
    [self setTitle:@"第三页"];
    [self.tupleView setTupleDelegate:(id<HTupleViewDelegate>)self];
    [self.view addSubview:self.tupleView];
}

@end
