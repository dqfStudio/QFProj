//
//  HUserLocale2.m
//  QFProj
//
//  Created by Wind on 2021/5/12.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HUserLocale2.h"

#define KCountryNameKey         @"KCountryNameKey"
#define KLanguageCodeKey        @"KLanguageCodeKey"

@interface HUserLocale2 () {
    NSString *_languageCode;
    NSString *_countryCode;
    NSString *_countryName;
}
@property(nonatomic) NSDictionary *countryDict;
@property(nonatomic) NSDictionary *countryMapDict;
@end

@implementation HUserLocale2

+ (HUserLocale2 *)defaultLocale {
    static HUserLocale2 *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (NSDictionary *)countryDict {
    if (!_countryDict) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"countryInfo" ofType:@"json"];
        if (path) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            if (data) {
                id resource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([resource isKindOfClass:NSDictionary.class]) {
                    _countryDict = resource;
                }
            }
        }
    }
    return _countryDict;
}
- (NSDictionary *)countryMapDict {
    if (!_countryMapDict) {
        _countryMapDict = @{@"VN" : @"Vietnam", @"IN" : @"India", @"OTHERS" : @"Others"};
    }
    return _countryMapDict;
}

- (NSString *)localeIdentifier {
    return [[self.languageCode stringByAppendingString:@"-"] stringByAppendingString:self.countryCode];
}

- (NSString *)languageCode {
    if (!_languageCode) {
        NSString *defaultLanguageCode = [[NSUserDefaults standardUserDefaults] objectForKey:KLanguageCodeKey];
        if (!defaultLanguageCode) {
            for (NSDictionary *dict in self.countryDict.allValues) {
                NSString *languageCode = dict[@"languageCode"];
                if ([languageCode isEqualToString:[[NSLocale preferredLanguages] firstObject]]) {
                    [[NSUserDefaults standardUserDefaults] setObject:languageCode forKey:KLanguageCodeKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    defaultLanguageCode = languageCode;
                    break;
                }
            }
            if (!defaultLanguageCode) {
                NSDictionary *dict = self.countryDict.allValues.lastObject;
                NSString *languageCode = dict[@"languageCode"];
                [[NSUserDefaults standardUserDefaults] setObject:languageCode forKey:KLanguageCodeKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                defaultLanguageCode = languageCode;
            }
        }
        _languageCode = defaultLanguageCode;
    }
    return _languageCode;
}
- (void)setLanguageCode:(NSString *)languageCode {
    if (_languageCode != languageCode) {
        _languageCode = nil;
        _languageCode = languageCode;
        if (languageCode.length > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:languageCode forKey:KLanguageCodeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (NSString *)languageName {
//    NSString *languageName = @"";
//    if ([self.languageCode isEqualToString:@"zh-Hans"]) { languageName = @"简体中文"; }
//    else if ([self.languageCode isEqualToString:@"zh-Hant"]) { languageName = @"繁體中文"; }
//    else if ([self.languageCode isEqualToString:@"en"]) { languageName = @"English"; }
//    else if ([self.languageCode isEqualToString:@"ja"]) { languageName = @"日本語"; }
//    else if ([self.languageCode isEqualToString:@"ko"]) { languageName = @"한국어"; }
//    else if ([self.languageCode containsString:@"vi"]) { languageName = @"Tiếng Việt"; }
//    else if ([self.languageCode isEqualToString:@"en-IN"]) { languageName = @"भारत गणराज्य"; }
//    return languageName;
    NSString *languageName = [[NSLocale localeWithLocaleIdentifier:self.languageCode] localizedStringForLocaleIdentifier:self.languageCode];
    if ([languageName isEqualToString:@"en-IN"]) { languageName = @"भारत गणराज्य"; }
    return languageName ?: @"";
}



- (NSString *)countryCode {
    if (!_countryCode) {
        for (NSString *key in self.countryMapDict.allKeys) {
            NSString *value = self.countryMapDict[key];
            if ([value isEqualToString:self.countryName]) {
                _countryCode = [key mutableCopy];
                break;;
            }
        }
    }
    return _countryCode;
}

- (NSString *)countryName {
    if (!_countryName) {
        NSString *defaultCountryName = [[NSUserDefaults standardUserDefaults] objectForKey:KCountryNameKey];
        if (!defaultCountryName) {
            NSString *countryCode = [NSLocale autoupdatingCurrentLocale].countryCode;
            defaultCountryName = self.countryMapDict[countryCode];
            if (![self.countryDict.allKeys containsObject:defaultCountryName]) {
                defaultCountryName = self.countryDict.allKeys.lastObject;
            }
            [[NSUserDefaults standardUserDefaults] setObject:defaultCountryName forKey:KCountryNameKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        _countryName = defaultCountryName;
    }
    return _countryName;
}
- (void)setCountryName:(NSString *)countryName {
    if (_countryName != countryName) {
        _countryName = nil;
        _countryName = countryName;
        if (countryName && [self.countryDict.allKeys containsObject:countryName]) {
            [[NSUserDefaults standardUserDefaults] setObject:countryName forKey:KCountryNameKey];
        }else {
            NSString *countryCode = [NSLocale autoupdatingCurrentLocale].countryCode;
            if ([self.countryDict.allKeys containsObject:self.countryMapDict[countryCode]]) {
                [[NSUserDefaults standardUserDefaults] setObject:self.countryMapDict[countryCode] forKey:KCountryNameKey];
            }else {
                [[NSUserDefaults standardUserDefaults] setObject:self.countryDict.allKeys.lastObject forKey:KCountryNameKey];
            }
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)currencySymbol {
    NSDictionary *dict = [self.countryDict objectForKey:self.countryName];
    return dict[@"currencySymbol"];
}

- (NSString *)currencyCode {
    NSDictionary *dict = [self.countryDict objectForKey:self.countryName];
    return dict[@"currencyCode"];
}



- (NSString *)localeLanguageName {
//    NSString *defaultLanguageName = @"";
//    if ([self.languageCode isEqualToString:@"zh-Hans"]) { defaultLanguageName = @"简体中文"; }
//    else if ([self.languageCode isEqualToString:@"zh-Hant"]) { defaultLanguageName = @"繁體中文"; }
//    else if ([self.languageCode isEqualToString:@"en"]) { defaultLanguageName = @"English"; }
//    else if ([self.languageCode isEqualToString:@"ja"]) { defaultLanguageName = @"日本語"; }
//    else if ([self.languageCode isEqualToString:@"ko"]) { defaultLanguageName = @"한국어"; }
//    else if ([self.languageCode containsString:@"vi"]) { defaultLanguageName = @"Tiếng Việt"; }
//    else if ([self.languageCode isEqualToString:@"en-IN"]) { defaultLanguageName = @"भारत गणराज्य"; }
//    return defaultLanguageName;
    NSString *languageName = [[NSLocale localeWithLocaleIdentifier:self.languageCode] localizedStringForLocaleIdentifier:self.languageCode];
    if ([languageName isEqualToString:@"en-IN"]) { languageName = @"भारत गणराज्य"; }
    return languageName ?: @"";
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
    else { index = 2; }
    return index;
}

@end
