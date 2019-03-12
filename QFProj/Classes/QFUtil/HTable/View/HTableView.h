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
#import "NSIndexModel.h"
#import "MJRefresh.h"

typedef void (^HRefreshBlock)(void);
typedef void (^HLoadMoreBlock)(void);
typedef void(^HCellInitBlock)(id cell);
typedef void(^HCHeaderFooterInitBlock)(id view);

typedef id (^HHeaderBlock)(id iblk, Class cls, id pre, bool idx);
typedef id (^HFooterBlock)(id iblk, Class cls, id pre, bool idx);
typedef id (^HItemBlock)(id iblk, Class cls, id pre, bool idx);

typedef CGFloat (^HNumberOfSectionsBlock)(void);
typedef CGFloat (^HNumberOfItemsBlock)(NSInteger section);

typedef CGFloat (^HeightForHeaderBlock)(NSInteger section);
typedef CGFloat (^HeightForFooterBlock)(NSInteger section);
typedef CGFloat (^HeightForItemBlock)(NSIndexPath *indexPath);

typedef void (^HHeaderTableBlock)(HHeaderBlock headerBlock, NSInteger section);
typedef void (^HFooterTableBlock)(HFooterBlock footerBlock, NSInteger section);
typedef void (^HItemTableBlock)(HItemBlock itemBlock, NSIndexPath *indexPath);

typedef void (^HDidSelectItemBlock)(NSIndexPath *indexPath);

@protocol HTableViewDelegate <NSObject>
@optional
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView headerTuple:(HHeaderBlock)headerBlock inSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView footerTuple:(HFooterBlock)footerBlock inSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView itemTuple:(HItemBlock)itemBlock atIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface HTableView : UITableView <HTableViewDelegate>
@property (nonatomic, weak, nullable) id <HTableViewDelegate> tableDelegate;

@property (nonatomic, assign) NSUInteger pageNo;    // page number, default 1
@property (nonatomic, assign) NSUInteger pageSize;  // page size, default 20

@property (nonatomic, copy) HRefreshBlock  refreshBlock;   // block to refresh data
@property (nonatomic, copy) HLoadMoreBlock loadMoreBlock;  // block to load more data

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame;
//block methods
- (void)tableWithSections:(HNumberOfSectionsBlock)sections items:(HNumberOfItemsBlock)items;
- (void)headerWithHeight:(HeightForHeaderBlock)height tuple:(HHeaderTableBlock)block;
- (void)footerWithHeight:(HeightForFooterBlock)height tuple:(HFooterTableBlock)block;
- (void)itemWithHeight:(HeightForItemBlock)height tuple:(HItemTableBlock)block;
- (void)didSelectItem:(HDidSelectItemBlock)block;
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

- (id (^)(NSInteger row, NSInteger section))cell;
- (id (^)(NSInteger row, NSInteger section))indexPath;

- (CGFloat)width;
- (CGFloat)height;
- (NSString *)string;

@end

@interface NSIndexPath (HString)
- (NSString *)string;
@end

