//
//  HAppLocale.m
//  QFProj
//
//  Created by Wind on 2021/5/9.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HAppLocale.h"
#import "HDeviceLocale.h"

#define KCountryCodeKey   @"KCountryCodeKey"
#define KLanguageCodeKey  @"KLanguageCodeKey"

@interface HAppLocale () {
    NSLocale *_locale;
    NSString *_languageCode;
    NSString *_countryCode;
}
@end

@implementation HAppLocale

+ (HAppLocale *)locale {
    static HAppLocale *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *localeIdentifier = [[self.languageCode stringByAppendingString:@"-"] stringByAppendingString:self.countryCode];
        _locale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
    }
    return self;
}

- (NSString *)defaultCountryCode {
    return [HDeviceLocale locale].countryCode;
}
- (NSString *)defaultLanguageCode {
    return [HDeviceLocale locale].userLanguageCode;
}


- (NSString *)localeIdentifier {
    return _locale.localeIdentifier;
}

- (NSString *)languageCode {
    if (!_languageCode) {
        _languageCode = [[NSUserDefaults standardUserDefaults] valueForKey:KLanguageCodeKey];
        if (!_languageCode) _languageCode = self.defaultLanguageCode;
    }
    return _languageCode;
}
- (void)setLanguageCode:(NSString *)languageCode {
    if (_languageCode != languageCode) {
        _languageCode = nil;
        _languageCode = languageCode;
        if (languageCode.length > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:languageCode forKey:KLanguageCodeKey];
        }else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:KLanguageCodeKey];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *localeIdentifier = [[self.languageCode stringByAppendingString:@"-"] stringByAppendingString:self.countryCode];
        _locale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
    }
}

- (NSString *)languageName {
    //return [_locale localizedStringForLanguageCode:self.languageCode];
    return [_locale localizedStringForLocaleIdentifier:self.languageCode];
}

- (NSString *)countryCode {
    if (!_countryCode) {
        _countryCode = [[NSUserDefaults standardUserDefaults] valueForKey:KCountryCodeKey];
        if (!_countryCode) _languageCode = self.defaultCountryCode;
    }
    return _countryCode;
}
- (void)setCountryCode:(NSString *)countryCode {
    if (_countryCode != countryCode) {
        _countryCode = nil;
        _countryCode = countryCode;
        if (countryCode.length > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:countryCode forKey:KCountryCodeKey];
        }else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:KCountryCodeKey];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *localeIdentifier = [[self.languageCode stringByAppendingString:@"-"] stringByAppendingString:self.countryCode];
        _locale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
    }
}

- (NSString *)countryName {
    return [_locale localizedStringForCountryCode:self.countryCode];
}

- (NSString *)decimalSeparator {
    return _locale.decimalSeparator;
}

- (NSString *)groupingSeparator {
    return _locale.groupingSeparator;
}

- (NSString *)currencySymbol {
    return _locale.currencySymbol;
}

- (NSString *)currencyCode {
    return _locale.currencyCode;
}

@end
