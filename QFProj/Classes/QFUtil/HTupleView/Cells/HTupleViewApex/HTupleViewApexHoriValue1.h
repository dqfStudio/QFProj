//
//  HTupleViewApexHoriValue1.h
//  QFProj
//
//  Created by dqf on 2019/9/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewApex.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTupleViewApexHoriBase1 : HTupleBaseApex
@property (nonatomic) UIEdgeInsets imageViewInsets; //imageView的上下左右边距
@property (nonatomic) CGFloat labelInterval; //两个label的间距
@property (nonatomic) UILREdgeInsets centralInsets; //中间label的左右边距
@property (nonatomic) UIEdgeInsets detailViewInsets; //detailView的上下左右边距
@end

@interface HTupleViewApexHoriBase2 : HTupleBaseApex
@property (nonatomic) UIEdgeInsets imageViewInsets; //imageView的上下左右边距
@property (nonatomic) UILREdgeInsets labelInsets; //label的左右边距
@property (nonatomic) UILREdgeInsets detailLabelInsets; //detailLabel的左右边距
@property (nonatomic) UILREdgeInsets accessoryLabelInsets; //accessoryLabel的左右边距
@property (nonatomic) UILREdgeInsets centralInsets; //中间label的左右边距
@property (nonatomic) UIEdgeInsets detailViewInsets; //detailView的上下左右边距
@end

@interface HTupleViewApexHoriBase3 : HTupleBaseApex
@property (nonatomic) UIEdgeInsets imageViewInsets; //imageView的上下左右边距
@property (nonatomic) UITBEdgeInsets labelInsets; //label的上下边距
@property (nonatomic) UITBEdgeInsets detailLabelInsets; //detailLabel的上下边距
@property (nonatomic) UITBEdgeInsets accessoryLabelInsets; //accessoryLabel的上下边距
@property (nonatomic) UILREdgeInsets centralInsets; //中间label的左右边距
@property (nonatomic) UIEdgeInsets detailViewInsets; //detailView的上下左右边距
@end

/*
 两个label左右相距排列
 */
@interface HTupleViewApexHoriValue1 : HTupleViewApexHoriBase1
@property (nonatomic, nullable) HWebImageView *imageView; //左边显示图片
@property (nonatomic, nonnull)  HLabel *label; //显示文字内容
@property (nonatomic, nonnull)  HLabel *detailLabel; //显示文字内容详情
@property (nonatomic, nullable) HWebImageView *detailView; //右边显示图片
@property (nonatomic) BOOL showAccessoryArrow; //是否显示右边箭头
@end

/*
 两个label左右对立排列
 */
@interface HTupleViewApexHoriValue2 : HTupleViewApexHoriBase1
@property (nonatomic, nullable) HWebImageView *imageView; //左边显示图片
@property (nonatomic, nonnull)  HLabel *label; //显示文字内容
@property (nonatomic, nonnull)  HLabel *detailLabel; //显示文字内容详情
@property (nonatomic, nullable) HWebImageView *detailView; //右边显示图片
@property (nonatomic) BOOL showAccessoryArrow; //是否显示右边箭头
@end

/*
 三个label横向显示
 */
@interface HTupleViewApexHoriValue3 : HTupleViewApexHoriBase2
@property (nonatomic) CGFloat detailWidth; //左边detailLabel的宽度
@property (nonatomic) CGFloat accessoryWidth; //右边accessoryLabel的宽度

@property (nonatomic, nullable) HWebImageView *imageView; //左边显示图片
@property (nonatomic, nonnull)  HLabel *label; //显示文字内容
@property (nonatomic, nullable) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic, nullable) HLabel *accessoryLabel; //显示文字内容附加信息
@property (nonatomic, nullable) HWebImageView *detailView; //右边显示图片
@property (nonatomic) BOOL showAccessoryArrow; //是否显示右边箭头
@end

/*
 三个label纵向显示
*/
@interface HTupleViewApexHoriValue4 : HTupleViewApexHoriBase3
@property (nonatomic, nullable) HWebImageView *imageView; //左边显示图片
@property (nonatomic, nonnull)  HLabel *label; //显示文字内容
@property (nonatomic, nullable) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic, nullable) HLabel *accessoryLabel; //显示文字内容附加信息
@property (nonatomic, nullable) HWebImageView *detailView; //文字右边，箭头左边显示图片
@property (nonatomic) BOOL showAccessoryArrow; //是否显示右边箭头
@end

NS_ASSUME_NONNULL_END
