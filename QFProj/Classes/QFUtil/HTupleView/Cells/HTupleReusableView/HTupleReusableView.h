//
//  HTupleReusableView.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleBaseView.h"
#import "HWebImageView.h"
#import "HWebButtonView.h"
#import "HTupleView.h"
#import "HTextField.h"
#import "HTextView.h"
#import "HLabel.h"

@class HTupleView;

@interface HTupleLabelView : HTupleBaseView
@property (nonatomic) HLabel *label;
@end

@interface HTupleTextView : HTupleBaseView
@property (nonatomic) HTextView *textView;
@end

@interface HTupleButtonView : HTupleBaseView
@property (nonatomic) HWebButtonView *buttonView;
@end

@interface HTupleImageView : HTupleBaseView
@property (nonatomic) HWebImageView *imageView;
@end

@interface HTupleTextFieldView : HTupleBaseView
@property (nonatomic) HTextField *textField;
@end

@interface HTupleVerticalView : HTupleBaseView
@property (nonatomic) HTupleView *tupleView;
@end

@interface HTupleHorizontalView : HTupleBaseView
@property (nonatomic) HTupleView *tupleView;
@end

@interface HTupleUnionView : HTupleBaseView
@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
@property (nonatomic) HLabel *accessoryLabel;

@property (nonatomic) HTextView *textView;
@property (nonatomic) HTextView *detailTextView;
@property (nonatomic) HTextView *accessoryTextView;

@property (nonatomic) HWebButtonView *button;
@property (nonatomic) HWebButtonView *detailButton;
@property (nonatomic) HWebButtonView *accessoryButton;

@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HWebImageView *detailImageView;
@property (nonatomic) HWebImageView *accessoryImageView;

@property (nonatomic) HTextField *textField;
@property (nonatomic) HTextField *detailTextField;
@property (nonatomic) HTextField *accessoryTextField;
@end
