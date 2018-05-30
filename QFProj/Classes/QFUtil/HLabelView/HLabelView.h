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

typedef struct HSideEdgeInsets {
    CGFloat height, top, bottom;
} HSideEdgeInsets;

UIKIT_STATIC_INLINE HEdgeInsets HEdgeInsetsMake(CGFloat width, CGFloat height, CGFloat left, CGFloat right) {
    HEdgeInsets insets = {width, height, left, right};
    return insets;
}

UIKIT_STATIC_INLINE HSideEdgeInsets HSideEdgeInsetsMake(CGFloat height, CGFloat top, CGFloat bottom) {
    HSideEdgeInsets insets = {height, top, bottom};
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

UIKIT_STATIC_INLINE bool HSideEdgeEqualToEdge(HSideEdgeInsets edge1, HSideEdgeInsets edge2) {
    bool equal = true;
    if (edge1.height != edge2.height) equal = false;
    else if (edge1.top != edge2.top) equal = false;
    else if (edge1.bottom != edge2.bottom) equal = false;
    return equal;
}

@interface HLabelView : UIView
@property (nonatomic) UILabel *label;
@property (nonatomic, strong, nullable) UIView *leftView;
@property (nonatomic, strong, nullable) UIView *rightView;
@property (nonatomic, strong, nullable) UIView *topView;
@property (nonatomic, strong, nullable) UIView *bottomView;

@property(nonatomic) HEdgeInsets leftEdgeInsets;
@property(nonatomic) HEdgeInsets rightEdgeInsets;
@property(nonatomic) HSideEdgeInsets topEdgeInsets;
@property(nonatomic) HSideEdgeInsets bottomEdgeInsets;
@end
