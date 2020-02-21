//
//  YPTabBar+HSubView.h
//  QFProj
//
//  Created by dqf on 2018/11/20.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "YPTabBar.h"
#import "UIDevice+HUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPTabBar (HSubView)
//顶部添加分割线
- (void)addTopLineViewWithColor:(UIColor *)color;
//底部添加分割线
- (void)addBottomLineViewWithColor:(UIColor *)color;
//添加空白适配
- (void)addBottomBlankViewWithColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
