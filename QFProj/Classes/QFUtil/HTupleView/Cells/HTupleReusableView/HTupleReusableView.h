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
