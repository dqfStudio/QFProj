//
//  HTupleViewCellDetail.h
//  QFProj
//
//  Created by wind on 2019/9/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTupleViewCellDetail1 : HTupleViewCell
@property (nonatomic) HWebImageView *imageView NS_UNAVAILABLE;
@property (nonatomic) HLabel *accessoryLabel NS_UNAVAILABLE;
@property (nonatomic) HWebImageView *detailView NS_UNAVAILABLE;
@property (nonatomic) HWebImageView *accessoryView NS_UNAVAILABLE;
- (void)loadCell;
@end

@interface HTupleViewCellDetail2 : HTupleViewCell
@property (nonatomic) HLabel *accessoryLabel NS_UNAVAILABLE;
@property (nonatomic) HWebImageView *detailView NS_UNAVAILABLE;
@property (nonatomic) HWebImageView *accessoryView NS_UNAVAILABLE;
- (void)loadCell;
@end

@interface HTupleViewCellDetail3 : HTupleViewCell
@property (nonatomic) HLabel *accessoryLabel NS_UNAVAILABLE;
@property (nonatomic) HWebImageView *detailView NS_UNAVAILABLE;
- (void)loadCell;
@end

@interface HTupleViewCellDetail4 : HTupleViewCell
@property (nonatomic) HLabel *accessoryLabel NS_UNAVAILABLE;
- (void)loadCell;
@end

NS_ASSUME_NONNULL_END
