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

CG_EXTERN HCellEdgeInsets HCellEdgeInsetsMake(CGFloat width, CGFloat height, CGFloat left, CGFloat right);
CG_EXTERN bool HCellEdgeEqualToEdge(HCellEdgeInsets edge1, HCellEdgeInsets edge2);

@interface HTableViewCell : HBaseCell
@property (nonatomic) UIImageView *leftImageView; //代替系统的imageView控件
@property (nonatomic) HCellEdgeInsets leftImageEdgeInsets; //图片大小和左右边距，上下边距自动计算且居中
@property (nonatomic) CGFloat leftImageViewCornerRadius;//leftImageView控件圆角弧度
@end
