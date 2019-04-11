//
//  HValidate.h
//  HProjectModel1
//
//  Created by txkj_mac on 2018/9/26.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HValidate : NSObject

//验证数字与字母的组合
+ (BOOL)isValidateAlphaNumeric:(NSString *)input;

//邮箱验证
+ (BOOL)isValidateEmail:(NSString *)email;

//密码验证
+ (BOOL)isValidatePass:(NSString *)password;

//手机号验证
+ (BOOL)isValidateMobile:(NSString *)mobile;

//短信验证码验证
+ (BOOL)isValidateVCode:(NSString *)vCode;

//身份证验证
+ (BOOL)isIdentityCard:(NSString *)IDCardNumber;

//银行卡
+ (BOOL)isBankCard:(NSString *)cardNumber;

//判断是否含有非法字符 yes 有  no没有
+ (BOOL)judgeTheillegalCharacter:(NSString *)content;

//只输入中文
+ (BOOL)deptNameInputShouldChinese:(NSString *)content;

@end
