//
//  HTableViewCellHoriValue1.h
//  QFProj
//
//  Created by wind on 2019/9/10.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTableViewCellHoriBase1 : HTableBaseCell
@property (nonatomic) UIEdgeInsets imageViewInsets; //imageView的上下左右边距
@property (nonatomic) CGFloat labelInterval; //两个label的间距
@property (nonatomic) UILREdgeInsets centralInsets; //中间label的左右边距
@property (nonatomic) UIEdgeInsets detailViewInsets; //detailView的上下左右边距
@end

@interface HTableViewCellHoriBase2 : HTableBaseCell
@property (nonatomic) UIEdgeInsets imageViewInsets; //imageView的上下左右边距
@property (nonatomic) UILREdgeInsets labelInsets; //label的左右边距
@property (nonatomic) UILREdgeInsets detailLabelInsets; //detailLabel的左右边距
@property (nonatomic) UILREdgeInsets accessoryLabelInsets; //accessoryLabel的左右边距
@property (nonatomic) UILREdgeInsets centralInsets; //中间label的左右边距
@property (nonatomic) UIEdgeInsets detailViewInsets; //detailView的上下左右边距
@end

@interface HTableViewCellHoriBase3 : HTableBaseCell
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
@interface HTableViewCellHoriValue1 : HTableViewCellHoriBase1
@property (nonatomic, nullable) HWebImageView *imageView; //左边显示图片
@property (nonatomic, nonnull)  HLabel *label; //显示文字内容
@property (nonatomic, nonnull)  HLabel *detailLabel; //显示文字内容详情
@property (nonatomic, nullable) HWebImageView *detailView; //右边显示图片
@property (nonatomic) BOOL showAccessoryArrow; //是否显示右边箭头
@end

/*
 两个label左右对立排列
 */
@interface HTableViewCellHoriValue2 : HTableViewCellHoriBase1
@property (nonatomic, nullable) HWebImageView *imageView; //左边显示图片
@property (nonatomic, nonnull)  HLabel *label; //显示文字内容
@property (nonatomic, nonnull)  HLabel *detailLabel; //显示文字内容详情
@property (nonatomic, nullable) HWebImageView *detailView; //右边显示图片
@property (nonatomic) BOOL showAccessoryArrow; //是否显示右边箭头
@end

/*
 三个label横向显示
 */
@interface HTableViewCellHoriValue3 : HTableViewCellHoriBase2
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
@interface HTableViewCellHoriValue4 : HTableViewCellHoriBase3
@property (nonatomic, nullable) HWebImageView *imageView; //左边显示图片
@property (nonatomic, nonnull)  HLabel *label; //显示文字内容
@property (nonatomic, nullable) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic, nullable) HLabel *accessoryLabel; //显示文字内容附加信息
@property (nonatomic, nullable) HWebImageView *detailView; //文字右边，箭头左边显示图片
@property (nonatomic) BOOL showAccessoryArrow; //是否显示右边箭头
@end

NS_ASSUME_NONNULL_END
