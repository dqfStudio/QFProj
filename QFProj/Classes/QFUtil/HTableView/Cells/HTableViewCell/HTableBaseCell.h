//
//  HTableBaseCell.h
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTableSignal.h"

#define KTableCellSkinNotify @"tableCellSkinNotify"

#define HLayoutTableCell(v) \
if(!CGRectEqualToRect(v.frame, [self getContentFrame])) {\
[v setFrame:[self getContentFrame]];\
}

typedef void(^HTableCellSkinBlock)(void);

@interface HTableBaseCell : UITableViewCell
@property (nonatomic, weak) UITableView *table;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UITableViewCellStyle style;
@property (nonatomic, copy) HTableCellSkinBlock skinBlock;
//需要子类重写该方法
- (void)initUI;
- (CGRect)getContentFrame;
- (void)layoutContentView;
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;
@end

@interface UITableViewCell (HSignal)
@property (nonatomic, copy) HTableCellSignalBlock signalBlock;
@end
