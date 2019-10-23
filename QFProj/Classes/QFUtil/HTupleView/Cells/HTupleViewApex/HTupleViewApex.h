//
//  HTupleViewApex.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleBaseApex.h"
#import "HWebButtonView.h"
#import "HWebImageView.h"
#import "HTupleView.h"
#import "HTextField.h"
#import "HTextView.h"
#import "HLabel.h"

@class HTupleView;

@interface HTupleBlankApex : HTupleBaseApex
@property (nonatomic) UIView *view;
@end

@interface HTupleLabelApex : HTupleBaseApex
@property (nonatomic) HLabel *label;
@end

@interface HTupleTextApex : HTupleBaseApex
@property (nonatomic) HTextView *textView;
@end

@interface HTupleButtonApex : HTupleBaseApex
@property (nonatomic) HWebButtonView *buttonView;
@end

@interface HTupleImageApex : HTupleBaseApex
@property (nonatomic) HWebImageView *imageView;
@end

@interface HTupleTextFieldApex : HTupleBaseApex
@property (nonatomic) HTextField *textField;
@end

@interface HTupleViewApex : HTupleBaseApex
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
