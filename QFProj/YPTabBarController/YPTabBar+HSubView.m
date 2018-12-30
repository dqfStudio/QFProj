//
//  YPTabBar+HSubView.m
//  HProjectModel1
//
//  Created by wind on 2018/11/20.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "YPTabBar+HSubView.h"

#define HIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@implementation YPTabBar (HSubView)

- (void)addBottomViewWithColor:(UIColor *)color {
    if (HIPhoneX) {
        CGRect frame = self.bounds;
        frame.origin.y = frame.size.height;
        frame.size.height = 34;
        UIView *bottomView = [[UIView alloc] initWithFrame:frame];
        [bottomView setBackgroundColor:color];
        [self addSubview:bottomView];
    }
}

@end
