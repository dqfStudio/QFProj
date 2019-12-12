//
//  HTupleViewCellVertValue1.h
//  QFProj
//
//  Created by dqf on 2019/9/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTupleViewCellVertBase1 : HTupleBaseCell
@property (nonatomic) UITBEdgeInsets imageViewInsets; //imageView的上下边距
@property (nonatomic) UITBEdgeInsets labelInsets; //label的上下边距
@property (nonatomic) UITBEdgeInsets detailLabelInsets; //detailLabel的上下边距
@property (nonatomic) UITBEdgeInsets accessoryLabelInsets; //accessoryLabel的上下边距
@end

@interface HTupleViewCellVertValue1 : HTupleViewCellVertBase1
@property (nonatomic) CGFloat labelHeight; //labelLabel的高度
@property (nonatomic) CGFloat detailHeight; //detailLabel的高度
@property (nonatomic) CGFloat accessoryHeight; //accessoryLabel的高度

@property (nonatomic, nullable) HWebImageView *imageView; //左边显示图片
@property (nonatomic, nullable) HLabel *label; //显示文字内容
@property (nonatomic, nullable) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic, nullable) HLabel *accessoryLabel; //显示文字内容附加信息

@property (nonatomic, nullable) HWebImageView *topView; //imageView顶部的背景图片
@property (nonatomic, nullable) HLabel *topLabel; //imageView顶部显示的文字内容
@property (nonatomic) CGFloat topHeight; //imageView顶部的高度

@property (nonatomic, nullable) HWebImageView *bottomView; //imageView底部的背景图片
@property (nonatomic, nullable) HLabel *bottomLabel; //imageView底部显示的文字内容
@property (nonatomic) CGFloat bottomHeight; //imageView底部的高度
@end

NS_ASSUME_NONNULL_END
