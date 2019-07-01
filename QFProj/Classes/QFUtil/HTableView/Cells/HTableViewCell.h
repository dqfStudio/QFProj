//
//  HTableViewCell.h
//  MGMobileMusic
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HTableBaseCell.h"
#import "HTupleView.h"
#import "HLabel.h"

@interface HTableViewCell : HTableBaseCell

@end

@interface HTableViewCellValue1 : HTableBaseCell

@end

@interface HTableViewCellValue2 : HTableBaseCell

@end

@interface HTableViewCellSubtitle : HTableBaseCell

@end

@interface HTableLabelCell : HTableBaseCell
@property (nonatomic) HLabel *label;
@end

@interface HTableVerticalCell : HTableBaseCell
@property (nonatomic) HTupleView *tuple;
@end

@interface HTableHorizontalCell : HTableBaseCell
@property (nonatomic) HTupleView *tuple;
@end