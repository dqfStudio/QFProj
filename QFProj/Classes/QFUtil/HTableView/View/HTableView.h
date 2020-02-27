//
//  HTableView.h
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTupleHeader.h"
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

//此类用于全工程刷新tableView
@interface HTableAppearance : NSObject
+ (instancetype)appearance;
- (void)enumerateTables:(void (^)(void))completion;
@end

@protocol HTableViewDelegate <NSObject>
@optional
// 常用代理方法
- (NSInteger)numberOfSectionsInTableView;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (CGFloat)heightForHeaderInSection:(NSInteger)section;
- (CGFloat)heightForFooterInSection:(NSInteger)section;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)edgeInsetsForHeaderInSection:(NSInteger)section;
- (UIEdgeInsets)edgeInsetsForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)edgeInsetsForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableHeader:(HTableHeader)headerBlock inSection:(NSInteger)section;
- (void)tableFooter:(HTableFooter)footerBlock inSection:(NSInteger)section;
- (void)tableRow:(HTableRow)rowBlock atIndexPath:(NSIndexPath *)indexPath;

- (void)willDisplayCell:(HTableBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectCell:(HTableBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath;

// UITableViewDataSource
- (nullable NSString *)titleForHeaderInSection:(NSInteger)section;
- (nullable NSString *)titleForFooterInSection:(NSInteger)section;

- (BOOL)canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

// Index
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView;
- (NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;

- (void)commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

// UITableViewDelegate
- (void)willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)willDisplayFooterView:(UIView *)view forSection:(NSInteger)section;
- (void)didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section;

- (CGFloat)estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)estimatedHeightForHeaderInSection:(NSInteger)section;
- (CGFloat)estimatedHeightForFooterInSection:(NSInteger)section;

- (nullable UIView *)viewForHeaderInSection:(NSInteger)section;
- (nullable UIView *)viewForFooterInSection:(NSInteger)section;

// Accessories (disclosures).
- (void)accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

// Selection
- (BOOL)shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)didHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath;

//- (nullable NSIndexPath *)willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//- (nullable NSIndexPath *)willDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

// Editing
- (UITableViewCellEditingStyle)editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (nullable NSString *)titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;

- (nullable NSArray<UITableViewRowAction *> *)editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;

// Swipe actions
- (nullable UISwipeActionsConfiguration *)leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0));
- (nullable UISwipeActionsConfiguration *)trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0));

- (BOOL)shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath;

// Moving/reordering
- (NSIndexPath *)targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;

// Indentation
- (NSInteger)indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender;
- (void)performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender;

// Focus
- (BOOL)canFocusRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)shouldUpdateFocusInContext:(UITableViewFocusUpdateContext *)context;
- (void)didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator;
- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInTableView;

// Spring Loading
- (BOOL)shouldSpringLoadRowAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context API_AVAILABLE(ios(11.0));

// Multiple Selection
- (BOOL)shouldBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath;

- (void)didBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableViewDidEndMultipleSelectionInteraction;

- (nullable UIContextMenuConfiguration *)contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point API_AVAILABLE(ios(13.0));

- (nullable UITargetedPreview *)previewForHighlightingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0));

- (nullable UITargetedPreview *)previewForDismissingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0));

- (void)willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator API_AVAILABLE(ios(13.0));

// UIScrollViewDelegate
- (void)tableScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)tableScrollViewDidZoom:(UIScrollView *)scrollView;

- (void)tableScrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)tableScrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

- (void)tableScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)tableScrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)tableScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)tableScrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

- (nullable UIView *)tableViewForZoomingInScrollView:(UIScrollView *)scrollView;
- (void)tableScrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view;
- (void)tableScrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale;

- (BOOL)tableScrollViewShouldScrollToTop:(UIScrollView *)scrollView;
- (void)tableScrollViewDidScrollToTop:(UIScrollView *)scrollView;

- (void)tableScrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView;
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
@property (nonatomic, copy, nullable) NSString *reloadTableKey; //设置reload的key值

@property (nonatomic, copy, nullable) NSArray *scrollSplitArray; //滚动代理方法的分体设计，默认单体设计
//禁止调用初始化话方法init和new
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
//split设计初始化方法
+ (instancetype)tableFrame:(CGRect (^)(void))frame exclusiveSections:(HTableSectionExclusiveBlock)sections;
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
//根据传入的row和section获取cell或indexPath
- (id (^)(NSInteger row, NSInteger section))cell;
- (id (^)(NSInteger row, NSInteger section))indexPath;
//获取tableView的宽高和大小
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;
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
- (void)signal:(HTableSignal *_Nullable)signal toRow:(NSInteger)row inSection:(NSInteger)section;
//给所有header或单独某个header发送信号
- (void)signalToAllHeader:(HTableSignal *_Nullable)signal;
- (void)signal:(HTableSignal *_Nullable)signal headerSection:(NSInteger)section;
//给所有footer或单独某个footer发送信号
- (void)signalToAllFooter:(HTableSignal *_Nullable)signal;
- (void)signal:(HTableSignal *_Nullable)signal footerSection:(NSInteger)section;
//释放所有信号block
- (void)releaseAllSignal;
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

