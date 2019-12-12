//
//  HTableRefresh.m
//  QFProj
//
//  Created by dqf on 2019/6/19.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTableRefresh.h"

@implementation HTableRefresh
+ (MJRefreshHeader *)refreshHeaderWithStyle:(HTableRefreshHeaderStyle)style andBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    switch (style) {
        case HTableRefreshHeaderStyleGray: {
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
            header.automaticallyChangeAlpha = YES;
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
            header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            return header;
        }
            break;
        case HTableRefreshHeaderStyleWhite: {
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
            header.automaticallyChangeAlpha = YES;
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
            header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            return header;
        }
            break;
        default: {
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
            header.automaticallyChangeAlpha = YES;
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
            header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            return header;
        }
            break;
    }
}
+ (MJRefreshFooter *)refreshFooterWithStyle:(HTableRefreshFooterStyle)style andBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    switch (style) {
        case HTableRefreshFooterStyle1: {
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];
            [footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
            [footer setTitle:@"" forState:MJRefreshStateIdle];
            footer.refreshingTitleHidden = YES;
            return footer;
        }
            break;
        case HTableRefreshFooterStyle2: {
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];
            [footer setTitle:@"我们也是有底线的" forState:MJRefreshStateNoMoreData];
            [footer setTitle:@"" forState:MJRefreshStateIdle];
            footer.refreshingTitleHidden = YES;
            return footer;
        }
            break;
        default: {
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];
            [footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
            [footer setTitle:@"" forState:MJRefreshStateIdle];
            footer.refreshingTitleHidden = YES;
            return footer;
        }
            break;
    }
}
@end
