//
//  HTupleViewCellDefault.h
//  QFProj
//
//  Created by wind on 2019/9/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"

typedef struct UITBEdgeInsets {
    CGFloat top, bottom;
} UITBEdgeInsets;

typedef struct UILREdgeInsets {
    CGFloat left, right;
} UILREdgeInsets;

static UITBEdgeInsets UITBEdgeInsetsZero = {0, 0};
static UILREdgeInsets UILREdgeInsetsZero = {0, 0};

UIKIT_STATIC_INLINE UITBEdgeInsets UITBEdgeInsetsMake(CGFloat top, CGFloat bottom) {
    UITBEdgeInsets insets = {top, bottom};
    return insets;
}

UIKIT_STATIC_INLINE UILREdgeInsets UILREdgeInsetsMake(CGFloat left, CGFloat right) {
    UILREdgeInsets insets = {left, right};
    return insets;
}

NS_ASSUME_NONNULL_BEGIN

@interface HTupleViewCellBase : HTupleBaseCell
@property (nonatomic) UIEdgeInsets imageViewInsets; //imageView的上下左右边距
@property (nonatomic) UITBEdgeInsets labelInsets; //label的上下边距
@property (nonatomic) UITBEdgeInsets detailLabelInsets; //detailLabel的上下边距
@property (nonatomic) UITBEdgeInsets accessoryLabelInsets; //accessoryLabel的上下边距
@property (nonatomic) UILREdgeInsets centerLabelInsets; //中间label的左右边距
@property (nonatomic) UIEdgeInsets detailViewInsets; //detailView的上下左右边距
@end

@interface HTupleViewCellBase2 : HTupleBaseCell
@property (nonatomic) UIEdgeInsets imageViewInsets; //imageView的上下左右边距
@property (nonatomic) UILREdgeInsets labelInsets; //label的上下边距
@property (nonatomic) UILREdgeInsets detailLabelInsets; //detailLabel的上下边距
@property (nonatomic) UILREdgeInsets accessoryLabelInsets; //accessoryLabel的上下边距
@property (nonatomic) UILREdgeInsets centerLabelInsets; //中间label的左右边距
@property (nonatomic) UIEdgeInsets detailViewInsets; //detailView的上下左右边距
@end

/*
 右边不带箭头
 */
@interface HTupleViewCellDefault : HTupleViewCellBase
@property (nonatomic, nullable) HWebImageView *imageView; //左边显示图片
@property (nonatomic, nonnull)  HLabel *label; //显示文字内容
@property (nonatomic, nullable) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic, nullable) HLabel *accessoryLabel; //显示文字内容附加信息
@property (nonatomic, nullable) HWebImageView *detailView; //右边显示图片
@end

/*
 右边带有箭头
 */
@interface HTupleViewCellDefault2 : HTupleViewCellBase
@property (nonatomic, nullable) HWebImageView *imageView; //左边显示图片
@property (nonatomic, nonnull)  HLabel *label; //显示文字内容
@property (nonatomic, nullable) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic, nullable) HLabel *accessoryLabel; //显示文字内容附加信息
@property (nonatomic, nullable) HWebImageView *detailView; //文字右边，箭头左边显示图片
@end

NS_ASSUME_NONNULL_END
