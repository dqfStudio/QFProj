//
//  HTupleViewCellBase.h
//  QFProj
//
//  Created by wind on 2019/9/10.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTupleViewCellBase : HTupleViewCell
@property (nonatomic) HWebImageView *imageView NS_UNAVAILABLE;
@property (nonatomic) HLabel *label NS_UNAVAILABLE;
@property (nonatomic) HLabel *detailLabel NS_UNAVAILABLE;
@property (nonatomic) HLabel *accessoryLabel NS_UNAVAILABLE;
@property (nonatomic) HWebImageView *detailView NS_UNAVAILABLE;
@property (nonatomic) HWebImageView *accessoryView NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
