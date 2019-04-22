//
//  HTupleView.h
//  QFProj
//
//  Created by dqf on 2018/5/19.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "HTupleViewCell.h"
#import "NSObject+HSelector.h"
#import "HTupleReusableView.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "ULBCollectionViewFlowLayout.h"

typedef NS_OPTIONS(NSUInteger, HTupleViewScrollDirection) {
    HTupleViewScrollDirectionVertical = 0,
    HTupleViewScrollDirectionHorizontal
};

typedef NS_OPTIONS(NSUInteger, HTupleViewStyle) {
    HTupleViewStyleLeftAlignedLayout = 0,
    HTupleViewStyleSectionColorLayout
};

typedef NSUInteger HTupleState;

NS_ASSUME_NONNULL_BEGIN

typedef void (^HRefreshTupleBlock)(void);
typedef void (^HLoadMoreTupleBlock)(void);

typedef id _Nonnull (^HHeaderTuple)(id _Nullable iblk, Class _Nonnull cls, id _Nullable pre, bool idx);
typedef id _Nonnull (^HFooterTuple)(id _Nullable iblk, Class _Nonnull cls, id _Nullable pre, bool idx);
typedef id _Nonnull (^HItemTuple)(id _Nullable iblk, Class _Nonnull cls, id _Nullable pre, bool idx);

typedef CGFloat (^HUNumberOfSectionsBlock)(void);
typedef CGFloat (^HNumberOfItemsBlock)(NSInteger section);
typedef UIColor *_Nullable(^HColorForSectionBlock)(NSInteger section);

typedef CGSize (^HSizeForHeaderBlock)(NSInteger section);
typedef CGSize (^HSizeForFooterBlock)(NSInteger section);
typedef CGSize (^HSizeForItemBlock)(NSIndexPath *indexPath);

typedef UIEdgeInsets (^HEdgeInsetsForHeaderBlock)(NSInteger section);
typedef UIEdgeInsets (^HEdgeInsetsForFooterBlock)(NSInteger section);
typedef UIEdgeInsets (^HEdgeInsetsForItemBlock)(NSIndexPath *indexPath);

typedef UIEdgeInsets (^HInsetForSectionBlock)(NSInteger section);

typedef void (^HHeaderTupleBlock)(HHeaderTuple headerBlock, NSInteger section);
typedef void (^HFooterTupleBlock)(HFooterTuple footerBlock, NSInteger section);
typedef void (^HItemTupleBlock)(HItemTuple itemBlock, NSIndexPath *indexPath);

typedef void (^HDidSelectItemBlock)(NSIndexPath *indexPath);

@protocol HTupleViewDelegate <NSObject>
@optional
- (NSInteger)numberOfSectionsInTupleView:(UICollectionView *)tupleView;
- (NSInteger)tupleView:(UICollectionView *)tupleView numberOfItemsInSection:(NSInteger)section;
 //style == HTupleViewStyleSectionColorLayout
- (UIColor *)tupleView:(UICollectionView *)tupleView colorForSectionAtIndex:(NSInteger)section;

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForHeaderInSection:(NSInteger)section;
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForFooterInSection:(NSInteger)section;
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForHeaderInSection:(NSInteger)section;
- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView insetForSectionAtIndex:(NSInteger)section;

- (void)tupleView:(UICollectionView *)tupleView headerTuple:(HHeaderTuple)headerBlock inSection:(NSInteger)section;
- (void)tupleView:(UICollectionView *)tupleView footerTuple:(HFooterTuple)footerBlock inSection:(NSInteger)section;
- (void)tupleView:(UICollectionView *)tupleView itemTuple:(HItemTuple)itemBlock atIndexPath:(NSIndexPath *)indexPath;

- (void)tupleView:(UICollectionView *)tupleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface HTupleView : UICollectionView <HTupleViewDelegate, ULBCollectionViewDelegateFlowLayout>
@property (nonatomic, weak, nullable) id <HTupleViewDelegate> tupleDelegate;

@property (nonatomic, assign) NSUInteger pageNo;    // page number, default 1
@property (nonatomic, assign) NSUInteger pageSize;  // page size, default 20
@property (nonatomic, assign) NSUInteger totalNo;  // total number.

@property (nonatomic, copy, nullable) HRefreshTupleBlock  refreshBlock;   // block to refresh data
@property (nonatomic, copy, nullable) HLoadMoreTupleBlock loadMoreBlock;  // block to load more data

- (void)beginRefreshing:(void (^)(void))completion;
- (void)endRefreshing:(void (^)(void))completion;
- (void)endLoadMore:(void (^)(void))completion;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame style:(HTupleViewStyle)style;
- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(HTupleViewScrollDirection)direction;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;
+ (instancetype)sectionDesignWith:(CGRect)frame andSections:(NSInteger)sections;
+ (instancetype)tupleDesignWith:(CGRect)frame;
//block methods
- (void)tupleWithSections:(HUNumberOfSectionsBlock)sections items:(HNumberOfItemsBlock)items color:(HColorForSectionBlock _Nullable )color inset:(HInsetForSectionBlock _Nullable )inset;
- (void)headerWithSize:(HSizeForHeaderBlock)size edgeInsets:(HEdgeInsetsForHeaderBlock)edge tuple:(HHeaderTupleBlock)block;
- (void)footerWithSize:(HSizeForFooterBlock)size edgeInsets:(HEdgeInsetsForFooterBlock)edge tuple:(HFooterTupleBlock)block;
- (void)itemWithSize:(HSizeForItemBlock)size edgeInsets:(HEdgeInsetsForItemBlock)edge tuple:(HItemTupleBlock)block;
- (void)didSelectItem:(HDidSelectItemBlock)block;
@end

@interface UICollectionView ()

@property (nonatomic, assign) HTupleState tupleState; //set tuple view different state
@property (nonatomic, copy, nullable) HTupleCellSignalBlock signalBlock;

- (void)signalToTupleView:(HTupleSignal *_Nullable)signal;

- (void)signalToAllItems:(HTupleSignal *_Nullable)signal;
- (void)signal:(HTupleSignal *_Nullable)signal itemSection:(NSInteger)section;
- (void)signal:(HTupleSignal *_Nullable)signal indexPath:(NSIndexPath *)indexPath;

- (void)signalToAllHeader:(HTupleSignal *_Nullable)signal;
- (void)signal:(HTupleSignal *_Nonnull)signal headerSection:(NSInteger)section;

- (void)signalToAllFooter:(HTupleSignal *_Nullable)signal;
- (void)signal:(HTupleSignal *_Nullable)signal footerSection:(NSInteger)section;

- (id (^)(NSInteger row, NSInteger section))cell;
- (id (^)(NSInteger row, NSInteger section))indexPath;

- (CGFloat)width;
- (CGFloat)height;
- (NSString *)string;

@end

NS_ASSUME_NONNULL_END
