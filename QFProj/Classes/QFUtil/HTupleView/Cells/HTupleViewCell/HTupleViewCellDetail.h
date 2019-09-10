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
@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
@end

@interface HTupleViewCellDetail2 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
@end

@interface HTupleViewCellDetail3 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
@property (nonatomic) HWebImageView *accessoryView;
@end

@interface HTupleViewCellDetail4 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
@property (nonatomic) HWebImageView *detailView;
@end

@interface HTupleViewCellDetail5 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
@property (nonatomic) HWebImageView *detailView;
@property (nonatomic) HWebImageView *accessoryView;
@end

NS_ASSUME_NONNULL_END
