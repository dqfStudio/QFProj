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
if(!CGRectEqualToRect(v.frame, [self getContentFrame])) {\
    [self frameChanged];\
    [v setFrame:[self getContentFrame]];\
}

@class HTableView, HTableBaseCell;

typedef void(^HTableItemBlock)(NSIndexPath *idxPath);
typedef void(^HTableCellSkinBlock)(HTableBaseCell *cell, HTableView *table);

@interface HTableBaseCell : UITableViewCell
@property (nonatomic, weak) UITableView *table;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic) UITableViewCellStyle style;
@property (nonatomic) UIView *edgeInsetsView;//多个子控件的背景视图
@property (nonatomic, copy) HTableItemBlock cellBlock;
@property (nonatomic, copy) HTableCellSkinBlock skinBlock;
@property (nonatomic, copy) HTableCellSignalBlock signalBlock;
//间隔线
@property (nonatomic) UIEdgeInsets separatorInset;
@property (nonatomic) UIColor *separatorColor;
@property (nonatomic) BOOL shouldShowSeparator;
//是否需要刷新frame
@property (nonatomic) BOOL needRefreshFrame;
- (void)reloadData;
- (CGRect)getContentFrame;
- (CGRect)getContentBounds;
//需要子类重写该方法
- (void)initUI;
- (void)frameChanged;
- (void)layoutContentView;
- (CGFloat)contentWidth;
- (CGFloat)contentHeight;
- (CGSize)contentSize;
@end
