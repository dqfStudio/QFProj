//
//  HRightImageCell.h
//  MGMobileMusic
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HBaseCell.h"

@interface HRightImageCell : HBaseCell
@property (nonatomic) UIImageView *rightImageView;
- (void)resetRightImageViewSize:(CGSize)size;
@end
