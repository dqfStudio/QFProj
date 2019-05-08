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

@class HButtonViewCell, HImageViewCell, HTupleView;

typedef void(^HButtonViewBlock)(HWebButtonView *webButtonView, HButtonViewCell *buttonCell);
typedef void(^HImageViewBlock)(HWebImageView *webImageView, HImageViewCell *imageCell);

@interface HViewCell : HTupleBaseCell
@property (nonatomic) UIView *view;
@end

@interface HLabelViewCell : HTupleBaseCell
@property (nonatomic) HLabel *label;
@end

@interface HTextViewCell : HTupleBaseCell
@property (nonatomic) HTextView *textView;
@end

@interface HButtonViewCell : HTupleBaseCell
@property (nonatomic) HWebButtonView *buttonView;
@property (nonatomic, copy) HButtonViewBlock buttonViewBlock;
@end

@interface HImageViewCell : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic, copy) HImageViewBlock imageViewBlock;
@end

@interface HTextFieldCell : HTupleBaseCell
@property (nonatomic) HTextField *textField;
@end

@interface HTupleVerticalCell : HTupleBaseCell
@property (nonatomic) HTupleView *tuple;
@end

@interface HTupleHorizontalCell : HTupleBaseCell
@property (nonatomic) HTupleView *tuple;
@end
