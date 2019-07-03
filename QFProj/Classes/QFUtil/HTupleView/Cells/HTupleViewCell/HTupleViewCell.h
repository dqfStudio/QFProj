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
