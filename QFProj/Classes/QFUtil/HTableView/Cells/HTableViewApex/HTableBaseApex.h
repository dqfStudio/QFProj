//
//  HTableBaseApex.h
//  QFTableProject
//
//  Created by dqf on 2018/6/2.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTableSignal.h"

#define HLayoutTableApex(v) \
CGRect frame = self.layoutViewBounds;\
if(!CGRectEqualToRect(v.frame, frame)) {\
    [v setFrame:frame];\
}

@class HTableView, HTableBaseApex;

typedef void(^HTableApexBlock)(NSIndexPath *idxPath);

@interface HTableBaseApex : UITableViewHeaderFooterView
//cell所在的table view
@property (nonatomic, weak) UITableView *table;
//cell是否为section header
@property (nonatomic) BOOL isHeader;
//cell所在的section
@property (nonatomic) NSInteger section;
//cell的边距
@property (nonatomic) UIEdgeInsets edgeInsets;
//用于加载在contentView上的布局视图
@property (nonatomic) UIView *layoutView;
//cell点击block，用户用户点击事件
@property (nonatomic, copy) HTableApexBlock cellBlock;
//信号block
@property (nonatomic, copy) HTableCellSignalBlock signalBlock;
//cell间隔线的边距、颜色和是否显示间隔线
@property (nonatomic) UIEdgeInsets separatorInset;
@property (nonatomic) UIColor *separatorColor;
@property (nonatomic) BOOL shouldShowSeparator;
//layoutView的frame和bounds
- (CGRect)layoutViewFrame;
- (CGRect)layoutViewBounds;
///子类可覆盖下列方法
//cell初始化是调用的方法
- (void)initUI;
//用于子类更新子视图布局
- (void)relayoutSubviews;
@end
