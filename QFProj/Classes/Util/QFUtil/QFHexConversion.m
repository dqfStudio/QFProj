//
//  QFHexConversion.m
//  TestProject
//
//  Created by dqf on 2017/9/23.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "QFHexConversion.h"

@implementation QFHexConversion

//普通字符串转换为十六进制字符串
+ (NSString *)hexStringFromString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[data bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for(int i=0; i<[data length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length] == 1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

//十六进制转换为普通字符串
+ (NSString *)convertHexStrToString:(NSString *)hexString {
    if (!hexString || [hexString length] == 0) {
        return nil;
    }
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
}

// 十六进制转二进制
+(NSString *)getBinaryByhex:(NSString *)hex {
    NSMutableDictionary  *hexDic = [[NSMutableDictionary alloc] init];
    hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    NSString *binaryString = [[NSString alloc] init];
    NSRange rage; rage.length = 1;
    for (int i=0; i<[hex length]; i++) {
        rage.location = i;
        NSString *key = [hex substringWithRange:rage];
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
    }
    return binaryString;
}

//十进制转十六进制
+ (NSString *)toHexString:(uint16_t)value {
    NSString *nLetterValue;
    NSString *str = @"";
    uint16_t tmpValue;
    for (int i = 0; i<9; i++) {
        tmpValue = value%16;
        value = value/16;
        switch (tmpValue) {
            case 10:
                nLetterValue = @"A"; break;
            case 11:
                nLetterValue = @"B"; break;
            case 12:
                nLetterValue = @"C"; break;
            case 13:
                nLetterValue = @"D"; break;
            case 14:
                nLetterValue = @"E"; break;
            case 15:
                nLetterValue = @"F"; break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",tmpValue];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (value == 0) {
            break;
        }
    }
    return str;
}

@end
