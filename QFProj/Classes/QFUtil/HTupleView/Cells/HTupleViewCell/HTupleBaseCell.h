//
//  HTupleBaseCell.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTupleSignal.h"
//方便业务层调用
//#import "NSObject+HMessy.h"
//#import "UILabel+HState.h"
//#import "UILabel+HUtil.h"
//#import "UIView+HUtil.h"
//#import "UIButton+HUtil.h"

#define HLayoutTupleCell(v) \
if(!CGRectEqualToRect(v.frame, [self layoutViewBounds])) {\
    [v setFrame:[self layoutViewBounds]];\
}

@class HTupleView, HTupleBaseCell;

typedef void(^HTupleCellBlock)(NSIndexPath *idxPath);

@interface HTupleBaseCell : UICollectionViewCell
//cell所在的tuple view
@property (nonatomic, weak) UICollectionView *tuple;
//cell所在的indexPath
@property (nonatomic) NSIndexPath *indexPath;
//cell的边距
@property (nonatomic) UIEdgeInsets edgeInsets;
//用于加载在contentView上的布局视图
@property (nonatomic) UIView *layoutView;
//cell点击block，用户用户点击事件
@property (nonatomic, copy) HTupleCellBlock cellBlock;
//信号block
@property (nonatomic, copy) HTupleCellSignalBlock signalBlock;
//cell间隔线的边距、颜色和是否显示间隔线
@property (nonatomic) UILREdgeInsets separatorInset;
@property (nonatomic) UIColor *separatorColor;
@property (nonatomic) BOOL shouldShowSeparator;
- (void)reloadData;
//layoutView的frame和bounds
- (CGRect)layoutViewFrame;
- (CGRect)layoutViewBounds;
///子类可覆盖下列方法
//cell初始化是调用的方法
- (void)initUI;
//用于子类更新子视图布局
- (void)relayoutSubviews;
@end
