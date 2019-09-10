//
//  HTupleViewCellDetail.h
//  QFProj
//
//  Created by wind on 2019/9/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCellBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTupleViewCellDetail : HTupleViewCellBase
@property (nonatomic) HLabel *label; //只显示文字
@property (nonatomic) HLabel *detailLabel; //显示文字内容详情
@end

@interface HTupleViewCellDetail2 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView; //左边显示图片
@property (nonatomic) HLabel *label; //只显示文字
@property (nonatomic) HLabel *detailLabel; //显示文字内容详情
@end

@interface HTupleViewCellDetail3 : HTupleViewCellBase
@property (nonatomic) HLabel *label; //只显示文字
@property (nonatomic) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic) HWebImageView *accessoryView; //右边显示箭头
@end

@interface HTupleViewCellDetail4 : HTupleViewCellBase
@property (nonatomic) HLabel *label; //只显示文字
@property (nonatomic) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic) HWebImageView *detailView; //右边显示图片
@end

@interface HTupleViewCellDetail5 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView; //左边显示图片
@property (nonatomic) HLabel *label; //只显示文字
@property (nonatomic) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic) HWebImageView *accessoryView; //右边显示箭头
@end

@interface HTupleViewCellDetail6 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView; //左边显示图片
@property (nonatomic) HLabel *label; //只显示文字
@property (nonatomic) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic) HWebImageView *detailView; //右边显示图片
@end

@interface HTupleViewCellDetail7 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView; //左边显示图片
@property (nonatomic) HLabel *label; //只显示文字
@property (nonatomic) HLabel *detailLabel; //显示文字内容详情
@property (nonatomic) HWebImageView *detailView; //文字右边，箭头左边显示图片
@property (nonatomic) HWebImageView *accessoryView; //右边显示箭头
@end

NS_ASSUME_NONNULL_END
