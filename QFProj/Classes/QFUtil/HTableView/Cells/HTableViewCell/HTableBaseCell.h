//
//  HTableBaseCell.h
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTableSignal.h"

#define HLayoutTableCell(v) \
if(!CGRectEqualToRect(v.frame, [self getContentFrame])) {\
[v setFrame:[self getContentFrame]];\
}

@class HTableView, HTableBaseCell;

typedef void(^HTableItemBlock)(NSIndexPath *idxPath);
typedef void(^HTableCellSkinBlock)(HTableBaseCell *cell, HTableView *table);

@interface HTableBaseCell : UITableViewCell
@property (nonatomic, weak) UITableView *table;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UITableViewCellStyle style;
@property (nonatomic, copy) HTableItemBlock cellBlock;
@property (nonatomic, copy) HTableCellSkinBlock skinBlock;
- (void)reloadData;
- (CGRect)getContentFrame;
//需要子类重写该方法
- (void)initUI;
- (void)layoutContentView;
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;
@end

@interface HTableBaseCell (HSignal)
@property (nonatomic, copy) HTableCellSignalBlock signalBlock;
@end
