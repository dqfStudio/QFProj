//
//  HTupleRefresh.m
//  QFProj
//
//  Created by dqf on 2019/6/19.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleRefresh.h"

@implementation HTupleRefresh
+ (id)refreshHeaderWithStyle:(HTupleRefreshHeaderStyle)style andBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    switch (style) {
        case HTupleRefreshHeaderStyleGray: {
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
            header.automaticallyChangeAlpha = YES;
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
            header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            return header;
        }
            break;
        case HTupleRefreshHeaderStyleWhite: {
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
+ (id)refreshFooterWithStyle:(HTupleRefreshFooterStyle)style andBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    switch (style) {
        case HTupleRefreshFooterStyle1: {
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];
            [footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
            [footer setTitle:@"" forState:MJRefreshStateIdle];
            footer.refreshingTitleHidden = YES;
            return footer;
        }
            break;
        case HTupleRefreshFooterStyle2: {
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


+ (id)hRefreshHeaderWithStyle:(HTupleRefreshHeaderStyle)style andBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    switch (style) {
        case HTupleRefreshHeaderStyleGray: {
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
            header.automaticallyChangeAlpha = YES;
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
            header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            return header;
        }
            break;
        case HTupleRefreshHeaderStyleWhite: {
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
+ (id)hRefreshFooterWithStyle:(HTupleRefreshFooterStyle)style andBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    switch (style) {
        case HTupleRefreshFooterStyle1: {
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];
            [footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
            [footer setTitle:@"" forState:MJRefreshStateIdle];
            footer.refreshingTitleHidden = YES;
            return footer;
        }
            break;
        case HTupleRefreshFooterStyle2: {
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
