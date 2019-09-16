//
//  YPTabBar+HSubView.m
//  HProjectModel1
//
//  Created by dqf on 2018/11/20.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "YPTabBar+HSubView.h"

@implementation YPTabBar (HSubView)
//添加分割线
- (void)addTopLineViewWithColor:(UIColor *)color {
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    [lineView setBackgroundColor:color];
    [self addSubview:lineView];
}
//添加空白适配
- (void)addBottomBlankViewWithColor:(UIColor *)color {
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
