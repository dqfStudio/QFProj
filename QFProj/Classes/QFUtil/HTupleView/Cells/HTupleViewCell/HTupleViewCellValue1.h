//
//  HTupleViewCellValue1.h
//  QFProj
//
//  Created by wind on 2019/9/10.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCellBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTupleViewCellValue1 : HTupleViewCellBase
@property (nonatomic) CGFloat leftWidth;
@property (nonatomic) CGFloat rightWidth;

@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
@property (nonatomic) HLabel *accessoryLabel;
@end

NS_ASSUME_NONNULL_END
