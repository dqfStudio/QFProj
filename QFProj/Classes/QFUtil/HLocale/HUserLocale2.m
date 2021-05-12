//
//  HUserLocale2.m
//  QFProj
//
//  Created by Wind on 2021/5/12.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HUserLocale2.h"

#define KCountryCodeKey   @"KCountryCodeKey"
#define KLanguageCodeKey  @"KLanguageCodeKey"

@interface HUserLocale2 () {
    NSString *_languageCode;
    NSString *_countryCode;
}
@property(nonatomic) NSDictionary *countryDict;
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
    return _countryDict;;
}

- (NSString *)languageCode {
    if (!_languageCode) {
        NSString *defaultLanguageCode = [[NSUserDefaults standardUserDefaults] objectForKey:KLanguageCodeKey];
        if (!defaultLanguageCode) {
            for (NSDictionary *dict in self.countryDict.allValues) {
                NSString *languageCode = dict[@"languageCode"];
                if ([languageCode isEqualToString:[NSLocale autoupdatingCurrentLocale].languageCode]) {
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
    NSString *languageName = @"";
    if ([self.languageCode isEqualToString:@"zh-Hans"]) { languageName = @"简体中文"; }
    else if ([self.languageCode isEqualToString:@"zh-Hant"]) { languageName = @"繁體中文"; }
    else if ([self.languageCode isEqualToString:@"en"]) { languageName = @"English"; }
    else if ([self.languageCode isEqualToString:@"ja"]) { languageName = @"日本語"; }
    else if ([self.languageCode isEqualToString:@"ko"]) { languageName = @"한국어"; }
    else if ([self.languageCode containsString:@"vi"]) { languageName = @"Tiếng Việt"; }
    else if ([self.languageCode isEqualToString:@"en-IN"]) { languageName = @"भारत गणराज्य"; }
    return languageName;
}



- (NSString *)countryCode {
    if (!_countryCode) {
        NSString *defaultCountryCode = [[NSUserDefaults standardUserDefaults] objectForKey:KCountryCodeKey];
        if (!defaultCountryCode) {
            defaultCountryCode = [NSLocale autoupdatingCurrentLocale].countryCode;
            if (![self.countryDict.allKeys containsObject:defaultCountryCode]) {
                defaultCountryCode = self.countryDict.allKeys.lastObject;
            }
            [[NSUserDefaults standardUserDefaults] setObject:defaultCountryCode forKey:KCountryCodeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        _countryCode = defaultCountryCode;
    }
    return _countryCode;
}
- (void)setCountryCode:(NSString *)countryCode {
    if (_countryCode != countryCode) {
        _countryCode = nil;
        _countryCode = countryCode;
        if (countryCode && [self.countryDict.allKeys containsObject:countryCode]) {
            [[NSUserDefaults standardUserDefaults] setObject:countryCode forKey:KCountryCodeKey];
        }else {
            if ([self.countryDict.allKeys containsObject:[NSLocale autoupdatingCurrentLocale].countryCode]) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSLocale autoupdatingCurrentLocale].countryCode forKey:KCountryCodeKey];
            }else {
                [[NSUserDefaults standardUserDefaults] setObject:self.countryDict.allKeys.lastObject forKey:KCountryCodeKey];
            }
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)countryName {
    NSDictionary *dict = [self.countryDict objectForKey:self.countryCode];
    return dict[@"countryName"];
}

- (NSString *)currencySymbol {
    NSDictionary *dict = [self.countryDict objectForKey:self.countryCode];
    return dict[@"currencySymbol"];
}

- (NSString *)currencyCode {
    NSDictionary *dict = [self.countryDict objectForKey:self.countryCode];
    return dict[@"currencyCode"];
}

@end
