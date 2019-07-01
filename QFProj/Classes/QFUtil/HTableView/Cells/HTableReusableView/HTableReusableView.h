//
//  HTableReusableView.h
//  QFProj
//
//  Created by wind on 2019/4/12.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTableBaseView.h"
#import "HTupleView.h"
#import "HLabel.h"

@interface HTableReusableLabelView : HTableBaseView
@property (nonatomic) HLabel *label;
@end

@interface HTableReusableTextView : HTupleBaseCell
@property (nonatomic) HTextView *textView;
@end

@interface HTableReusableButtonView : HTupleBaseCell
@property (nonatomic) HWebButtonView *buttonView;
@end

@interface HTableReusableImageView : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView;
@end

@interface HTableReusableTextField : HTupleBaseCell
@property (nonatomic) HTextField *textField;
@end

@interface HTableReusableVerticalView : HTableBaseView
@property (nonatomic) HTupleView *tuple;
@end

@interface HTableReusableHorizontalView : HTableBaseView
@property (nonatomic) HTupleView *tuple;
@end

@interface HTableReusableView : HTableBaseView
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
