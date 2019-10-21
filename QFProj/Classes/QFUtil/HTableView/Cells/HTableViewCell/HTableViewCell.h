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

@interface HTableCellValue1 : HTableBaseCell

@end

@interface HTableCellValue2 : HTableBaseCell

@end

@interface HTableCellSubtitle : HTableBaseCell

@end

@interface HTableBlankCell : HTableBaseCell
@property (nonatomic) UIView *view;
@end

@interface HTableLabelCell : HTableBaseCell
@property (nonatomic) HLabel *label;
@end

@interface HTableTextCell : HTableBaseCell
@property (nonatomic) HTextView *textView;
@end

@interface HTableButtonCell : HTableBaseCell
@property (nonatomic) HWebButtonView *buttonView;
@end

@interface HTableImageCell : HTableBaseCell
@property (nonatomic) HWebImageView *imageView;
@end

@interface HTableTextFieldCell : HTableBaseCell
@property (nonatomic) HTextField *textField;
@end

@interface HTableVerticalCell : HTableBaseCell
@property (nonatomic) HTupleView *tupleView;
@end

@interface HTableHorizontalCell : HTableBaseCell
@property (nonatomic) HTupleView *tupleView;
@end

@interface HTableViewCell : HTableBaseCell
@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
@property (nonatomic) HLabel *accessoryLabel;

@property (nonatomic) HTextView *textView;
@property (nonatomic) HTextView *detailTextView;
@property (nonatomic) HTextView *accessoryTextView;

@property (nonatomic) HWebButtonView *buttonView;
@property (nonatomic) HWebButtonView *detailButtonView;
@property (nonatomic) HWebButtonView *accessoryButtonView;

@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HWebImageView *detailImageView;
@property (nonatomic) HWebImageView *accessoryImageView;

@property (nonatomic) HTextField *textField;
@property (nonatomic) HTextField *detailTextField;
@property (nonatomic) HTextField *accessoryTextField;
@end
