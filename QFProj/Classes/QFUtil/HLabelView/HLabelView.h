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

UIKIT_STATIC_INLINE bool HEdgeEqualToEdge(HEdgeInsets edge1, HEdgeInsets edge2) {
    bool equal = true;
    if (edge1.width != edge2.width) equal = false;
    else if (edge1.height != edge2.height) equal = false;
    else if (edge1.left != edge2.left) equal = false;
    else if (edge1.right != edge2.right) equal = false;
    return equal;
}

@interface HLabelView : UIView
@property (nonatomic) UILabel *label;
@property (nonatomic, copy) UIView *leftView;
@property (nonatomic, copy) UIView *rightView;
@property(nonatomic) HEdgeInsets leftEdgeInsets;
@property(nonatomic) HEdgeInsets rightEdgeInsets;
@end
