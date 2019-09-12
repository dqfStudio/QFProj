//
//  HTupleViewApexValue1.h
//  QFProj
//
//  Created by wind on 2019/9/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewApex.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTupleViewApexValueBase : HTupleBaseCell
@property (nonatomic) UIEdgeInsets imageViewInsets; //imageView的上下左右边距
@property (nonatomic) UILREdgeInsets labelInsets; //label的左右边距
@property (nonatomic) UILREdgeInsets detailLabelInsets; //detailLabel的左右边距
@property (nonatomic) UILREdgeInsets accessoryLabelInsets; //accessoryLabel的左右边距
@property (nonatomic) UILREdgeInsets centerLabelInsets; //中间label的左右边距
@property (nonatomic) UIEdgeInsets detailViewInsets; //detailView的上下左右边距
@end

/*
 右边不带箭头
 */
@interface HTupleViewApexValue1 : HTupleViewApexValueBase
@property (nonatomic) CGFloat leftWidth; //左边label的宽度
@property (nonatomic) CGFloat rightWidth; //右边label的宽度

@property (nonatomic, nullable) HWebImageView *imageView; //左边显示图片
@property (nonatomic, nonnull)  HLabel *label; //显示文字内容
@property (nonatomic, nullable) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic, nullable) HLabel *accessoryLabel; //显示文字内容附加信息
@property (nonatomic, nullable) HWebImageView *detailView; //右边显示图片
@end

/*
 右边带有箭头
 */
@interface HTupleViewApexValue2 : HTupleViewApexValueBase
@property (nonatomic) CGFloat leftWidth; //左边label的宽度
@property (nonatomic) CGFloat rightWidth; //右边label的宽度

@property (nonatomic, nullable) HWebImageView *imageView; //左边显示图片
@property (nonatomic, nonnull)  HLabel *label; //显示文字内容
@property (nonatomic, nullable) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic, nullable) HLabel *accessoryLabel; //显示文字内容附加信息
@property (nonatomic, nullable) HWebImageView *detailView; //右边显示图片
@end

NS_ASSUME_NONNULL_END
