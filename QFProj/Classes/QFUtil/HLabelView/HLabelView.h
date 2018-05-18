//
//  HLabelView.h
//  QFProj
//
//  Created by dqf on 2018/5/18.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct HEdgeInsets {
    CGFloat width, height, left, right;
} HEdgeInsets;

UIKIT_STATIC_INLINE HEdgeInsets HEdgeInsetsMake(CGFloat width, CGFloat height, CGFloat left, CGFloat right) {
    HEdgeInsets insets = {width, height, left, right};
    return insets;
}

@interface HLabelView : UIView
@property (nonatomic) UILabel *label;
@property (nonatomic, copy) UIView *accessoryView;
@property(nonatomic) HEdgeInsets edgeInsets;
@end
