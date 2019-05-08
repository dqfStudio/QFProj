//
//  HTextField.h
//  QFProj
//
//  Created by wind on 2019/5/8.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWebButtonView.h"

typedef void(^HTextFieldBlock)(HWebButtonView *webButtonView);

@interface HTextField : UITextField <UITextFieldDelegate>
@property (nonatomic) UILabel *leftLabel;
@property (nonatomic) UILabel *rightLabel;

@property (nonatomic) HWebButtonView *leftButton;
@property (nonatomic) HWebButtonView *rightButton;
@property (nonatomic, copy) HTextFieldBlock leftButtonBlock;
@property (nonatomic, copy) HTextFieldBlock rightButtonBlock;

@property (nonatomic) UIEdgeInsets leftInsets;
@property (nonatomic) UIEdgeInsets rightInsets;

@property (nonatomic) UIColor *placeholderColor;
@property (nonatomic) NSInteger maxInput;//最大输入限制，小于等于0表示不限制，默认为0
@property (nonatomic) BOOL forbidPaste;//禁止粘贴，默认为NO
@property (nonatomic) BOOL forbidWhitespaceAndNewline;//禁止输入空格和换行符，默认为YES

@end
