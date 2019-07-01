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

@interface HTupleLabelViewCell : HTupleBaseCell
@property (nonatomic) HLabel *label;
@end

@interface HTupleTextViewCell : HTupleBaseCell
@property (nonatomic) HTextView *textView;
@end

@interface HTupleButtonViewCell : HTupleBaseCell
@property (nonatomic) HWebButtonView *buttonView;
@end

@interface HTupleImageViewCell : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView;
@end

@interface HTupleTextFieldCell : HTupleBaseCell
@property (nonatomic) HTextField *textField;
@end

@interface HTupleVerticalCell : HTupleBaseCell
@property (nonatomic) HTupleView *tuple;
@end

@interface HTupleHorizontalCell : HTupleBaseCell
@property (nonatomic) HTupleView *tuple;
@end

@interface HTupleViewCell : HTupleBaseCell
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
