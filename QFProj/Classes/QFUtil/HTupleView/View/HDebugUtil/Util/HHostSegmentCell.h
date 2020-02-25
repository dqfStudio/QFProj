//
//  HHostSegmentCell.h
//  QFProj
//
//  Created by dqf on 2018/8/23.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"

typedef void (^HSegmentBlock)(NSInteger index);

@interface HHostSegmentCell : HTupleLabelCell
@property (nonatomic, copy) HSegmentBlock segmentBlock;
@property (nonatomic) NSInteger selectedIndex;
@end
