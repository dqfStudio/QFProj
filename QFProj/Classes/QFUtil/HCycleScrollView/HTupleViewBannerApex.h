//
//  HTupleViewBannerApex.h
//  QFProj
//
//  Created by wind on 2020/1/31.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HTupleBaseApex.h"

typedef void(^HTupleViewBannerApexBlock)(NSInteger index);

@interface HTupleViewBannerApex : HTupleBaseApex
@property (nonatomic, copy) NSArray *imageUrlArr;
@property (nonatomic, copy) HTupleViewBannerApexBlock selectedBannerBlock;
@end
