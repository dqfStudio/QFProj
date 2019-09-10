//
//  HTupleViewCellDefault.h
//  QFProj
//
//  Created by wind on 2019/9/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCellBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTupleViewCellDefault : HTupleViewCellBase
@property (nonatomic) HLabel *label; //只显示文字
@end

@interface HTupleViewCellDefault2 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView; //左边显示图片
@property (nonatomic) HLabel *label; //右边显示文字
@end

@interface HTupleViewCellDefault3 : HTupleViewCellBase
@property (nonatomic) HLabel *label; //左边显示文字
@property (nonatomic) HWebImageView *accessoryView; //右边显示箭头
@end

@interface HTupleViewCellDefault4 : HTupleViewCellBase
@property (nonatomic) HLabel *label; //左边显示文字
@property (nonatomic) HWebImageView *detailView; //右边显示图片
@end

@interface HTupleViewCellDefault5 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView; //左边显示图片
@property (nonatomic) HLabel *label; //中间显示文字
@property (nonatomic) HWebImageView *accessoryView; //右边显示箭头
@end

@interface HTupleViewCellDefault6 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView; //左边显示图片
@property (nonatomic) HLabel *label; //中间显示文字
@property (nonatomic) HWebImageView *detailView;//右边显示图片
@end

@interface HTupleViewCellDefault7 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView; //左边显示图片
@property (nonatomic) HLabel *label; //中间显示文字
@property (nonatomic) HWebImageView *detailView; //文字右边，箭头左边显示图片
@property (nonatomic) HWebImageView *accessoryView; //右边显示箭头
@end

NS_ASSUME_NONNULL_END
