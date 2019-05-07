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
@property (nonatomic) UITextField *textField;
@property (nonatomic) UILabel *leftLabel;
@property (nonatomic) UILabel *rightLabel;

@property (nonatomic) HWebButtonView *leftButton;
@property (nonatomic) HWebButtonView *rightButton;
@property (nonatomic, copy) HReusableButtonViewBlock leftButtonBlock;
@property (nonatomic, copy) HReusableButtonViewBlock rightButtonBlock;

@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic) UIColor *placeholderColor;
@property (nonatomic) NSInteger maxInput;//最大输入限制，小于等于0表示不限制，默认为0
@property (nonatomic) BOOL forbidPaste;//禁止粘贴，默认为NO
@property (nonatomic) BOOL forbidWhitespaceAndNewline;//禁止输入空格和换行符，默认为YES
@end

@interface HReusableVerticalView : HTupleBaseCell
@property (nonatomic) HTupleView *tuple;
@end

@interface HReusableHorizontalView : HTupleBaseCell
@property (nonatomic) HTupleView *tuple;
@end
