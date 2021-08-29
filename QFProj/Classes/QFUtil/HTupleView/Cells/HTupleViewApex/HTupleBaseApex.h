//
//  HTupleBaseApex.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+HUtil.h"
#import "HTupleSignal.h"
#import "UIColor+HUtil.h"
//方便业务层调用
//#import "NSObject+HMessy.h"
//#import "UILabel+HState.h"
//#import "UILabel+HUtil.h"

#define HLayoutTupleApex(v) \
if (!CGRectEqualToRect(v.frame, self.layoutViewBounds)) {\
    [v setFrame:self.layoutViewBounds];\
}

@class HTupleView, HTupleBaseApex;

@interface HTupleBaseApex : UICollectionReusableView
//cell所在的tuple view
@property (nonatomic, weak) UICollectionView *tuple;
//cell是否为section header
@property (nonatomic) BOOL isHeader;
//cell所在的indexPath
@property (nonatomic) NSIndexPath *indexPath;
//cell的边距
@property (nonatomic) UIEdgeInsets edgeInsets;
//用于加载在contentView上的布局视图
@property (nonatomic) UIView *layoutView;
//信号block
@property (nonatomic, copy) HTupleCellSignalBlock signalBlock;
//cell间隔线的边距、颜色和是否显示间隔线
@property (nonatomic) UILREdgeInsets separatorInset;
@property (nonatomic) UIColor *separatorColor;
@property (nonatomic) BOOL shouldShowSeparator;
//unavailable init methods
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
//layoutView的frame和bounds
- (CGRect)layoutViewFrame;
- (CGRect)layoutViewBounds;
///子类可覆盖下列方法
//cell初始化是调用的方法
- (void)initUI;
//用于子类更新子视图布局
- (void)relayoutSubviews;
@end
