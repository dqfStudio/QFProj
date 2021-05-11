//
//  HUserLocale.m
//  QFProj
//
//  Created by Wind on 2021/5/10.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HUserLocale.h"

@implementation HUserLocale
+ (HUserLocale *)locale {
    static HUserLocale *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
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
    if ([[NSLocale ISOCountryCodes] containsObject:super.countryCode]) {
        return super.countryName;
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
- (NSString *)silverCode {
    return @"SILVER";
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
- (NSInteger)localeLanguageCodeIndex {
    NSInteger index = -1;
#if DEBUG
    if ([self.languageCode isEqualToString:@""]) { index = 0; }
    else if ([self.languageCode isEqualToString:@"zh-Hans"]) { index = 0; }
    else if ([self.languageCode isEqualToString:@"en"]) { index = 1; }
    else if ([self.languageCode containsString:@"vi"]) { index = 2; }
    else if ([self.languageCode isEqualToString:@"en-IN"]) { index = 3; }
#else
    if ([self.languageCode isEqualToString:@""]) { index = 0; }
    else if ([self.languageCode isEqualToString:@"en"]) { index = 0; }
    else if ([self.languageCode containsString:@"vi"]) { index = 1; }
    else if ([self.languageCode isEqualToString:@"en-IN"]) { index = 2; }
    else if ([self.languageCode isEqualToString:@"zh-Hant"]) { index = 3; }
    else if ([self.languageCode isEqualToString:@"ja"]) { index = 4; }
    else if ([self.languageCode isEqualToString:@"ko"]) { index = 5; }
#endif
    return index;
}
- (NSInteger)localeCountryNameIndex {
    NSInteger index = -1;
    if ([self.countryName isEqualToString:@"Vietnam"]) { index = 0; }
    else if ([self.countryName isEqualToString:@"India"]) { index = 1; }
//    else if ([userRegion isEqualToString:@"Silver"]) { index = 2; }
    else { index = 2; }
    return index;
}
@end
