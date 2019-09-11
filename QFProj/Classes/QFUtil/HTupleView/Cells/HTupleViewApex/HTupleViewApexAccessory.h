//
//  HTupleViewApexAccessory.h
//  QFProj
//
//  Created by wind on 2019/9/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewApex.h"

NS_ASSUME_NONNULL_BEGIN

/*
 右边不带箭头
 */
@interface HTupleViewApexAccessory : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView; //左边显示图片
@property (nonatomic) HLabel *label; //显示文字内容
@property (nonatomic) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic) HLabel *accessoryLabel; //显示文字内容附加信息
@property (nonatomic) HWebImageView *detailView; //右边显示图片
@end

/*
 右边带有箭头
 */
@interface HTupleViewApexAccessory2 : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView; //左边显示图片
@property (nonatomic) HLabel *label; //显示文字内容
@property (nonatomic) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic) HLabel *accessoryLabel; //显示文字内容附加信息
@property (nonatomic) HWebImageView *detailView; //文字右边，箭头左边显示图片
@end

NS_ASSUME_NONNULL_END
