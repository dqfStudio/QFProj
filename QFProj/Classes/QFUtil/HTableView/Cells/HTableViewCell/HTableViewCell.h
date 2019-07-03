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

@interface HTableTextViewCell : HTableBaseCell
@property (nonatomic) HTextView *textView;
@end

@interface HTableButtonViewCell : HTableBaseCell
@property (nonatomic) HWebButtonView *webButtonView;
@end

@interface HTableImageViewCell : HTableBaseCell
@property (nonatomic) HWebImageView *webImageView;
@end

@interface HTableTextFieldCell : HTableBaseCell
@property (nonatomic) HTextField *textField;
@end

@interface HTableVerticalCell : HTableBaseCell
@property (nonatomic) HTupleView *tuple;
@end

@interface HTableHorizontalCell : HTableBaseCell
@property (nonatomic) HTupleView *tuple;
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
