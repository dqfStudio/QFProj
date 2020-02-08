//
//  HTableBaseApex.h
//  QFTableProject
//
//  Created by dqf on 2018/6/2.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HView+HLine.h"
#import "HTableSignal.h"

#define HLayoutTableApex(v) \
CGRect _frame = self.layoutViewBounds;\
if(!CGRectEqualToRect(v.frame, _frame)) {\
    [v setFrame:_frame];\
}

@class HTableView, HTableBaseApex;

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
//信号block
@property (nonatomic, copy) HTableCellSignalBlock signalBlock;
//cell间隔线的边距、颜色和是否显示间隔线
@property (nonatomic) UIEdgeInsets separatorInset;
@property (nonatomic) UIColor *separatorColor;
@property (nonatomic) BOOL shouldShowSeparator;
//unavailable init methods
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier NS_UNAVAILABLE;
//layoutView的frame和bounds
- (CGRect)layoutViewFrame;
- (CGRect)layoutViewBounds;
///子类可覆盖下列方法
//cell初始化是调用的方法
- (void)initUI;
//用于子类更新子视图布局
- (void)relayoutSubviews;
@end
