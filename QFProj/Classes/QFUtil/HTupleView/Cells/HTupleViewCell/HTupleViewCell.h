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
#import "Masonry.h"
#import "UILabel+HAttributeText.h"

@class HButtonViewCell, HImageViewCell;

typedef void(^HButtonViewBlock)(HWebButtonView *webButtonView, HButtonViewCell *buttonCell);
typedef void(^HImageViewBlock)(HWebImageView *webImageView, HImageViewCell *imageCell);

@interface HViewCell : HTupleBaseCell
@property (nonatomic) UIView *view;
@end

@interface HLabelViewCell : HTupleBaseCell
@property (nonatomic) UILabel *label;
@end

@interface HTextViewCell : HTupleBaseCell
@property (nonatomic) UITextView *textView;
@end

@interface HTextFieldCell : HTupleBaseCell
@property (nonatomic) UITextField *textField;
@end

@interface HScrollViewCell : HTupleBaseCell
@property (nonatomic) UIScrollView *scrollView;
@end

@interface HButtonViewCell : HTupleBaseCell
@property (nonatomic) HWebButtonView *buttonView;
@property (nonatomic, copy) HButtonViewBlock buttonViewBlock;
@end

@interface HImageViewCell : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic, copy) HImageViewBlock imageViewBlock;
@end

@interface HText2ViewCell : HTupleBaseCell
@property (nonatomic) UILabel *leftLabel;
@property (nonatomic) UILabel *rightLabel;
@end

@interface HText3ViewCell : HTupleBaseCell
@property (nonatomic) UILabel *upLabel;
@property (nonatomic) UILabel *downLabel;
@end
