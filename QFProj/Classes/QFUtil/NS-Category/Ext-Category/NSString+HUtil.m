//
//  NSString+HUtil.m
//  TestProject
//
//  Created by dqf on 2018/4/24.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "NSString+HUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (HUtil)

//用于测试阶段自动生成字符串
+ (NSString *)testString {
    NSString *mockString = @"太阳初升万物初始生之气最盛虽不能如传说中那般餐霞食气但这样迎霞锻体自也有莫大好处可充盈人体生机天之计在于晨每日早起多用功强筋壮骨活血炼筋将来才能在这苍莽山脉中有活命的本钱";
    int index = arc4random() % (mockString.length - 3);
    return [mockString substringWithRange:NSMakeRange(index, 3)];
}

+ (NSString *)leftArrowString {
    return @"‹";
}
+ (NSString *)rightArrowString {
    return @"›";
}
+ (NSString *)cancelString {
    return @"✕";
}
+ (NSString *)checkedString {
    return @"√";
}

- (id)JSONValue {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id res = [NSJSONSerialization JSONObjectWithData:data
                                             options:kNilOptions
                                               error:&error];
    if (error) return nil;
    else return res;
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)md5 {
    const char *concat_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, (CC_LONG)strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    return hash;
}

- (NSString *)encode {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *outputStr =
    (NSString *) CFBridgingRelease(
                                   CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (__bridge CFStringRef)self,
                                                                           NULL,
                                                                           (CFStringRef)@"!*'();:@&=-_+$,/?%#[]",
                                                                           kCFStringEncodingUTF8)
                                   );
    return outputStr;
#pragma clang diagnostic pop
}

- (NSString *)decode {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
}

//判断是否有emoji
- (BOOL)stringContainsEmoji {
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar high = [substring characterAtIndex: 0];
                              
                              // Surrogate pair (U+1D000-1F9FF)
                              if (0xD800 <= high && high <= 0xDBFF) {
                                  const unichar low = [substring characterAtIndex: 1];
                                  const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                  
                                  if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                      returnValue = YES;
                                  }
                                  
                                  // Not surrogate pair (U+2100-27BF)
                              } else {
                                  if (0x2100 <= high && high <= 0x27BF){
                                      returnValue = YES;
                                  }
                              }
                          }];
    
    return returnValue;
}

@end

