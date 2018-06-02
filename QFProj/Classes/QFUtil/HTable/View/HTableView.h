//
//  HTableView.h
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTableModel.h"
#import "NSObject+selector.h"
#import "HSectionModel.h"
#import "HBaseHeaderFooterView.h"
#import "HBaseCell.h"
#import "HTableSignal.h"
#import "MJRefresh.h"

typedef void (^HRefreshBlock)(void);
typedef void (^HLoadMoreBlock)(void);
typedef void(^HCellInitBlock)(id cell);
typedef void(^HCHeaderFooterInitBlock)(id view);

/**
 *  HTableView implements some methods in UITableViewDelegate & UITableViewDataSource.
 *  it can be used as the delegate & dataSource of a tableView.
 *  For those methods it doesn't implement, you can implement them in its subclass.
 */
@interface HTableView : UITableView

@property (nonatomic, assign) NSUInteger pageNo;    // page number, default 1
@property (nonatomic, assign) NSUInteger pageSize;  // page size, default 20

@property (nonatomic, copy) HRefreshBlock  refreshBlock;   // block to refresh data
@property (nonatomic, copy) HLoadMoreBlock loadMoreBlock;  // block to load more data

- (void)reloadModel;

//clear all model
- (void)clearModel;

//begin refresh
- (void)beginRefresh;

//stop refresh
- (void)endRefresh;

#pragma --mark register cell

- (id)registerCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath;


- (id)registerCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath style:(UITableViewCellStyle)style;
- (id)registerCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier;
- (id)registerCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath initBlock:(HCellInitBlock)block;


- (id)registerCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath style:(UITableViewCellStyle)style initBlock:(HCellInitBlock)block;
- (id)registerCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier initBlock:(HCellInitBlock)block;
- (id)registerCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


- (id)registerCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier initBlock:(HCellInitBlock)block;


- (id)registerHeader:(Class)cellClass section:(NSInteger)section;
- (id)registerHeader:(Class)cellClass section:(NSInteger)section initBlock:(HCHeaderFooterInitBlock)block;
- (id)registerHeader:(Class)cellClass section:(NSInteger)section reuseIdentifier:(NSString *)reuseIdentifier initBlock:(HCHeaderFooterInitBlock)block;


- (id)registerFooter:(Class)cellClass section:(NSInteger)section;
- (id)registerFooter:(Class)cellClass section:(NSInteger)section initBlock:(HCHeaderFooterInitBlock)block;
- (id)registerFooter:(Class)cellClass section:(NSInteger)section reuseIdentifier:(NSString *)reuseIdentifier initBlock:(HCHeaderFooterInitBlock)block;

#pragma --mark register cell

- (void)refreshView:(id)object withArr:(NSArray *)arr;

- (void)loadView:(id)object withArr:(NSArray *)arr;

- (void)cellAtIndexPath:(NSIndexPath *)indexPath resetHeight:(NSInteger)height;

@end

@interface UITableView ()

@property (nonatomic, copy) HTableCellSignalBlock signalBlock;

- (void)signalToTable:(HTableSignal *)signal;

- (void)signalToAllItems:(HTableSignal *)signal;
- (void)signal:(HTableSignal *)signal itemSection:(NSInteger)section;
- (void)signal:(HTableSignal *)signal indexPath:(NSIndexPath *)indexPath;

- (void)signalToAllHeader:(HTableSignal *)signal;
- (void)signal:(HTableSignal *)signal headerSection:(NSInteger)section;

- (void)signalToAllFooter:(HTableSignal *)signal;
- (void)signal:(HTableSignal *)signal footerSection:(NSInteger)section;

@end

@interface NSArray (HTableView)
- (NSArray *(^)(NSArray *))linkCell;
- (void (^)(NSUInteger section, NSString *sectionModel))setSectionModel;
@end

@interface NSString (HTableView)
- (NSArray *(^)(NSUInteger))multiple;
@end
