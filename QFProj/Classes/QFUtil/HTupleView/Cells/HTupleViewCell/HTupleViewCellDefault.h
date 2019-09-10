//
//  HTupleViewCellDefault.h
//  QFProj
//
//  Created by wind on 2019/9/9.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCellBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTupleViewCellDefault1 : HTupleViewCellBase
@property (nonatomic) HLabel *label;
- (void)loadCell;
@end

@interface HTupleViewCellDefault2 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HLabel *label;
- (void)loadCell;
@end

@interface HTupleViewCellDefault3 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HLabel *label;
@property (nonatomic) HWebImageView *accessoryView;
- (void)loadCell;
@end

@interface HTupleViewCellDefault4 : HTupleViewCellBase
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HLabel *label;
@property (nonatomic) HWebImageView *detailView;
@property (nonatomic) HWebImageView *accessoryView;
- (void)loadCell;
@end

NS_ASSUME_NONNULL_END
