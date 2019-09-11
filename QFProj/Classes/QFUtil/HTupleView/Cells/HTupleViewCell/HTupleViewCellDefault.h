//
//  HTupleViewCellDefault.h
//  QFProj
//
//  Created by wind on 2019/9/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"

NS_ASSUME_NONNULL_BEGIN

/*
 右边不带箭头
 */
@interface HTupleViewCellDefault : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView; //左边显示图片
@property (nonatomic) HLabel *label; //显示文字内容
@property (nonatomic) HWebImageView *detailView; //右边显示图片
@end

/*
 右边带有箭头
 */
@interface HTupleViewCellDefault2 : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView; //左边显示图片
@property (nonatomic) HLabel *label; //显示文字内容
@property (nonatomic) HWebImageView *detailView; //文字右边，箭头左边显示图片
@end

NS_ASSUME_NONNULL_END
