//
//  HTextView+HValidate.h
//  QFProj
//
//  Created by wind on 2019/9/3.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTextView (HValidate)
// 须是字母与数字的组合，长度6-11位
@property (nonatomic, readonly) BOOL isValidatedUserName; //是否有效的用户名
// 字母、数字或其组合，长度6-12位
@property (nonatomic, readonly) BOOL isValidatedPassword; //是否有效的密码

@property (nonatomic, readonly) BOOL isEmpty; //是否为空

@property (nonatomic, readonly) BOOL isOnlyAlpha; //纯字母
@property (nonatomic, readonly) BOOL isOnlyNumeric; //纯数字
@property (nonatomic, readonly) BOOL isAlphaNumeric; //须是字母与数字的组合，默认验证2-10000位
@property (nonatomic, readonly) BOOL isAlphaOrNumeric; //字母、数字或两者的组合

@property (nonatomic, readonly) BOOL isValidatedEmial; //是否有效的邮箱
@property (nonatomic, readonly) BOOL isValidatedVCode; //是否有效的验证码
@property (nonatomic, readonly) BOOL isValidatedMobile; //是否有效的手机号
@property (nonatomic, readonly) BOOL isValidatedIDCard; //是否有效的身份证号

@property (nonatomic, readonly) BOOL isValidatedCarNo; //是否有效的车牌号
@property (nonatomic, readonly) BOOL isValidatedCarType; //是否有效的车型

@property (nonatomic, readonly) BOOL isOnlyChinese; //纯中文
// 微信号校验 可以使用6—20个字母、数字、下划线和减号，必须以字母开头
@property (nonatomic, readonly) BOOL isValidatedWechat; //是否有效的微信号
@property (nonatomic, readonly) BOOL isValidatedBankCard; //是否有效的银行卡账号

@property (nonatomic, readonly) BOOL isContainIllegalCharacters; //是否包含特殊字符

- (BOOL (^)(NSInteger length))isEqualto; //判断内容长度是否等于某个值
- (BOOL (^)(NSInteger start, NSInteger end))isBetween;//判断内容长度是否在某两个值之间
@end

NS_ASSUME_NONNULL_END
