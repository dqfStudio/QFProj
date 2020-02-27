//
//  HTupleViewBannerCell.h
//  QFProj
//
//  Created by dqf on 2020/1/31.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HTupleBaseCell.h"

typedef void(^HTupleViewBannerCellBlock)(NSInteger index);

@interface HTupleViewBannerCell : HTupleBaseCell
@property (nonatomic, copy) NSArray *imageUrlArr;
@property (nonatomic, copy) HTupleViewBannerCellBlock selectedBannerBlock;
@end
