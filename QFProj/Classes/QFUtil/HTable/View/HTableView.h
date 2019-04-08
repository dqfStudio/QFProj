//
//  HTableView.h
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBaseHeaderFooterView.h"
#import "NSObject+HSelector.h"
#import "HBaseCell.h"
#import "HTableSignal.h"
#import "MJRefresh.h"

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

typedef void (^HDidSelectCellBlock)(NSIndexPath *indexPath);

@protocol HTableViewDelegate <NSObject>
@optional
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView headerTuple:(HHeaderTable)headerBlock inSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView footerTuple:(HFooterTable)footerBlock inSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView cellTuple:(HCellTable)cellBlock atIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface HTableView : UITableView <HTableViewDelegate>
@property (nonatomic, weak, nullable) id <HTableViewDelegate> tableDelegate;

@property (nonatomic, assign) NSUInteger pageNo;    // page number, default 1
@property (nonatomic, assign) NSUInteger pageSize;  // page size, default 20

@property (nonatomic, copy, nullable) HRefreshTableBlock  refreshBlock;   // block to refresh data
@property (nonatomic, copy, nullable) HLoadMoreTableBlock loadMoreBlock;  // block to load more data

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (instancetype)initWithFrame:(CGRect)frame sections:(NSInteger)sections;
//block methods
- (void)tableWithSections:(HANumberOfSectionsBlock)sections cells:(HNumberOfCellsBlock)cells;
- (void)headerWithHeight:(HeightForHeaderBlock)height tuple:(HHeaderTableBlock)block;
- (void)footerWithHeight:(HeightForFooterBlock)height tuple:(HFooterTableBlock)block;
- (void)cellWithHeight:(HeightForCellBlock)height tuple:(HCellTableBlock)block;
- (void)didSelectCell:(HDidSelectCellBlock)block;
- (void)deselectCell:(NSIndexPath *)indexPath;
@end

@interface UITableView ()

@property (nonatomic, copy, nullable) HTableCellSignalBlock  signalBlock;

- (void)signalToTable:(HTableSignal *_Nonnull)signal;

- (void)signalToAllCells:(HTableSignal *_Nonnull)signal;
- (void)signal:(HTableSignal *_Nonnull)signal cellSection:(NSInteger)section;
- (void)signal:(HTableSignal *_Nonnull)signal indexPath:(NSIndexPath *)indexPath;

- (void)signalToAllHeader:(HTableSignal *_Nonnull)signal;
- (void)signal:(HTableSignal *_Nonnull)signal headerSection:(NSInteger)section;

- (void)signalToAllFooter:(HTableSignal *_Nonnull)signal;
- (void)signal:(HTableSignal *_Nonnull)signal footerSection:(NSInteger)section;

- (id (^)(NSInteger row, NSInteger section))cell;
- (id (^)(NSInteger row, NSInteger section))indexPath;

- (CGFloat)width;
- (CGFloat)height;
- (NSString *)string;

@end

NS_ASSUME_NONNULL_END
