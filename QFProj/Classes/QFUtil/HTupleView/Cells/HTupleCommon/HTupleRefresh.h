//
//  HTupleRefresh.h
//  QFProj
//
//  Created by dqf on 2019/6/19.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "MJRefresh.h"

typedef NS_ENUM(NSInteger, HTupleRefreshHeaderStyle) {
    HTupleRefreshHeaderStyleGray = 0,
    HTupleRefreshHeaderStyleWhite,
};

typedef NS_ENUM(NSInteger, HTupleRefreshFooterStyle) {
    HTupleRefreshFooterStyle1 = 0,
    HTupleRefreshFooterStyle2,
};

@interface HTupleRefresh : NSObject
+ (MJRefreshHeader *)refreshHeaderWithStyle:(HTupleRefreshHeaderStyle)style andBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
+ (MJRefreshFooter *)refreshFooterWithStyle:(HTupleRefreshFooterStyle)style andBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
@end
