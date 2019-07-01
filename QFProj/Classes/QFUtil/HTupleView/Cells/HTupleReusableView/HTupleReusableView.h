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

@interface HTupleReusableLabelView : HTupleBaseCell
@property (nonatomic) HLabel *label;
@end

@interface HTupleReusableTextView : HTupleBaseView
@property (nonatomic) HTextView *textView;
@end

@interface HTupleReusableButtonView : HTupleBaseView
@property (nonatomic) HWebButtonView *buttonView;
@end

@interface HTupleReusableImageView : HTupleBaseView
@property (nonatomic) HWebImageView *imageView;
@end

@interface HTupleReusableTextField : HTupleBaseView
@property (nonatomic) HTextField *textField;
@end

@interface HTupleReusableVerticalView : HTupleBaseCell
@property (nonatomic) HTupleView *tuple;
@end

@interface HTupleReusableHorizontalView : HTupleBaseCell
@property (nonatomic) HTupleView *tuple;
@end

@interface HTupleReusableView : HTupleBaseView
@property (nonatomic) HLabel *leftLabel;
@property (nonatomic) HLabel *rightLabel;

@property (nonatomic) HTextView *leftTextView;
@property (nonatomic) HTextView *rightTextView;

@property (nonatomic) HWebButtonView *leftButton;
@property (nonatomic) HWebButtonView *rightButton;

@property (nonatomic) HWebImageView *leftImageView;
@property (nonatomic) HWebImageView *rightImageView;

@property (nonatomic) HTextField *leftTextField;
@property (nonatomic) HTextField *rightTextField;
@end
