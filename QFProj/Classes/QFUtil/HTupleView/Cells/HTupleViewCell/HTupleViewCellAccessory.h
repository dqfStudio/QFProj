//
//  HTupleViewCellAccessory.h
//  QFProj
//
//  Created by wind on 2019/9/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCellBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTupleViewCellAccessory1 : HTupleViewCellBase
@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
@property (nonatomic) HLabel *accessoryLabel;
- (void)loadCell;
@end

@interface HTupleViewCellAccessory2 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
@property (nonatomic) HLabel *accessoryLabel;
- (void)loadCell;
@end

@interface HTupleViewCellAccessory3 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
@property (nonatomic) HLabel *accessoryLabel;
@property (nonatomic) HWebImageView *accessoryView;
- (void)loadCell;
@end

@interface HTupleViewCellAccessory4 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
@property (nonatomic) HLabel *accessoryLabel;
@property (nonatomic) HWebImageView *detailView;
@property (nonatomic) HWebImageView *accessoryView;
- (void)loadCell;
@end

NS_ASSUME_NONNULL_END
