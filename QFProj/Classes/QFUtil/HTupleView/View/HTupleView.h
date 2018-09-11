//
//  HTupleView.h
//  QFProj
//
//  Created by dqf on 2018/5/19.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTupleViewCell.h"
#import "HTupleReusableView.h"
#import "UICollectionViewLeftAlignedLayout.h"

typedef NS_OPTIONS(NSUInteger, HTupleViewScrollDirection) {
    HTupleViewScrollDirectionVertical = 0,
    HTupleViewScrollDirectionHorizontal
};

@protocol HTupleViewDelegate <NSObject>
@optional
- (NSInteger)numberOfSectionsInTupleView:(UICollectionView *)tupleView;
- (NSInteger)tupleView:(UICollectionView *)tupleView numberOfItemsInSection:(NSInteger)section;

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForHeaderInSection:(NSInteger)section;
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForFooterInSection:(NSInteger)section;
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForHeaderInSection:(NSInteger)section;
- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView layout:(UICollectionViewLayout *)layout insetForSectionAtIndex:(NSInteger)section;

- (void)tupleView:(UICollectionView *)tupleView headerTuple:(id (^)(Class aClass))headerBlock inSection:(NSInteger)section;
- (void)tupleView:(UICollectionView *)tupleView footerTuple:(id (^)(Class aClass))footerBlock inSection:(NSInteger)section;
- (void)tupleView:(UICollectionView *)tupleView itemTuple:(id (^)(Class aClass))itemBlock atIndexPath:(NSIndexPath *)indexPath;

- (void)tupleView:(UICollectionView *)tupleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface UICollectionView ()

@property (nonatomic, copy) HTupleCellSignalBlock signalBlock;

- (void)signalToTupleView:(HTupleSignal *)signal;

- (void)signalToAllItems:(HTupleSignal *)signal;
- (void)signal:(HTupleSignal *)signal itemSection:(NSInteger)section;
- (void)signal:(HTupleSignal *)signal indexPath:(NSIndexPath *)indexPath;

- (void)signalToAllHeader:(HTupleSignal *)signal;
- (void)signal:(HTupleSignal *)signal headerSection:(NSInteger)section;

- (void)signalToAllFooter:(HTupleSignal *)signal;
- (void)signal:(HTupleSignal *)signal footerSection:(NSInteger)section;

- (id (^)(NSInteger row, NSInteger section))cell;

@end

@interface HTupleView : UICollectionView <HTupleViewDelegate>
@property (nonatomic, weak, nullable) id <HTupleViewDelegate> tupleDelegate;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(HTupleViewScrollDirection)direction;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;

- (id)headerWithReuseClass:(Class)aClass atIndexPath:(NSIndexPath *)indexPath;
- (id)footerWithReuseClass:(Class)aClass atIndexPath:(NSIndexPath *)indexPath;
- (id)itemWithReuseClass:(Class)aClass atIndexPath:(NSIndexPath *)indexPath;

@end
