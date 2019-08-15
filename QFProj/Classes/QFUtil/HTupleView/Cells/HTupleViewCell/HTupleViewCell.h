//
//  HTupleViewCell.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleBaseCell.h"
#import "HWebImageView.h"
#import "HWebButtonView.h"
#import "HTupleView.h"
#import "HTextField.h"
#import "HTextView.h"
#import "HLabel.h"

@class HTupleView;

@interface HTupleLabelCell : HTupleBaseCell
@property (nonatomic) HLabel *label;
@end

@interface HTupleTextCell : HTupleBaseCell
@property (nonatomic) HTextView *textView;
@end

@interface HTupleButtonCell : HTupleBaseCell
@property (nonatomic) HWebButtonView *buttonView;
@end

@interface HTupleImageCell : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView;
@end

@interface HTupleTextFieldCell : HTupleBaseCell
@property (nonatomic) HTextField *textField;
@end

@interface HTupleVerticalCell : HTupleBaseCell
@property (nonatomic) HTupleView *tupleView;
@end

@interface HTupleHorizontalCell : HTupleBaseCell
@property (nonatomic) HTupleView *tupleView;
@end

@interface HTupleUnionCell : HTupleBaseCell
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

@interface HTupleViewCell : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HLabel *textLabel;
@property (nonatomic) HLabel *detailTextLabel;
@property (nonatomic) HLabel *accessoryLabel;
@property (nonatomic) HWebButtonView *detailView;
@property (nonatomic) HWebButtonView *accessoryView;
@end
