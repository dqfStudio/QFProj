//
//  HTupleViewCellDetail.h
//  QFProj
//
//  Created by wind on 2019/9/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCellBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTupleViewCellDetail1 : HTupleViewCellBase
@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
- (void)loadCell;
@end

@interface HTupleViewCellDetail2 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
- (void)loadCell;
@end

@interface HTupleViewCellDetail3 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
@property (nonatomic) HWebImageView *accessoryView;
- (void)loadCell;
@end

@interface HTupleViewCellDetail4 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
@property (nonatomic) HWebImageView *detailView;
@property (nonatomic) HWebImageView *accessoryView;
- (void)loadCell;
@end

NS_ASSUME_NONNULL_END
