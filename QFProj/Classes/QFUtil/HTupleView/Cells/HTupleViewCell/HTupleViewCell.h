//
//  HTupleViewCell.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleBaseCell.h"
#import "HAnimatedImageView.h"
#import "HWebButtonView.h"
#import "HWebImageView.h"
#import "HLabel+HUtil.h"
#import "HTupleView.h"
#import "HTextField.h"
#import "HTextView.h"
#import "HLabel.h"

@class HTupleView;

@interface HTupleBlankCell : HTupleBaseCell
@property (nonatomic) UIView *view;
@end

@interface HTupleLabelCell : HTupleBaseCell
@property (nonatomic) UILabel *label;
@end

@interface HTupleNoteCell : HTupleBaseCell
@property (nonatomic) HLabel *label;
@end

@interface HTupleTextCell : HTupleBaseCell
@property (nonatomic) UITextView *textView;
@end

@interface HTupleTextNoteCell : HTupleBaseCell
@property (nonatomic) HTextView *textView;
@end

@interface HTupleButtonCell : HTupleBaseCell
@property (nonatomic) HWebButtonView *buttonView;
@end

@interface HTupleImageCell : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView;
@end

@interface HTupleAnimatedImageCell : HTupleBaseCell
@property (nonatomic) HAnimatedImageView *imageView;
@end

@interface HTupleTextFieldCell : HTupleBaseCell
@property (nonatomic) HTextField *textField;
@end

@interface HTupleViewCell : HTupleBaseCell
@property (nonatomic) UILabel *label;
@property (nonatomic) UILabel *detailLabel;
@property (nonatomic) UILabel *accessoryLabel;

@property (nonatomic) HLabel *note;
@property (nonatomic) HLabel *detailNote;
@property (nonatomic) HLabel *accessoryNote;

@property (nonatomic) UITextView *textView;
@property (nonatomic) UITextView *detailTextView;
@property (nonatomic) UITextView *accessoryTextView;

@property (nonatomic) HTextView *textNote;
@property (nonatomic) HTextView *detailTextNote;
@property (nonatomic) HTextView *accessoryTextNote;

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
