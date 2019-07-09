//
//  HTableBaseView.h
//  QFTableProject
//
//  Created by dqf on 2018/6/2.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTableSignal.h"

#define HLayoutTableView(v) \
if(!CGRectEqualToRect(v.frame, [self getContentFrame])) {\
[v setFrame:[self getContentFrame]];\
}

@class HTableView, HTableBaseView;

typedef void(^HTableViewSkinBlock)(HTableBaseView *cell, HTableView *table);

@interface HTableBaseView : UITableViewHeaderFooterView
@property (nonatomic, weak) UITableView *table;
@property (nonatomic) NSInteger section;
@property (nonatomic, copy) HTableViewSkinBlock skinBlock;
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
