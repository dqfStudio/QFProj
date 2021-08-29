//
//  HLiveRoomBgCell.m
//  QFProj
//
//  Created by dqf on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLiveRoomBgCell.h"

@implementation HLiveRoomBgCell
//cell初始化是调用的方法
- (void)initUI {
    [super initUI];
    [self.imageView setImageWithName:@"live_bg_icon"];
    //添加模态效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _effectView.alpha = 0.9;
    _effectView.frame = self.imageView.bounds;
    [self.imageView addSubview:_effectView];
    //添加转圈等待效果
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
}
//用于子类更新子视图布局
- (void)relayoutSubviews {
    [super relayoutSubviews];
    HLayoutTableCell(self.imageView)
    HLayoutTableCell(self.effectView)
    HLayoutTableCell(self.activityIndicator)
}
@end
