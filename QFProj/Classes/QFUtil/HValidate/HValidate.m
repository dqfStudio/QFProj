//
//  HValidate.m
//  HProjectModel1
//
//  Created by txkj_mac on 2018/9/26.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HValidate.h"

@implementation HValidate

//验证数字与字母的组合
+ (BOOL)isValidateAlphaNumeric:(NSString *)input {
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"^[a-zA-Z0-9]*$"
                                  options:NSRegularExpressionAnchorsMatchLines
                                  error:nil];
    
    NSUInteger numberOfMatches = [regex
                                  numberOfMatchesInString:input
                                  options:NSMatchingAnchored
                                  range:NSMakeRange(0, [input length])];
    if (numberOfMatches == 0) {
        return NO;
    }
    return YES;
}

//邮箱验证
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//密码验证
+ (BOOL)isValidatePass:(NSString *)password {
    NSString *passRegex = @"[a-zA-Z0-9]{6,12}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passRegex];;
    return [passwordTest evaluateWithObject:password];
}

//手机号验证
+ (BOOL)isValidateMobile:(NSString *)mobile {
//    //手机号以13， 15，18开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^[1][3,4,5,7,8]+\\d{9}$";
//    NSPredicate *phone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phone evaluateWithObject:mobile];
    //只校验第一位是否为1,并且共11位
    if (mobile.length == 11) {
        if ([[mobile substringToIndex:1] isEqualToString:@"1"]) {
            return YES;
        }
    }
    return NO;
}

//短信验证码验证
+ (BOOL)isValidateVCode:(NSString *)vCode {
    NSString *vCodeRegex = @"[0-9]{6}";
    NSPredicate *vCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",vCodeRegex];;
    return [vCodeTest evaluateWithObject:vCode];
    
}

//身份证验证
+ (BOOL)isIdentityCard:(NSString *)IDCardNumber {
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:IDCardNumber];
}

//银行卡
+ (BOOL)isBankCard:(NSString *)cardNumber {
    
    if(cardNumber.length == 0) {
        return NO;
    }
    
    NSString *digitsOnly = @"";
    char c;
    
    for (int i = 0; i < cardNumber.length; i++) {
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c)) {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--) {
        
        digit = [digitsOnly characterAtIndex:i] - '0';
        
        if (timesTwo) {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }else {
            addend = digit;
        }
        
        sum += addend;
        timesTwo = !timesTwo;
    }
    
    int modulus = sum % 10;
    return modulus == 0;
}

//判断是否含有非法字符 yes 有  no没有
+ (BOOL)judgeTheillegalCharacter:(NSString *)content {
    //提示 标签不能输入特殊字符
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}

+ (BOOL)deptNameInputShouldChinese:(NSString *)content {
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:content]) {
        return YES;
    }
    return NO;
    
}

@end
