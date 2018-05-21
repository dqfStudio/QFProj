//
//  HTupleBaseView.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HLayoutReusableView(v) \
if(!CGRectEqualToRect(v.frame, [self getContentView])) {\
    [v setFrame:[self getContentView]];\
}

@interface HTupleBaseView : UICollectionReusableView
@property (nonatomic) UIEdgeInsets edgeInsets;
- (CGRect)getContentView;
//需要子类重写该方法
- (void)layoutContentView;
@end
