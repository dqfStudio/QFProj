//
//  HDeviceLocale.m
//  QFProj
//
//  Created by Wind on 2021/5/9.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HDeviceLocale.h"

@implementation HDeviceLocale

+ (HDeviceLocale *)locale {
    static HDeviceLocale *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (NSString *)localeIdentifier {
    return [NSLocale autoupdatingCurrentLocale].localeIdentifier;
}

- (NSString *)languageCode {
    //return [NSLocale autoupdatingCurrentLocale].languageCode;
    NSString *localeIdentifier = self.localeIdentifier;
    if ([localeIdentifier hasSuffix:self.countryCode]) {
        localeIdentifier = [localeIdentifier substringToIndex:localeIdentifier.length-self.countryCode.length-1];
    }
    return localeIdentifier;
}

- (NSString *)userLanguageCode {
    NSString *preferredLanguage = [[NSLocale preferredLanguages] firstObject];
    if ([preferredLanguage hasSuffix:self.countryCode]) {
        preferredLanguage = [preferredLanguage substringToIndex:preferredLanguage.length-self.countryCode.length-1];
    }
    return preferredLanguage;
}

- (NSString *)countryCode {
    return [NSLocale autoupdatingCurrentLocale].countryCode;
}

- (NSString *)decimalSeparator {
    return [NSLocale autoupdatingCurrentLocale].decimalSeparator;
}

- (NSString *)groupingSeparator {
    return [NSLocale autoupdatingCurrentLocale].groupingSeparator;
}

- (NSString *)currencySymbol {
    //return [NSLocale autoupdatingCurrentLocale].currencySymbol;
    return [self clearTheSymbolWithText:[NSLocale autoupdatingCurrentLocale].currencySymbol];
}

- (NSString *)currencyCode {
    return [NSLocale autoupdatingCurrentLocale].currencyCode;
}
//清除字母符号
- (NSString *)clearTheSymbolWithText:(NSString *)text {
    NSString *pattern = @"[a-zA-Z]";
    NSRegularExpression *regularExpress = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    return [regularExpress stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
}
@end
