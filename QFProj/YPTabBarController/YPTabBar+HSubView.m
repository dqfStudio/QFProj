//
//  YPTabBar+HSubView.m
//  HProjectModel1
//
//  Created by dqf on 2018/11/20.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "YPTabBar+HSubView.h"

@implementation YPTabBar (HSubView)

- (void)addBottomViewWithColor:(UIColor *)color {
    if (UIDevice.isIPhoneX) {
        CGRect frame = self.bounds;
        frame.origin.y = frame.size.height;
        frame.size.height = UIDevice.bottomBarHeight;
        UIView *bottomView = [[UIView alloc] initWithFrame:frame];
        [bottomView setBackgroundColor:color];
        [self addSubview:bottomView];
        self.clipsToBounds = NO;
    }
}

@end
