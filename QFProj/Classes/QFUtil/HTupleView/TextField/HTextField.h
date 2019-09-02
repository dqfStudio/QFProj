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

@property (nonatomic) UIFont  *placeholderFont;
@property (nonatomic) UIColor *placeholderColor;

@property (nonatomic) NSInteger maxInput;//最大输入限制，小于等于0表示不限制，默认为0
@property (nonatomic) BOOL forbidPaste;//禁止粘贴，默认为NO
@property (nonatomic) BOOL forbidWhitespaceAndNewline;//禁止输入空格和换行符，默认为YES
@property (nonatomic) BOOL editEnabled;//是否可编辑，默认为YES
@end

@interface HTextField (HValidate)

// 字母与数字的组合，长度6-11位
@property (nonatomic, readonly, getter=isValidatedUserName) BOOL validatedUserName; //是否有效的用户名
// 字母与数字的组合，长度6-12位
@property (nonatomic, readonly, getter=isValidatedPassword) BOOL validatedPassword; //是否有效的密码

@property (nonatomic, readonly, getter=isOnlyAlpha) BOOL onlyAlpha; //纯字母
@property (nonatomic, readonly, getter=isOnlyNumeric) BOOL onlyNumeric; //纯数字
@property (nonatomic, readonly, getter=isAlphaNumeric) BOOL alphaNumeric; //字母与数字的组合

@property (nonatomic, readonly, getter=isValidatedEmial) BOOL validatedEmial; //是否有效的邮箱
@property (nonatomic, readonly, getter=isValidatedVCode) BOOL validatedVCode; //是否有效的验证码
@property (nonatomic, readonly, getter=isValidatedMobile) BOOL validatedMobile; //是否有效的手机号
@property (nonatomic, readonly, getter=isValidatedIDCard) BOOL validatedIDCard; //是否有效的身份证号

@property (nonatomic, readonly, getter=isOnlyChinese) BOOL onlyChinese; //纯中文
// 微信号校验 可以使用6—20个字母、数字、下划线和减号，必须以字母开头
@property (nonatomic, readonly, getter=isValidatedWechat) BOOL validatedWechat; //是否有效的微信号
@property (nonatomic, readonly, getter=isValidatedBankCard) BOOL validatedBankCard; //是否有效的银行卡账号

@property (nonatomic, readonly, getter=isContainIllegalCharacters) BOOL containIllegalCharacters; //是否包含特殊字符

@end
