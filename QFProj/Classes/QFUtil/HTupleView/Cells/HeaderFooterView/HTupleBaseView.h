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

#define HLayoutReusableView(v) \
if(!CGRectEqualToRect(v.frame, [self getContentFrame])) {\
    [v setFrame:[self getContentFrame]];\
}

@interface HTupleBaseView : UICollectionReusableView
@property (nonatomic, weak) UICollectionView *collection;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UIEdgeInsets edgeInsets;
- (CGRect)getContentFrame;
//需要子类重写该方法
- (void)layoutContentView;
@end
