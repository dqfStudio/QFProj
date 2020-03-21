//
//  HMainController1.m
//  QFProj
//
//  Created by dqf on 2019/9/4.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HMainController1.h"

@interface HMainController1 ()

@end

@implementation HMainController1

- (HTupleView *)tupleView {
    if (!_tupleView) {
        CGRect frame = UIScreen.bounds;
        frame.origin.y += UIScreen.topBarHeight;
        frame.size.height -= UIScreen.topBarHeight;
        _tupleView = [HTupleView tupleFrame:^CGRect{
            return frame;
        } exclusiveSections:^NSArray *_Nullable{
            return nil;
        }];
    }
    return _tupleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.leftNaviButton setHidden:YES];
    [self setTitle:@"第一页"];
    [self.tupleView setTupleDelegate:(id<HTupleViewDelegate>)self];
    [self.view addSubview:self.tupleView];
//    dispatchAfter(5.0, ^{
//        self.tupleView.tupleState = HMainCtrl1Type2;
//        [self.tupleView reloadData];
//        [self.tupleView stopOpacityForeverAnimation];
//    });
//    [self.tupleView startOpacityForeverAnimation];
    dispatchAfter(1.0, ^{
        [self.tupleView showLoader];
        dispatchAfter(5.0, ^{
            [self.tupleView hideLoader];
            self.tupleView.tupleState = HMainCtrl1Type2;
        });
    });
}

- (void)vcWillDisappear:(HVCDisappearType)type {
    if (type == HVCDisappearTypePop || type == HVCDisappearTypeDismiss) {
        [self.tupleView releaseTupleBlock];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect frame = self.view.bounds;
    frame.origin.y += UIScreen.topBarHeight;
    frame.size.height -= UIScreen.topBarHeight;
    _tupleView.frame = frame;
}

@end
