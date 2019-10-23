//
//  HTupleViewCell.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleBaseCell.h"
#import "HWebButtonView.h"
#import "HWebImageView.h"
#import "HTupleView.h"
#import "HTextField.h"
#import "HTextView.h"
#import "HLabel.h"

@class HTupleView;

@interface HTupleBlankCell : HTupleBaseCell
@property (nonatomic) UIView *view;
@end

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

@interface HTupleViewCell : HTupleBaseCell
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
