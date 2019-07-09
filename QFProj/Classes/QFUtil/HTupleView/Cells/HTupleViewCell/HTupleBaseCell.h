//
//  HTupleBaseCell.h
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
//#import "UIView+HUtil.h"
#import "UIButton+HUtil.h"

#define HLayoutTupleCell(v) \
if(!CGRectEqualToRect(v.frame, [self getContentFrame])) {\
    [v setFrame:[self getContentFrame]];\
}

@class HTupleView, HTupleBaseCell;

typedef void(^HTupleCellBlock)(NSIndexPath *idxPath);
typedef void(^HTupleCellSkinBlock)(HTupleBaseCell *cell, HTupleView *tuple);

@interface HTupleBaseCell : UICollectionViewCell
@property (nonatomic, weak) UICollectionView *tuple;
@property (nonatomic, copy) HTupleCellBlock cellBlock;
@property (nonatomic, copy) HTupleCellSkinBlock skinBlock;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UIEdgeInsets edgeInsets;
//间隔线
@property (nonatomic) UIEdgeInsets separatorInset;
@property (nonatomic) UIColor *separatorColor;
@property (nonatomic) BOOL shouldShowSeparator;
- (CGRect)getContentFrame;
//需要子类重写该方法
- (void)initUI;
- (void)layoutContentView;
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;
@end

@interface UICollectionViewCell (HSignal)
@property (nonatomic, copy) HTupleCellSignalBlock signalBlock;
@end
