//
//  HTableBaseCell.h
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTableSignal.h"
#import "HGeometry.h"

#define HLayoutTableCell(v) \
if(!CGRectEqualToRect(v.frame, [self layoutViewBounds])) {\
    [v setFrame:[self layoutViewBounds]];\
}

@class HTableView, HTableBaseCell;

typedef void(^HTableItemBlock)(NSIndexPath *idxPath);
typedef void(^HTableCellSkinBlock)(HTableBaseCell *cell, HTableView *table);

@interface HTableBaseCell : UITableViewCell
//cell所在的table view
@property (nonatomic, weak) UITableView *table;
//cell所在的indexPath
@property (nonatomic) NSIndexPath *indexPath;
//cell的边距
@property (nonatomic) UIEdgeInsets edgeInsets;
//cell的style
@property (nonatomic) UITableViewCellStyle style;
//用于加载在contentView上的布局视图
@property (nonatomic) UIView *layoutView;
//cell点击block，用户用户点击事件
@property (nonatomic, copy) HTableItemBlock cellBlock;
//换肤block
@property (nonatomic, copy) HTableCellSkinBlock skinBlock;
//信号block
@property (nonatomic, copy) HTableCellSignalBlock signalBlock;
//cell间隔线的边距、颜色和是否显示间隔线
@property (nonatomic) UIEdgeInsets separatorInset;
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
