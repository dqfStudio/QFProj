//
//  YPTabBar+HSubView.m
//  QFProj
//
//  Created by dqf on 2018/11/20.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "YPTabBar+HSubView.h"

@implementation YPTabBar (HSubView)
//顶部添加分割线
- (void)addTopLineViewWithColor:(UIColor *)color {
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
    UIView *lineView = [self viewWithTag:10101010];
    if (!lineView) {
        lineView = [[UIView alloc] initWithFrame:frame];
        [lineView setBackgroundColor:color];
        [lineView setTag:10101010];
        [self addSubview:lineView];
        [self sendSubviewToBack:lineView];
    }else {
        lineView.frame = frame;
    }
}
//底部添加分割线
- (void)addBottomLineViewWithColor:(UIColor *)color {
    CGRect frame = CGRectMake(0, self.frame.size.height-1, [UIScreen mainScreen].bounds.size.width, 1);
    UIView *lineView = [self viewWithTag:20202020];
    if (!lineView) {
        lineView = [[UIView alloc] initWithFrame:frame];
        [lineView setBackgroundColor:color];
        [lineView setTag:20202020];
        [self addSubview:lineView];
        [self sendSubviewToBack:lineView];
    }else {
        lineView.frame = frame;
    }
}
//添加空白适配
- (void)addBottomBlankViewWithColor:(UIColor *)color {
    if (UIDevice.isIPhoneX) {
        CGRect frame = self.bounds;
        frame.origin.y = frame.size.height;
        frame.size.height = UIDevice.bottomBarHeight;
        UIView *bottomView = [self viewWithTag:30303030];
        if (!bottomView) {
            bottomView = [[UIView alloc] initWithFrame:frame];
            [bottomView setBackgroundColor:color];
            [bottomView setTag:30303030];
            [self addSubview:bottomView];
            self.clipsToBounds = NO;
        }else {
            bottomView.frame = frame;
        }
    }
}
@end
