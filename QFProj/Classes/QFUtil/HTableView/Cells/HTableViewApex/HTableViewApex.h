//
//  HTableViewApex.h
//  QFProj
//
//  Created by wind on 2019/4/12.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTableBaseApex.h"
#import "HTupleView.h"
#import "HLabel.h"

@interface HTableLabelView : HTableBaseApex
@property (nonatomic) HLabel *label;
@end

@interface HTableTextView : HTableBaseApex
@property (nonatomic) HTextView *textView;
@end

@interface HTableButtonView : HTableBaseApex
@property (nonatomic) HWebButtonView *buttonView;
@end

@interface HTableImageView : HTableBaseApex
@property (nonatomic) HWebImageView *imageView;
@end

@interface HTableTextFieldView : HTableBaseApex
@property (nonatomic) HTextField *textField;
@end

@interface HTableVerticalView : HTableBaseApex
@property (nonatomic) HTupleView *tupleView;
@end

@interface HTableHorizontalView : HTableBaseApex
@property (nonatomic) HTupleView *tupleView;
@end

@interface HTableUnionView : HTableBaseApex
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

@interface HTableViewApex : HTupleBaseApex
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HLabel *textLabel;
@property (nonatomic) HLabel *detailLabel;
@property (nonatomic) HLabel *accessoryLabel;
@property (nonatomic) HWebImageView *detailView;
@property (nonatomic) HWebImageView *accessoryView;
@end
