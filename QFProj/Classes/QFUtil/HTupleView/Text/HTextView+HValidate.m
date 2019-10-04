//
//  HTextView+HValidate.m
//  QFProj
//
//  Created by wind on 2019/9/3.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTextView+HValidate.h"

@implementation HTextView (HValidate)

- (BOOL)isValidatedUserName {
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,11}$";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isValidatedPassword {
    NSString *regex = @"[a-zA-Z0-9]{6,12}$";
    return [self isValidateWithRegex:regex];
}


- (BOOL)isEmpty {
    return (self.text.length == 0);
}
- (BOOL)isOnlyAlpha {
    NSString *regex = @"[a-zA-Z]+$";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isOnlyNumeric {
    NSString *regex = @"[0-9]+$";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isAlphaNumeric {
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{2,}$";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isAlphaOrNumeric {
    NSString *regex = @"^[a-zA-Z0-9]+$";
    return [self isValidateWithRegex:regex];
}



- (BOOL)isValidatedEmial {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isValidatedVCode {
    NSString *regex = @"[0-9]{4,6}$";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isValidatedMobile {
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 16[6], 17[5, 6, 7, 8], 18[0-9], 170[0-9], 19[89]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705,198
     * 联通号段: 130,131,132,155,156,185,186,145,175,176,1709,166
     * 电信号段: 133,153,180,181,189,177,1700,199
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|6[6]|7[05-8]|8[0-9]|9[89])\\d{8}$";
    
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478]|9[8])\\d{8}$)|(^1705\\d{7}$)";
    
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|66|7[56]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    
    NSString *CT = @"(^1(33|53|77|8[019]|99)\\d{8}$)|(^1700\\d{7}$)";
    
    if([self isValidateWithRegex:MOBILE] || [self isValidateWithRegex:CM] || [self isValidateWithRegex:CU] || [self isValidateWithRegex:CT]) {
        return YES;
    }else {
        return NO;
    }
}
- (BOOL)isValidatedIDCard {
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [self isValidateWithRegex:regex];
}



- (BOOL)isValidatedCarNo {
    NSString *regex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isValidatedCarType {
    NSString *regex = @"^[\u4E00-\u9FFF]+$";
    return [self isValidateWithRegex:regex];
}



- (BOOL)isOnlyChinese {
    NSString *regex = @"[\u4e00-\u9fa5]+$";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isValidatedWechat {
    NSString *regex = @"^[a-zA-Z]([-_a-zA-Z0-9]{5,19})+$";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isValidatedBankCard {
    NSString *regex = @"[1-9]([0-9]{13,19})";
    return [self isValidateWithRegex:regex];
}
- (BOOL)isContainIllegalCharacters {
    NSString *regex = @"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    //此处结果取反
    return ![self isValidateWithRegex:regex];
}



- (BOOL (^)(NSInteger length))isEqualto {
    return ^BOOL (NSInteger length) {
        if (self.text.length == length) {
            return YES;
        }
        return NO;
    };
}
- (BOOL (^)(NSInteger start, NSInteger end))isBetween {
    return ^BOOL (NSInteger start, NSInteger end) {
        if (self.text.length >= start && self.text.length <= end) {
            return YES;
        }
        return NO;
    };
}
- (BOOL)isValidateWithRegex:(NSString *)regex {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex] evaluateWithObject:self.text];
}
@end
