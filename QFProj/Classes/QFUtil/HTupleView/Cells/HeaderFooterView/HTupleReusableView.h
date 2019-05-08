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

@class HReusableButtonView, HReusableImageView, HTupleView;

typedef void(^HReusableButtonViewBlock)(HWebButtonView *webButtonView, HReusableButtonView *buttonView);
typedef void(^HReusableImageViewBlock)(HWebImageView *webImageView, HReusableImageView *imageView);

@interface HReusableView : HTupleBaseView
@property (nonatomic) UIView *view;
@end

@interface HReusableLabelView : HTupleBaseCell
@property (nonatomic) HLabel *label;
@end

@interface HReusableTextView : HTupleBaseView
@property (nonatomic) HTextView *textView;
@end

@interface HReusableButtonView : HTupleBaseView
@property (nonatomic) HWebButtonView *buttonView;
@property (nonatomic, copy) HReusableButtonViewBlock buttonViewBlock;
@end

@interface HReusableImageView : HTupleBaseView
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic, copy) HReusableImageViewBlock imageViewBlock;
@end

@interface HReusableTextFieldCell : HTupleBaseView
@property (nonatomic) HTextField *textField;
@end

@interface HReusableVerticalView : HTupleBaseCell
@property (nonatomic) HTupleView *tuple;
@end

@interface HReusableHorizontalView : HTupleBaseCell
@property (nonatomic) HTupleView *tuple;
@end
