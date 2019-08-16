//
//  HTextField.h
//  QFProj
//
//  Created by wind on 2019/5/8.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLabel.h"
#import "HWebImageView.h"
#import "HWebButtonView.h"

@interface HTextField : UITextField <UITextFieldDelegate>
@property (nonatomic) HLabel *leftLabel;
@property (nonatomic) HLabel *rightLabel;

@property (nonatomic) HWebImageView *leftImageView;
@property (nonatomic) HWebImageView *rightImageView;

@property (nonatomic) HWebButtonView *leftButton;
@property (nonatomic) HWebButtonView *rightButton;

@property (nonatomic) UIEdgeInsets leftInsets;
@property (nonatomic) UIEdgeInsets rightInsets;

@property (nonatomic) UIColor *placeholderColor;
@property (nonatomic) NSInteger maxInput;//最大输入限制，小于等于0表示不限制，默认为0
@property (nonatomic) BOOL forbidPaste;//禁止粘贴，默认为NO
@property (nonatomic) BOOL forbidWhitespaceAndNewline;//禁止输入空格和换行符，默认为YES
@property (nonatomic) BOOL editEnabled;//是否可编辑，默认为YES
@end
