//
//  HTupleViewCellDefault.h
//  QFProj
//
//  Created by wind on 2019/9/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTupleViewCellDefault1 : HTupleViewCell
@property (nonatomic) HWebImageView *imageView NS_UNAVAILABLE;
@property (nonatomic) HLabel *detailLabel NS_UNAVAILABLE;
@property (nonatomic) HLabel *accessoryLabel NS_UNAVAILABLE;
@property (nonatomic) HWebImageView *detailView NS_UNAVAILABLE;
@property (nonatomic) HWebImageView *accessoryView NS_UNAVAILABLE;
- (void)loadCell;
@end

@interface HTupleViewCellDefault2 : HTupleViewCell
@property (nonatomic) HLabel *detailLabel NS_UNAVAILABLE;
@property (nonatomic) HLabel *accessoryLabel NS_UNAVAILABLE;
@property (nonatomic) HWebImageView *detailView NS_UNAVAILABLE;
@property (nonatomic) HWebImageView *accessoryView NS_UNAVAILABLE;
- (void)loadCell;
@end

@interface HTupleViewCellDefault3 : HTupleViewCell
@property (nonatomic) HLabel *detailLabel NS_UNAVAILABLE;
@property (nonatomic) HLabel *accessoryLabel NS_UNAVAILABLE;
@property (nonatomic) HWebImageView *detailView NS_UNAVAILABLE;
- (void)loadCell;
@end

@interface HTupleViewCellDefault4 : HTupleViewCell
@property (nonatomic) HLabel *detailLabel NS_UNAVAILABLE;
@property (nonatomic) HLabel *accessoryLabel NS_UNAVAILABLE;
- (void)loadCell;
@end

NS_ASSUME_NONNULL_END
