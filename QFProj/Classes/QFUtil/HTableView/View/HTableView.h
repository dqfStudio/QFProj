//
//  HTableView.h
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTableRefresh.h"
#import "HTableViewCell.h"
#import "HTableViewApex.h"
#import "NSIndexPath+HUtil.h"
#import "NSObject+HSelector.h"
#import "UIScrollView+HEmptyDataSet.h"

typedef NSUInteger HTableState;

NS_ASSUME_NONNULL_BEGIN

typedef void (^HTableRefreshBlock)(void);
typedef void (^HTableLoadMoreBlock)(void);

typedef id _Nonnull (^HTableHeader)(id _Nullable iblk, Class _Nonnull cls, id _Nullable pre, bool idx);
typedef id _Nonnull (^HTableFooter)(id _Nullable iblk, Class _Nonnull cls, id _Nullable pre, bool idx);
typedef id _Nonnull (^HTableRow)(id _Nullable iblk, Class _Nonnull cls, id _Nullable pre, bool idx);

typedef NSArray *_Nullable(^HTableSectionExclusiveBlock)(void);

@class HTableView;

@protocol HTableViewDelegate <NSObject>
@optional
- (NSInteger)numberOfSectionsInTableView:(HTableView *)tableView;
- (NSInteger)tableView:(HTableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (CGFloat)tableView:(HTableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(HTableView *)tableView heightForFooterInSection:(NSInteger)section;
- (CGFloat)tableView:(HTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)tableView:(HTableView *)tableView edgeInsetsForHeaderInSection:(NSInteger)section;
- (UIEdgeInsets)tableView:(HTableView *)tableView edgeInsetsForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)tableView:(HTableView *)tableView edgeInsetsForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(HTableView *)tableView tableHeader:(HTableHeader)headerBlock inSection:(NSInteger)section;
- (void)tableView:(HTableView *)tableView tableFooter:(HTableFooter)footerBlock inSection:(NSInteger)section;
- (void)tableView:(HTableView *)tableView tableRow:(HTableRow)rowBlock atIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(HTableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(HTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface HTableView : UITableView <HTableViewDelegate>
@property (nonatomic, weak, nullable) id <HTableViewDelegate> tableDelegate;

@property (nonatomic, assign) NSUInteger pageNo;    // page number, default 1
@property (nonatomic, assign) NSUInteger pageSize;  // page size, default 20
@property (nonatomic, assign) NSUInteger totalNo;  // total number.

@property (nonatomic, assign) HTableRefreshHeaderStyle refreshHeaderStyle; //refresh header style
@property (nonatomic, assign) HTableRefreshFooterStyle refreshFooterStyle; //load more footer style

@property (nonatomic, copy, nullable) HTableRefreshBlock  refreshBlock;   // block to refresh data
@property (nonatomic, copy, nullable) HTableLoadMoreBlock loadMoreBlock;  // block to load more data

@property (nonatomic, copy, nullable) NSString *releaseTableKey; //设置释放的key值
@property (nonatomic) BOOL needReloadData; //是否需要重新加载数据，默认为NO
@property (nonatomic) BOOL enableReloadNotify; //是否允许监听重新加载通知，默认为NO
//禁止调用初始化话方法init和new
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
//split设计初始化方法
+ (instancetype)tableDesignWith:(CGRect (^)(void))frame exclusiveSections:(HTableSectionExclusiveBlock)sections;
//bounce method
- (void)horizontalBounceEnabled;
- (void)verticalBounceEnabled;
- (void)bounceEnabled;
- (void)bounceDisenable;
//block refresh & loadMore
- (void)beginRefreshing:(void (^)(void))completion;
- (void)endRefreshing:(void (^)(void))completion;
- (void)endLoadMore:(void (^)(void))completion;
//register class method
- (id)dequeueReusableHeaderWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx section:(NSInteger)section;
- (id)dequeueReusableFooterWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx section:(NSInteger)section;
- (id)dequeueReusableCellWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx idxPath:(NSIndexPath *)idxPath;
//release method
- (void)releaseTableBlock;
@end

/// 信号机制分类
@interface HTableView (HSignal)
//tableView持有的信号block
@property (nonatomic, copy, nullable) HTableCellSignalBlock signalBlock;
//给tableView发送信号
- (void)signalToTable:(HTableSignal *_Nullable)signal;
//给所有cell、某个section下的item或单独某个cell发送信号
- (void)signalToAllCells:(HTableSignal *_Nullable)signal;
- (void)signal:(HTableSignal *_Nullable)signal cellSection:(NSInteger)section;
- (void)signal:(HTableSignal *_Nullable)signal indexPath:(NSIndexPath *)indexPath;
//给所有header或单独某个header发送信号
- (void)signalToAllHeader:(HTableSignal *_Nullable)signal;
- (void)signal:(HTableSignal *_Nullable)signal headerSection:(NSInteger)section;
//给所有footer或单独某个footer发送信号
- (void)signalToAllFooter:(HTableSignal *_Nullable)signal;
- (void)signal:(HTableSignal *_Nullable)signal footerSection:(NSInteger)section;
//释放所有信号block
- (void)releaseAllSignal;
//根据传入的row和section获取cell或indexPath
- (id (^)(NSInteger row, NSInteger section))cell;
- (id (^)(NSInteger row, NSInteger section))indexPath;
//获取tableView的宽高和大小
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;
@end

/// split设计数据存储分类
@interface HTableView (HSplitState)
//tableView分体式设计所表示的状态
@property (nonatomic, assign) HTableState tableState;
//向某个状态或当前状态添加一个值
- (void)setObject:(id)anObject forKey:(NSString *)aKey;
- (void)setObject:(id)anObject forKey:(NSString *)aKey state:(HTableState)tableState;
//获取某个状态或当前状态的一个值
- (nullable id)objectForKey:(NSString *)aKey;
- (nullable id)objectForKey:(NSString *)aKey state:(HTableState)tableState;
//删除某个状态或当前状态下的一个值
- (void)removeObjectForKey:(NSString *)aKey;
- (void)removeObjectForKey:(NSString *)aKey state:(HTableState)tableState;
//删除某个状态或当前状态的值
- (void)removeStateObject;
- (void)removeObjectForState:(HTableState)tableState;
//删除所有状态的值
- (void)clearTableState;
@end

NS_ASSUME_NONNULL_END

