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
#import "NSObject+HSelector.h"
#import "HTableReusableView.h"
#import "UIScrollView+HEmptyDataSet.h"

typedef NSUInteger HTableState;

NS_ASSUME_NONNULL_BEGIN

typedef void (^HRefreshTableBlock)(void);
typedef void (^HLoadMoreTableBlock)(void);

typedef id _Nonnull (^HHeaderTable)(id _Nullable iblk, Class _Nonnull cls, id _Nullable pre, bool idx);
typedef id _Nonnull (^HFooterTable)(id _Nullable iblk, Class _Nonnull cls, id _Nullable pre, bool idx);
typedef id _Nonnull (^HCellTable)(id _Nullable iblk, Class _Nonnull cls, id _Nullable pre, bool idx);

typedef CGFloat (^HANumberOfSectionsBlock)(void);
typedef CGFloat (^HNumberOfCellsBlock)(NSInteger section);

typedef CGFloat (^HeightForHeaderBlock)(NSInteger section);
typedef CGFloat (^HeightForFooterBlock)(NSInteger section);
typedef CGFloat (^HeightForCellBlock)(NSIndexPath *indexPath);

typedef void (^HHeaderTableBlock)(HHeaderTable headerBlock, NSInteger section);
typedef void (^HFooterTableBlock)(HFooterTable footerBlock, NSInteger section);
typedef void (^HCellTableBlock)(HCellTable cellBlock, NSIndexPath *indexPath);

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

- (void)tableView:(HTableView *)tableView headerTuple:(HHeaderTable)headerBlock inSection:(NSInteger)section;
- (void)tableView:(HTableView *)tableView footerTuple:(HFooterTable)footerBlock inSection:(NSInteger)section;
- (void)tableView:(HTableView *)tableView cellTuple:(HCellTable)cellBlock atIndexPath:(NSIndexPath *)indexPath;

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

@property (nonatomic, copy, nullable) HRefreshTableBlock  refreshBlock;   // block to refresh data
@property (nonatomic, copy, nullable) HLoadMoreTableBlock loadMoreBlock;  // block to load more data

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
+ (instancetype)sectionDesignWith:(CGRect)frame andSections:(NSInteger)sections;
+ (instancetype)tupleDesignWith:(CGRect)frame;
//bounce
- (void)horizontalBounceEnabled;
- (void)verticalBounceEnabled;
- (void)bounceEnabled;
- (void)bounceDisenable;
//block refresh & loadMore
- (void)beginRefreshing:(void (^)(void))completion;
- (void)endRefreshing:(void (^)(void))completion;
- (void)endLoadMore:(void (^)(void))completion;
//block methods
- (void)tableWithSections:(HANumberOfSectionsBlock)sections cells:(HNumberOfCellsBlock)cells;
- (void)headerWithHeight:(HeightForHeaderBlock)height tuple:(HHeaderTableBlock)block;
- (void)footerWithHeight:(HeightForFooterBlock)height tuple:(HFooterTableBlock)block;
- (void)cellWithHeight:(HeightForCellBlock)height tuple:(HCellTableBlock)block;
- (void)cellWillDisplayBlock:(HCellWillDisplayBlock)block;
- (void)didSelectCell:(HDidSelectCellBlock)block;
- (void)deselectCell:(NSIndexPath *)indexPath;
@end

@interface HTableView (HSignal)

@property (nonatomic, assign) HTableState tableState; //set table view different state
@property (nonatomic, copy, nullable) HTableCellSignalBlock signalBlock;

- (void)signalToTable:(HTableSignal *_Nullable)signal;

- (void)signalToAllCells:(HTableSignal *_Nullable)signal;
- (void)signal:(HTableSignal *_Nullable)signal cellSection:(NSInteger)section;
- (void)signal:(HTableSignal *_Nullable)signal indexPath:(NSIndexPath *)indexPath;

- (void)signalToAllHeader:(HTableSignal *_Nullable)signal;
- (void)signal:(HTableSignal *_Nullable)signal headerSection:(NSInteger)section;

- (void)signalToAllFooter:(HTableSignal *_Nullable)signal;
- (void)signal:(HTableSignal *_Nullable)signal footerSection:(NSInteger)section;

- (id (^)(NSInteger row, NSInteger section))cell;
- (id (^)(NSInteger row, NSInteger section))indexPath;

- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;
- (NSString *)string;

@end

@interface HTableView (HState)
- (NSInteger)selectedTableStatue;
- (NSInteger)tableTotalState;
- (void)setObject:(id)anObject forKey:(NSString *)aKey tableStatue:(NSInteger)statue;
- (nullable id)objectForKey:(NSString *)aKey tableStatue:(NSInteger)statue;
- (void)removeObjectForKey:(NSString *)aKey tableStatue:(NSInteger)statue;
- (void)removeObjectForTableStatue:(NSInteger)statue;
- (void)clearTableStatue;
@end

NS_ASSUME_NONNULL_END

