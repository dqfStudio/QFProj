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

@interface HTableViewCellValue1 : HTableBaseCell

@end

@interface HTableViewCellValue2 : HTableBaseCell

@end

@interface HTableViewCellSubtitle : HTableBaseCell

@end

@interface HTableLabelCell : HTableBaseCell
@property (nonatomic) HLabel *label;
@end

@interface HTableTextViewCell : HTupleBaseCell
@property (nonatomic) HTextView *textView;
@end

@interface HTableButtonViewCell : HTupleBaseCell
@property (nonatomic) HWebButtonView *buttonView;
@end

@interface HTableImageViewCell : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView;
@end

@interface HTableTextFieldCell : HTupleBaseCell
@property (nonatomic) HTextField *textField;
@end

@interface HTableVerticalCell : HTableBaseCell
@property (nonatomic) HTupleView *tuple;
@end

@interface HTableHorizontalCell : HTableBaseCell
@property (nonatomic) HTupleView *tuple;
@end

@interface HTableViewCell : HTableBaseCell
@property (nonatomic) HLabel *leftLabel;
@property (nonatomic) HLabel *middleLabel;
@property (nonatomic) HLabel *rightLabel;

@property (nonatomic) HTextView *leftTextView;
@property (nonatomic) HTextView *middleTextView;
@property (nonatomic) HTextView *rightTextView;

@property (nonatomic) HWebButtonView *leftButton;
@property (nonatomic) HWebButtonView *middleButton;
@property (nonatomic) HWebButtonView *rightButton;

@property (nonatomic) HWebImageView *leftImageView;
@property (nonatomic) HWebImageView *middleImageView;
@property (nonatomic) HWebImageView *rightImageView;

@property (nonatomic) HTextField *leftTextField;
@property (nonatomic) HTextField *middleTextField;
@property (nonatomic) HTextField *rightTextField;
@end
