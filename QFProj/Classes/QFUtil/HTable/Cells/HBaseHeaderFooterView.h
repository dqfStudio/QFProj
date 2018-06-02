//
//  HBaseHeaderFooterView.h
//  QFTableProject
//
//  Created by dqf on 2018/6/2.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTableSignal.h"

@interface UITableViewHeaderFooterView ()
@property (nonatomic, copy) HTableCellSignalBlock signalBlock;
@property (nonatomic) BOOL isHeader;
@end

@interface HBaseHeaderFooterView : UITableViewHeaderFooterView
@property (nonatomic, weak) UITableView *table;
@property (nonatomic) NSInteger section;
//子类覆盖
- (void)initUI;
@end
