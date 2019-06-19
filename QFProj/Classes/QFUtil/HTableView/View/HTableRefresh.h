//
//  HTableRefresh.h
//  QFProj
//
//  Created by wind on 2019/6/19.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "MJRefresh.h"

typedef NS_ENUM(NSInteger, HTableRefreshHeaderStyle) {
    HTableRefreshHeaderStyleGray = 0,
    HTableRefreshHeaderStyleWhite,
};

typedef NS_ENUM(NSInteger, HTableRefreshFooterStyle) {
    HTableRefreshFooterStyle1 = 0,
    HTableRefreshFooterStyle2,
};

@interface HTableRefresh : NSObject
+ (MJRefreshHeader *)refreshHeaderWithStyle:(HTableRefreshHeaderStyle)style andBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
+ (MJRefreshFooter *)refreshFooterWithStyle:(HTableRefreshFooterStyle)style andBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
@end
