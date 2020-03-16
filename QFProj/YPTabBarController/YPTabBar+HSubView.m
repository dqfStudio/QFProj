//
//  YPTabBar+HSubView.m
//  QFProj
//
//  Created by dqf on 2018/11/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
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
    if (UIScreen.isIPhoneX) {
        CGRect frame = self.bounds;
        frame.origin.y = frame.size.height;
        frame.size.height = UIScreen.bottomBarHeight;
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

//
////YPTabItem.m中updateFrameOfSubviews方法修改为
//
//- (void)updateFrameOfSubviews {
//    if ([self imageForState:UIControlStateNormal] && self.contentHorizontalCenter) {
//
//        CGRect rect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
//                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                      attributes:@{NSFontAttributeName : self.titleLabel.font}
//                                                         context:nil];
//        CGSize titleSize = CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
//        CGSize imageSize = self.imageView.frame.size;
//
//        /*
//        //原本方法图片不居中
//        self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//
//        self.imageEdgeInsets = UIEdgeInsetsMake(self.marginTop, (self.frame.size.width - imageSize.width) / 2, 0, 0);
//        CGFloat left = (self.frame.size.width - titleSize.width) / 2 - imageSize.width;
//        self.titleEdgeInsets = UIEdgeInsetsMake(self.marginTop + imageSize.width + self.spacing, left, 0, 0);
//        */
//
//        //以下为新添加方法
//        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//
//        CGFloat totalHeight = (imageSize.height + titleSize.height + self.spacing);
//        self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height - self.marginTop), (self.frame.size.width - imageSize.width) / 2, 0, 0);
//        self.titleEdgeInsets = UIEdgeInsetsMake(self.marginTop, - imageSize.width,- (totalHeight - titleSize.height), 0);
//
//    }else {
//        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        self.imageEdgeInsets = UIEdgeInsetsZero;
//        self.titleEdgeInsets = UIEdgeInsetsZero;
//    }
//}
