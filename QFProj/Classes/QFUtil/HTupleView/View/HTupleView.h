//
//  HTupleView.h
//  QFProj
//
//  Created by dqf on 2018/5/19.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTupleHeader.h"
#import "HTupleRefresh.h"
#import "HTupleViewCell.h"
#import "HTupleViewApex.h"
#import "NSIndexPath+HUtil.h"
#import "NSObject+HSelector.h"
#import "UIScrollView+HEmptyDataSet.h"
#import "HCollectionViewFlowLayout.h"

typedef NS_OPTIONS(NSUInteger, HTupleDirection) {
    HTupleDirectionVertical = 0,
    HTupleDirectionHorizontal
};

typedef NSUInteger HTupleState;

NS_ASSUME_NONNULL_BEGIN

typedef void (^HTupleRefreshBlock)(void);
typedef void (^HTupleLoadMoreBlock)(void);

typedef id _Nonnull (^HTupleHeader)(id _Nullable iblk, Class _Nonnull cls, id _Nullable pre, bool idx);
typedef id _Nonnull (^HTupleFooter)(id _Nullable iblk, Class _Nonnull cls, id _Nullable pre, bool idx);
typedef id _Nonnull (^HTupleItem)(id _Nullable iblk, Class _Nonnull cls, id _Nullable pre, bool idx);

typedef NSArray *_Nullable(^HTupleSectionExclusiveBlock)(void);

@class HTupleView;

//此类用于全工程刷新tupleView
@interface HTupleAppearance : NSObject
+ (instancetype)appearance;
- (void)enumerateTuples:(void (^)(void))completion;
@end

@protocol HTupleViewDelegate <UICollectionViewDelegate>
@optional
- (NSInteger)numberOfSectionsInTupleView;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
//layout == HCollectionViewFlowLayout
- (UIColor *)colorForSection:(NSInteger)section;

- (CGSize)sizeForHeaderInSection:(NSInteger)section;
- (CGSize)sizeForFooterInSection:(NSInteger)section;
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)edgeInsetsForHeaderInSection:(NSInteger)section;
- (UIEdgeInsets)edgeInsetsForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)insetForSection:(NSInteger)section;

- (void)tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section;
- (void)tupleFooter:(HTupleFooter)footerBlock inSection:(NSInteger)section;
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath;

- (void)willDisplayCell:(HTupleBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectCell:(HTupleBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@interface HTupleView : UICollectionView <HTupleViewDelegate, HCollectionViewDelegateFlowLayout>
@property (nonatomic, weak, nullable) id <HTupleViewDelegate> delegate;

@property (nonatomic, assign) NSUInteger pageNo;    // page number, default 1
@property (nonatomic, assign) NSUInteger pageSize;  // page size, default 20
@property (nonatomic, assign) NSUInteger totalNo;  // total number.

@property (nonatomic, assign) HTupleRefreshHeaderStyle refreshHeaderStyle; //refresh header style
@property (nonatomic, assign) HTupleRefreshFooterStyle refreshFooterStyle; //load more footer style

@property (nonatomic, copy, nullable) HTupleRefreshBlock  refreshBlock;   // block to refresh data
@property (nonatomic, copy, nullable) HTupleLoadMoreBlock loadMoreBlock;  // block to load more data

@property (nonatomic, copy, nullable) NSString *releaseTupleKey; //设置释放的key值
@property (nonatomic, copy, nullable) NSString *reloadTupleKey; //设置reload的key值
//禁止调用初始化话方法init和new
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
//默认layout为HCollectionViewFlowLayout
- (instancetype)initWithFrame:(CGRect)frame; //默认为垂直滚动方向
- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(HTupleDirection)direction;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;
//split设计初始化方法
+ (instancetype)tupleFrame:(CGRect (^)(void))frame exclusiveSections:(HTupleSectionExclusiveBlock)sections;
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
- (id)dequeueReusableHeaderWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx idxPath:(NSIndexPath *)idxPath;
- (id)dequeueReusableFooterWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx idxPath:(NSIndexPath *)idxPath;
- (id)dequeueReusableCellWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx idxPath:(NSIndexPath *)idxPath;
//release method
- (void)releaseTupleBlock;
@end

/// 信号机制分类
@interface HTupleView (HSignal)
//tupleView持有的信号block
@property (nonatomic, copy, nullable) HTupleCellSignalBlock signalBlock;
//给tupleView发送信号
- (void)signalToTupleView:(HTupleSignal *_Nullable)signal;
//给所有item、某个section下的item或单独某个item发送信号
- (void)signalToAllItems:(HTupleSignal *_Nullable)signal;
- (void)signal:(HTupleSignal *_Nullable)signal itemSection:(NSInteger)section;
- (void)signal:(HTupleSignal *_Nullable)signal toRow:(NSInteger)row inSection:(NSInteger)section;
//给所有header或单独某个header发送信号
- (void)signalToAllHeader:(HTupleSignal *_Nullable)signal;
- (void)signal:(HTupleSignal *_Nonnull)signal headerSection:(NSInteger)section;
//给所有footer或单独某个footer发送信号
- (void)signalToAllFooter:(HTupleSignal *_Nullable)signal;
- (void)signal:(HTupleSignal *_Nullable)signal footerSection:(NSInteger)section;
//释放所有信号block
- (void)releaseAllSignal;
//根据传入的row和section获取cell或indexPath
- (id (^)(NSInteger row, NSInteger section))cell;
- (id (^)(NSInteger row, NSInteger section))indexPath;
//获取tupleView的宽高和大小
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;
//获取某个section的宽高和大小
- (CGFloat (^)(NSInteger section))sectionWidth;
- (CGFloat (^)(NSInteger section))sectionHeigh;
- (CGSize (^)(NSInteger section))sectionSize;
//根据传入的个数和序号计算该item的宽度
- (CGFloat)fixSlitWith:(CGFloat)width colCount:(CGFloat)colCount index:(NSInteger)idx;
@end

/// split设计数据存储分类
@interface HTupleView (HSplitState)
//tupleView分体式设计所表示的状态
@property (nonatomic, assign) HTupleState tupleState;
//向某个状态或当前状态添加一个值
- (void)setObject:(id)anObject forKey:(NSString *)aKey;
- (void)setObject:(id)anObject forKey:(NSString *)aKey state:(HTupleState)tupleState;
//获取某个状态或当前状态的一个值
- (nullable id)objectForKey:(NSString *)aKey;
- (nullable id)objectForKey:(NSString *)aKey state:(HTupleState)tupleState;
//删除某个状态或当前状态下的一个值
- (void)removeObjectForKey:(NSString *)aKey;
- (void)removeObjectForKey:(NSString *)aKey state:(HTupleState)tupleState;
//删除某个状态或当前状态的值
- (void)removeStateObject;
- (void)removeObjectForState:(HTupleState)tupleState;
//删除所有状态的值
- (void)clearTupleState;
@end

NS_ASSUME_NONNULL_END
