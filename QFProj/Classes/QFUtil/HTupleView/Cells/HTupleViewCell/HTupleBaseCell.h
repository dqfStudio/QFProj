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

#define HLayoutTupleView(v) \
if(!CGRectEqualToRect(v.frame, [self getContentFrame])) {\
    [v setFrame:[self getContentFrame]];\
}

@interface UICollectionView (HTupleBaseCell)
- (id)headerWithReuseClass:(Class)aClass atIndexPath:(NSIndexPath *)indexPath;
- (id)footerWithReuseClass:(Class)aClass atIndexPath:(NSIndexPath *)indexPath;
- (id)itemWithReuseClass:(Class)aClass atIndexPath:(NSIndexPath *)indexPath;
@end

@interface HTupleBaseCell : UICollectionViewCell
@property (nonatomic, weak) UICollectionView *collection;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UIEdgeInsets edgeInsets;
- (CGRect)getContentFrame;
//需要子类重写该方法
- (void)layoutContentView;
@end
