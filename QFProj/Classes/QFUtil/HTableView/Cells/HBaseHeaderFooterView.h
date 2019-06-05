//
//  HBaseHeaderFooterView.h
//  QFTableProject
//
//  Created by dqf on 2018/6/2.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTableSignal.h"

#define HLayoutReusableTableView(v) \
if(!CGRectEqualToRect(v.frame, [self getContentFrame])) {\
[v setFrame:[self getContentFrame]];\
}

@interface HBaseHeaderFooterView : UITableViewHeaderFooterView
@property (nonatomic, weak) UITableView *table;
@property (nonatomic) NSInteger section;
//需要子类重写该方法
- (void)initUI;
- (CGRect)getContentFrame;
- (void)layoutContentView;
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;
@end

@interface UITableViewHeaderFooterView (HSignal)
@property (nonatomic, copy) HTableCellSignalBlock signalBlock;
@property (nonatomic) BOOL isHeader;
@end
