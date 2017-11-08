//
//  MGRefreshFooter.m
//  MGMobileMusic
//
//  Created by zhangpeng on 16/12/9.
//  Copyright © 2016年 migu. All rights reserved.
//

#import "MGRefreshFooter.h"

@implementation MGRefreshFooter

- (instancetype)init {
    if (self == [super init]) {
        self.refreshingTitleHidden = YES;
        self.stateLabel.hidden = YES;
    }
    return self;
}

- (void)prepare {
    [super prepare];
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"up_loading0%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    [self setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    [self setTitle:@"" forState:MJRefreshStateIdle];
    [self setTitle:@"" forState:MJRefreshStateRefreshing];
    [self setTitle:@"" forState:MJRefreshStateWillRefresh];
    [self setTitle:@"" forState:MJRefreshStatePulling];
}


@end
