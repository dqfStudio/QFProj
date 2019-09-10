//
//  HTupleViewCellAccessory.h
//  QFProj
//
//  Created by wind on 2019/9/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTupleViewCellAccessory1 : HTupleViewCell
@property (nonatomic) HWebImageView *imageView NS_UNAVAILABLE;
@property (nonatomic) HWebImageView *detailView NS_UNAVAILABLE;
@property (nonatomic) HWebImageView *accessoryView NS_UNAVAILABLE;
- (void)loadCell;
@end

@interface HTupleViewCellAccessory2 : HTupleViewCell
@property (nonatomic) HWebImageView *detailView NS_UNAVAILABLE;
@property (nonatomic) HWebImageView *accessoryView NS_UNAVAILABLE;
- (void)loadCell;
@end

@interface HTupleViewCellAccessory3 : HTupleViewCell
@property (nonatomic) HWebImageView *detailView NS_UNAVAILABLE;
- (void)loadCell;
@end

@interface HTupleViewCellAccessory4 : HTupleViewCell
- (void)loadCell;
@end

NS_ASSUME_NONNULL_END
