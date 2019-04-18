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
//#import <YYLabel.h>

@class HButtonViewCell, HImageViewCell, HTupleView;

typedef void(^HButtonViewBlock)(HWebButtonView *webButtonView, HButtonViewCell *buttonCell);
typedef void(^HImageViewBlock)(HWebImageView *webImageView, HImageViewCell *imageCell);

@interface HViewCell : HTupleBaseCell
@property (nonatomic) UIView *view;
@end

@interface HLabelViewCell : HTupleBaseCell
@property (nonatomic) UILabel *label;
//@property (nonatomic) YYLabel *label;
@end

@interface HTextViewCell : HTupleBaseCell
@property (nonatomic) UITextView *textView;
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
@property (nonatomic) UITextField *textField;
@property (nonatomic) UILabel *leftLabel;
@property (nonatomic) UILabel *rightLabel;

@property (nonatomic) HWebButtonView *leftButton;
@property (nonatomic) HWebButtonView *rightButton;
@property (nonatomic, copy) HButtonViewBlock leftButtonBlock;
@property (nonatomic, copy) HButtonViewBlock rightButtonBlock;

@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic) UIColor *placeholderColor;
@property (nonatomic) NSInteger maxInput;//最大输入限制，小于等于0表示不限制，默认为0
@property (nonatomic) BOOL forbidPaste;//禁止粘贴，默认为NO
@property (nonatomic) BOOL forbidWhitespaceAndNewline;//禁止输入空格和换行符，默认为YES
@end

@interface HTupleVerticalCell : HTupleBaseCell
@property (nonatomic) HTupleView *tuple;
@end

@interface HTupleHorizontalCell : HTupleBaseCell
@property (nonatomic) HTupleView *tuple;
@end
