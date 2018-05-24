//
//  HTupleBaseCell.h
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
#import "AppDelegate.h"

#define HLayoutTupleView(v) \
if(!CGRectEqualToRect(v.frame, [self getContentFrame])) {\
    [v setFrame:[self getContentFrame]];\
}

@interface HTupleBaseCell : UICollectionViewCell
@property (nonatomic, weak) UICollectionView *collection;
@property (nonatomic, weak) RACSubject *goDownSubject;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UIEdgeInsets edgeInsets;
- (CGRect)getContentFrame;
- (void)addReturnKeyBoard;
//需要子类重写该方法
- (void)layoutContentView;
- (void)initUI;
- (void)selfSignal:(HTupleSignal *)signal;
- (void)sectionSignal:(HTupleSignal *)signal;
- (void)allItemSignal:(HTupleSignal *)signal;
@end
