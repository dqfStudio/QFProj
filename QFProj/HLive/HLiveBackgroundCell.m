//
//  HLiveBackgroundCell.m
//  QFProj
//
//  Created by Jovial on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLiveBackgroundCell.h"

@implementation HLiveBackgroundCell
//cell初始化是调用的方法
- (void)initUI {
//    [self.imageView setImageWithName:@"live_bg_icon"];
    //添加模态效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _effectView.alpha = 0.9;
    _effectView.frame = self.imageView.bounds;
//    [self.imageView addSubview:_effectView];
}
//用于子类更新子视图布局
- (void)relayoutSubviews {
    HLayoutTableCell(self.imageView)
//    self.effectView.frame = self.imageView.bounds;
}
@end
