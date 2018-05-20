//
//  HTupleView2.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTupleBaseCell.h"
#import "HTupleBaseView.h"

typedef NS_OPTIONS(NSUInteger, HTupleView2ScrollDirection) {
    HTupleView2ScrollDirectionVertical = 0,
    HTupleView2ScrollDirectionHorizontal
};

@protocol HTupleView2Delegate <NSObject>
@optional
- (NSInteger)numberOfSectionsInTupleView:(UIView *)tupleView;
- (NSInteger)tupleView:(UIView *)tupleView numberOfItemsInSection:(NSInteger)section;

- (CGSize)tupleView:(UIView *)tupleView sizeForHeaderInSection:(NSInteger)section;
- (CGSize)tupleView:(UIView *)tupleView sizeForFooterInSection:(NSInteger)section;
- (CGSize)tupleView:(UIView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)tupleView:(UIView *)tupleView edgeInsetsForHeaderInSection:(NSInteger)section;
- (UIEdgeInsets)tupleView:(UIView *)tupleView edgeInsetsForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)tupleView:(UIView *)tupleView edgeInsetsForCellAtIndexPath:(NSIndexPath *)indexPath;

- (void)tupleView:(UIView *)tupleView headerTuple:(id (^)(Class aClass))headerBlock inSection:(NSInteger)section;
- (void)tupleView:(UIView *)tupleView footerTuple:(id (^)(Class aClass))footerBlock inSection:(NSInteger)section;
- (void)tupleView:(UIView *)tupleView cellTuple:(id (^)(Class aClass))cellBlock atIndexPath:(NSIndexPath *)indexPath;

- (void)tupleView:(UIView *)tupleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface HTupleView2 : UICollectionView <HTupleView2Delegate>
@property (nonatomic, weak, nullable) id <HTupleView2Delegate> tupleDelegate;
- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame scrollDirection:(HTupleView2ScrollDirection)direction;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;
@end
