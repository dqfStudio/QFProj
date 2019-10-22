//
//  HTupleBaseApex.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTupleSignal.h"
//方便业务层调用
//#import "NSObject+HMessy.h"
//#import "UILabel+HState.h"
//#import "UILabel+HUtil.h"
//#import "UIButton+HUtil.h"

#define HLayoutTupleApex(v) \
if(!CGRectEqualToRect(v.frame, [self getContentFrame])) {\
    [self frameChanged];\
    [v setFrame:[self getContentFrame]];\
}

@class HTupleView, HTupleBaseApex;

typedef void(^HTupleApexBlock)(NSIndexPath *idxPath);
typedef void(^HTupleApexSkinBlock)(HTupleBaseApex *cell, HTupleView *tuple);

@interface HTupleBaseApex : UICollectionReusableView
@property (nonatomic, weak) UICollectionView *tuple;
@property (nonatomic) BOOL isHeader;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic) UIView *edgeInsetsView;//多个子控件的背景视图
@property (nonatomic, copy) HTupleApexBlock cellBlock;
@property (nonatomic, copy) HTupleApexSkinBlock skinBlock;
@property (nonatomic, copy) HTupleCellSignalBlock signalBlock;
//间隔线
@property (nonatomic) UILREdgeInsets separatorInset;
@property (nonatomic) UIColor *separatorColor;
@property (nonatomic) BOOL shouldShowSeparator;
//是否需要刷新frame
@property (nonatomic) BOOL needRefreshFrame;
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
