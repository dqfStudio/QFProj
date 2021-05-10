//
//  HUserLocale.m
//  QFProj
//
//  Created by Wind on 2021/5/10.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HUserLocale.h"

@implementation HUserLocale
- (NSString *)localeIdentifier {
    return [[super.languageCode stringByAppendingString:@"-"] stringByAppendingString:super.countryCode];
}
- (NSString *)countryCode {
    NSString *localeIdentifier = self.localeIdentifier;
    if ([localeIdentifier hasSuffix:super.countryCode]) {
        localeIdentifier = [localeIdentifier substringFromIndex:localeIdentifier.length-super.countryCode.length];
    }
    return localeIdentifier.uppercaseString;
}
- (void)setCountryCode:(NSString *)countryCode {
    NSArray *countryCodeArray = @[@"VN", @"IN"];
    if (![countryCodeArray containsObject:countryCode]) {
        if ([countryCode.uppercaseString isEqual:@"SILVER"]) {
            countryCode = @"SILVER";
        }else {
            countryCode = @"OTHERS";
        }
    }
    super.countryCode = countryCode;
}
- (NSString *)countryName {
    NSString *name = super.countryName;
    NSArray *countryNameArray = @[@"Vietnam", @"India"];
    if ([countryNameArray containsObject:name]) {
        return name;
    }else {
        NSString *localeIdentifier = self.localeIdentifier;
        if ([localeIdentifier hasSuffix:super.countryCode]) {
            localeIdentifier = [localeIdentifier substringFromIndex:localeIdentifier.length-super.countryCode.length];
        }
        if ([localeIdentifier isEqual:@"SILVER"]) {
            localeIdentifier = @"Silver";
        }else {
            localeIdentifier = @"Others";
        }
        return localeIdentifier;
    }
}
- (NSString *)localeLanguageName {
    NSString *defaultLanguageName = @"";
    if ([self.languageCode isEqualToString:@"zh-Hans"]) { defaultLanguageName = @"简体中文"; }
    else if ([self.languageCode isEqualToString:@"zh-Hant"]) { defaultLanguageName = @"繁體中文"; }
    else if ([self.languageCode isEqualToString:@"en"]) { defaultLanguageName = @"English"; }
    else if ([self.languageCode isEqualToString:@"ja"]) { defaultLanguageName = @"日本語"; }
    else if ([self.languageCode isEqualToString:@"ko"]) { defaultLanguageName = @"한국어"; }
    else if ([self.languageCode containsString:@"vi"]) { defaultLanguageName = @"Tiếng Việt"; }
    else if ([self.languageCode isEqualToString:@"en-IN"]) { defaultLanguageName = @"भारत गणराज्य"; }
    return defaultLanguageName;
}
- (NSString *)localeLanguageCode {
    NSString *defaultLanguageCode = @"";
    if ([self.languageCode isEqualToString:@"zh-Hans"]) { defaultLanguageCode = @"CN"; }
    else if ([self.languageCode isEqualToString:@"zh-Hant"]) { defaultLanguageCode = @""; }
    else if ([self.languageCode isEqualToString:@"en"]) { defaultLanguageCode = @"EN"; }
    else if ([self.languageCode isEqualToString:@"ja"]) { defaultLanguageCode = @""; }
    else if ([self.languageCode isEqualToString:@"ko"]) { defaultLanguageCode = @""; }
    else if ([self.languageCode containsString:@"vi"]) { defaultLanguageCode = @"VN"; }
    else if ([self.languageCode isEqualToString:@"en-IN"]) { defaultLanguageCode = @"IN"; }
    else { defaultLanguageCode = @"CN"; }
    return defaultLanguageCode;
}
@end
