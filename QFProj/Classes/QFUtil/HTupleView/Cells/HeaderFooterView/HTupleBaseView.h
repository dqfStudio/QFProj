//
//  HTupleBaseView.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+HState.h"
#import "UILabel+HUtil.h"
#import "UIButton+HUtil.h"
#import "HTupleSignal.h"

#define HLayoutReusableTupleView(v) \
if(!CGRectEqualToRect(v.frame, [self getContentFrame])) {\
    [v setFrame:[self getContentFrame]];\
}

@interface UICollectionReusableView ()
@property (nonatomic, copy) HTupleCellSignalBlock signalBlock;
@end

typedef void(^HTupleBaseViewBlock)(NSIndexPath *idxPath);

@interface HTupleBaseView : UICollectionReusableView
@property (nonatomic, weak) UICollectionView *collection;
@property (nonatomic, copy) HTupleBaseViewBlock baseBlock;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic) UIView *lineView;
@property (nonatomic) UIEdgeInsets lineInsets;
- (CGRect)getContentFrame;
- (void)addReturnKeyBoard;
//需要子类重写该方法
- (void)initUI;
- (void)layoutContentView;
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;
@end
