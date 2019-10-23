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
if(!CGRectEqualToRect(v.frame, [self layoutViewFrame])) {\
    [self frameChanged];\
    [v setFrame:[self layoutViewFrame]];\
}

@class HTableView, HTableBaseApex;

typedef void(^HTableApexBlock)(NSIndexPath *idxPath);
typedef void(^HTableApexSkinBlock)(HTableBaseApex *cell, HTableView *table);

@interface HTableBaseApex : UITableViewHeaderFooterView
@property (nonatomic, weak) UITableView *table;
@property (nonatomic) BOOL isHeader;
@property (nonatomic) NSInteger section;
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic) UIView *layoutView; //布局视图
@property (nonatomic, copy) HTableApexBlock cellBlock;
@property (nonatomic, copy) HTableApexSkinBlock skinBlock;
@property (nonatomic, copy) HTableCellSignalBlock signalBlock;
//间隔线
@property (nonatomic) UIEdgeInsets separatorInset;
@property (nonatomic) UIColor *separatorColor;
@property (nonatomic) BOOL shouldShowSeparator;
//是否需要刷新frame
@property (nonatomic) BOOL needRefreshFrame;
- (CGRect)layoutViewFrame;
- (CGRect)layoutViewBounds;
- (void)updateLayoutView;
//需要子类重写该方法
- (void)initUI;
- (void)frameChanged;
- (CGFloat)contentWidth;
- (CGFloat)contentHeight;
- (CGSize)contentSize;
@end
