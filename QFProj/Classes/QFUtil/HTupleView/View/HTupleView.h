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
- (NSInteger)numberOfSectionsInTupleView:(UIView *)tupleView;
- (NSInteger)tupleView:(UIView *)tupleView numberOfItemsInSection:(NSInteger)section;

- (CGSize)tupleView:(UIView *)tupleView sizeForHeaderInSection:(NSInteger)section;
- (CGSize)tupleView:(UIView *)tupleView sizeForFooterInSection:(NSInteger)section;
- (CGSize)tupleView:(UIView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)tupleView:(UIView *)tupleView edgeInsetsForHeaderInSection:(NSInteger)section;
- (UIEdgeInsets)tupleView:(UIView *)tupleView edgeInsetsForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)tupleView:(UIView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)tupleView:(UIView *)tupleView headerTuple:(id (^)(Class aClass))headerBlock inSection:(NSInteger)section;
- (void)tupleView:(UIView *)tupleView footerTuple:(id (^)(Class aClass))footerBlock inSection:(NSInteger)section;
- (void)tupleView:(UIView *)tupleView itemTuple:(id (^)(Class aClass))itemBlock atIndexPath:(NSIndexPath *)indexPath;

- (void)tupleView:(UIView *)tupleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface HTupleView : UICollectionView <HTupleViewDelegate>
@property (nonatomic, weak, nullable) id <HTupleViewDelegate> tupleDelegate;
@property (nonatomic) RACSubject *goUpSubject; //用于item向tupleView传递消息
@property (nonatomic) RACSubject *goDownSubject; //用于tupleView向item传递消息
@property (nonatomic, copy) HTupleCellSignalBlock signalBlock;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(HTupleViewScrollDirection)direction;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;

- (id)headerWithReuseClass:(Class)aClass atIndexPath:(NSIndexPath *)indexPath;
- (id)footerWithReuseClass:(Class)aClass atIndexPath:(NSIndexPath *)indexPath;
- (id)itemWithReuseClass:(Class)aClass atIndexPath:(NSIndexPath *)indexPath;

@end
