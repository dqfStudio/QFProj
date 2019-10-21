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
if(!CGRectEqualToRect(v.frame, [self getContentBounds])) {\
    [self frameChanged];\
    [v setFrame:[self getContentBounds]];\
}

@class HTableView, HTableBaseApex;

typedef void(^HTableApexBlock)(NSIndexPath *idxPath);
typedef void(^HTableApexSkinBlock)(HTableBaseApex *cell, HTableView *table);

@interface HTableBaseApex : UITableViewHeaderFooterView
@property (nonatomic, weak) UITableView *table;
@property (nonatomic) BOOL isHeader;
@property (nonatomic) NSInteger section;
@property (nonatomic, copy) HTableApexBlock cellBlock;
@property (nonatomic, copy) HTableApexSkinBlock skinBlock;
@property (nonatomic, copy) HTableCellSignalBlock signalBlock;
//需要子类重写该方法
- (void)initUI;
- (void)frameChanged;
- (CGRect)getContentBounds;
- (void)layoutContentView;
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;
@end
