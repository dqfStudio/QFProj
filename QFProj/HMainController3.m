//
//  HMainController3.m
//  QFProj
//
//  Created by dqf on 2019/9/4.
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
        _tupleView = [HTupleView tupleFrame:^CGRect{
            return frame;
        } exclusiveSections:^NSArray * _Nullable{
            return @[@(0),@(1),@(2)];
        }];
    }
    return _tupleView;
}

- (void)vcWillDisappear:(HVCDisappearType)type {
    if (type == HVCDisappearTypePop || type == HVCDisappearTypeDismiss) {
        [self.tupleView releaseTupleBlock];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.leftNaviButton setHidden:YES];
    [self setTitle:@"第三页"];
    [self.tupleView setDelegate:(id<HTupleViewDelegate>)self];
    [self.view addSubview:self.tupleView];
}
- (NSInteger)tuple0_numberOfSectionsInTupleView:(HTupleView *)tupleView {
    return 3;
}
@end
