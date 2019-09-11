//
//  HTupleViewCellValue1.h
//  QFProj
//
//  Created by wind on 2019/9/10.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"

NS_ASSUME_NONNULL_BEGIN

/*
 右边不带箭头
 */
@interface HTupleViewCellValue1 : HTupleBaseCell
@property (nonatomic) CGFloat leftWidth; //左边label的宽度
@property (nonatomic) CGFloat rightWidth; //右边label的宽度

@property (nonatomic, nullable) HWebImageView *imageView; //左边显示图片
@property (nonatomic, nonnull) HLabel *label; //显示文字内容
@property (nonatomic, nullable) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic, nullable) HLabel *accessoryLabel; //显示文字内容附加信息
@property (nonatomic, nullable) HWebImageView *detailView; //右边显示图片
@end

/*
 右边带有箭头
 */
@interface HTupleViewCellValue2 : HTupleBaseCell
@property (nonatomic) CGFloat leftWidth; //左边label的宽度
@property (nonatomic) CGFloat rightWidth; //右边label的宽度

@property (nonatomic, nullable) HWebImageView *imageView; //左边显示图片
@property (nonatomic, nonnull) HLabel *label; //显示文字内容
@property (nonatomic, nullable) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic, nullable) HLabel *accessoryLabel; //显示文字内容附加信息
@property (nonatomic, nullable) HWebImageView *detailView; //右边显示图片
@end

NS_ASSUME_NONNULL_END
