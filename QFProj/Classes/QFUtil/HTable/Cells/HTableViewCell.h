//
//  HTableViewCell.h
//  MGMobileMusic
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HBaseCell.h"

typedef struct HCellEdgeInsets {
    CGFloat width, height, left, right;
} HCellEdgeInsets;

UIKIT_STATIC_INLINE HCellEdgeInsets HCellEdgeInsetsMake(CGFloat width, CGFloat height, CGFloat left, CGFloat right) {
    HCellEdgeInsets insets = {width ,height, left, right};
    return insets;
}

UIKIT_STATIC_INLINE bool HCellEdgeEqualToEdge(HCellEdgeInsets edge1, HCellEdgeInsets edge2) {
    bool equal = true;
    if (edge1.width != edge2.width) equal = false;
    else if (edge1.height != edge2.height) equal = false;
    else if (edge1.left != edge2.left) equal = false;
    else if (edge1.right != edge2.right) equal = false;
    return equal;
}

@interface HTableViewCell : HBaseCell
@property (nonatomic) UIImageView *leftImageView; //代替系统的imageView控件
@property (nonatomic) HCellEdgeInsets leftImageEdgeInsets; //图片大小和左右边距，上下边距自动计算且居中
@property (nonatomic) BOOL filletedCorner; //leftImageView控件是否圆角，默认不是圆角，如果是圆角则为圆形
@end
