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

@interface HTableBlankApex : HTableBaseApex
@property (nonatomic) UIView *view;
@end

@interface HTableLabelApex : HTableBaseApex
@property (nonatomic) HLabel *label;
@end

@interface HTableTextApex : HTableBaseApex
@property (nonatomic) HTextView *textView;
@end

@interface HTableButtonApex : HTableBaseApex
@property (nonatomic) HWebButtonView *buttonView;
@end

@interface HTableImageApex : HTableBaseApex
@property (nonatomic) HWebImageView *imageView;
@end

@interface HTableTextFieldApex : HTableBaseApex
@property (nonatomic) HTextField *textField;
@end

@interface HTableViewApex : HTableBaseApex
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
