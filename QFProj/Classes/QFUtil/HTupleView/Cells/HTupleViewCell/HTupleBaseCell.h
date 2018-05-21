//
//  HTupleBaseCell.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HLayoutTupleView(v) \
if(!CGRectEqualToRect(v.frame, [self getContentView])) {\
    [v setFrame:[self getContentView]];\
}

@interface HTupleBaseCell : UICollectionViewCell
@property (nonatomic) UIEdgeInsets edgeInsets;
- (CGRect)getContentView;
- (void)layoutContentView;
@end
