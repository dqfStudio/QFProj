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
#import "NSIndexPath+HUtil.h"
#import "NSObject+HSelector.h"
#import "HTableViewApex.h"
#import "UIScrollView+HEmptyDataSet.h"

typedef NSUInteger HTableState;

NS_ASSUME_NONNULL_BEGIN

typedef void (^HTableRefreshBlock)(void);
typedef void (^HTableLoadMoreBlock)(void);

typedef id _Nonnull (^HTableHeader)(id _Nullable iblk, Class _Nonnull cls, id _Nullable pre, bool idx);
typedef id _Nonnull (^HTableFooter)(id _Nullable iblk, Class _Nonnull cls, id _Nullable pre, bool idx);
typedef id _Nonnull (^HTableCell)(id _Nullable iblk, Class _Nonnull cls, id _Nullable pre, bool idx);

typedef CGFloat (^HANumberOfSectionsBlock)(void);
typedef CGFloat (^HNumberOfCellsBlock)(NSInteger section);

typedef CGFloat (^HeightForHeaderBlock)(NSInteger section);
typedef CGFloat (^HeightForFooterBlock)(NSInteger section);
typedef CGFloat (^HeightForCellBlock)(NSIndexPath *indexPath);

typedef NSArray *_Nullable(^HTableExclusiveForHeaderBlock)(void);
typedef NSArray *_Nullable(^HTableExclusiveForFooterBlock)(void);
typedef NSArray *_Nullable(^HTableExclusiveForCellBlock)(void);

typedef void (^HTableHeaderBlock)(HTableHeader headerBlock, NSInteger section);
typedef void (^HTableFooterBlock)(HTableFooter footerBlock, NSInteger section);
typedef void (^HTableCellBlock)(HTableCell cellBlock, NSIndexPath *indexPath);

typedef void (^HCellWillDisplayBlock)(UITableViewCell *cell, NSIndexPath *indexPath);
typedef void (^HDidSelectCellBlock)(NSIndexPath *indexPath);

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
- (void)tableView:(HTableView *)tableView tableCell:(HTableCell)cellBlock atIndexPath:(NSIndexPath *)indexPath;

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
@property (nonatomic) BOOL needReloadData; //是否需要重新加载数据

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
+ (instancetype)sectionDesignWith:(CGRect)frame andSections:(NSInteger)sections;
+ (instancetype)tableDesignWith:(CGRect (^)(void))frame exclusiveHeaders:(HTableExclusiveForHeaderBlock)headers exclusiveFooters:(HTableExclusiveForFooterBlock)footers exclusiveCells:(HTableExclusiveForCellBlock)cells;
//bounce
- (void)horizontalBounceEnabled;
- (void)verticalBounceEnabled;
- (void)bounceEnabled;
- (void)bounceDisenable;
//block refresh & loadMore
- (void)beginRefreshing:(void (^)(void))completion;
- (void)endRefreshing:(void (^)(void))completion;
- (void)endLoadMore:(void (^)(void))completion;
//register class
- (id)dequeueReusableHeaderWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx section:(NSInteger)section;
- (id)dequeueReusableFooterWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx section:(NSInteger)section;
- (id)dequeueReusableCellWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx idxPath:(NSIndexPath *)idxPath;
//block methods
- (void)tableWithSections:(HANumberOfSectionsBlock)sections cells:(HNumberOfCellsBlock)cells;
- (void)headerWithHeight:(HeightForHeaderBlock)height tableHeader:(HTableHeaderBlock)block;
- (void)footerWithHeight:(HeightForFooterBlock)height tableFooter:(HTableFooterBlock)block;
- (void)cellWithHeight:(HeightForCellBlock)height tableCell:(HTableCellBlock)block;
- (void)cellWillDisplayBlock:(HCellWillDisplayBlock)block;
- (void)didSelectCell:(HDidSelectCellBlock)block;
- (void)deselectCell:(NSIndexPath *)indexPath;
- (void)releaseTableBlock;
@end

@interface HTableView (HSignal)

@property (nonatomic, copy, nullable) HTableCellSignalBlock signalBlock;

- (void)signalToTable:(HTableSignal *_Nullable)signal;

- (void)signalToAllCells:(HTableSignal *_Nullable)signal;
- (void)signal:(HTableSignal *_Nullable)signal cellSection:(NSInteger)section;
- (void)signal:(HTableSignal *_Nullable)signal indexPath:(NSIndexPath *)indexPath;

- (void)signalToAllHeader:(HTableSignal *_Nullable)signal;
- (void)signal:(HTableSignal *_Nullable)signal headerSection:(NSInteger)section;

- (void)signalToAllFooter:(HTableSignal *_Nullable)signal;
- (void)signal:(HTableSignal *_Nullable)signal footerSection:(NSInteger)section;

- (void)releaseAllSignal;

- (id (^)(NSInteger row, NSInteger section))cell;
- (id (^)(NSInteger row, NSInteger section))indexPath;

- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;

@end

@interface HTableView (HState)

@property (nonatomic, assign) HTableState tableState; //set table view different state

- (void)setObject:(id)anObject forKey:(NSString *)aKey;
- (void)setObject:(id)anObject forKey:(NSString *)aKey state:(HTableState)tableState;

- (nullable id)objectForKey:(NSString *)aKey;
- (nullable id)objectForKey:(NSString *)aKey state:(HTableState)tableState;

- (void)removeObjectForKey:(NSString *)aKey;
- (void)removeObjectForKey:(NSString *)aKey state:(HTableState)tableState;

- (void)removeStateObject;
- (void)removeObjectForState:(HTableState)tableState;

- (void)clearTableState;
@end

NS_ASSUME_NONNULL_END

