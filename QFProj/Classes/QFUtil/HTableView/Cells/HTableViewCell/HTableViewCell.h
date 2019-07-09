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

@interface HTableLabelCell : HTableBaseCell
@property (nonatomic) HLabel *label;
@end

@interface HTableTextCell : HTableBaseCell
@property (nonatomic) HTextView *textView;
@end

@interface HTableButtonCell : HTableBaseCell
@property (nonatomic) HWebButtonView *webButtonView;
@end

@interface HTableImageCell : HTableBaseCell
@property (nonatomic) HWebImageView *webImageView;
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

@interface HTableUnionCell : HTableBaseCell
@property (nonatomic) HLabel *headerLabel;
@property (nonatomic) HLabel *sectionLabel;
@property (nonatomic) HLabel *footerLabel;

@property (nonatomic) HTextView *headerTextView;
@property (nonatomic) HTextView *sectionTextView;
@property (nonatomic) HTextView *footerTextView;

@property (nonatomic) HWebButtonView *headerButton;
@property (nonatomic) HWebButtonView *sectionButton;
@property (nonatomic) HWebButtonView *footerButton;

@property (nonatomic) HWebImageView *headerImageView;
@property (nonatomic) HWebImageView *sectionImageView;
@property (nonatomic) HWebImageView *footerImageView;

@property (nonatomic) HTextField *headerTextField;
@property (nonatomic) HTextField *sectionTextField;
@property (nonatomic) HTextField *footerTextField;
@end
