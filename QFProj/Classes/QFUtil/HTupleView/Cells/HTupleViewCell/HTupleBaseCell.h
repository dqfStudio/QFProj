//
//  HTupleBaseCell.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+HMessy.h"
#import "UILabel+HState.h"
#import "UILabel+HUtil.h"
#import "UIButton+HUtil.h"
#import "HTupleSignal.h"

#define HLayoutTupleView(v) \
if(!CGRectEqualToRect(v.frame, [self getContentFrame])) {\
    [v setFrame:[self getContentFrame]];\
}

@interface UICollectionViewCell ()
@property (nonatomic, copy) HTupleCellSignalBlock signalBlock;
@end

typedef void(^HTupleBaseCellBlock)(NSIndexPath *idxPath);

@interface HTupleBaseCell : UICollectionViewCell
@property (nonatomic, weak) UICollectionView *collection;
@property (nonatomic, copy) HTupleCellInitBlock initBlock;
@property (nonatomic, copy) HTupleBaseCellBlock baseBlock;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UIEdgeInsets edgeInsets;

#pragma --mark textField property
@property (nonatomic,copy) NSString *placeholder;//需要子类重写该方法
@property (nonatomic) UIColor *placeholderColor;//需要子类重写该方法
@property (nonatomic) NSInteger maxInput;//最大输入限制，小于等于0表示不限制，默认为0
@property (nonatomic) BOOL forbidPaste;//禁止粘贴，默认为NO

- (CGRect)getContentFrame;
- (void)addReturnKeyBoard;
//需要子类重写该方法
- (void)initUI;
- (void)layoutContentView;
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;
@end
