//
//  HAppLocale.m
//  QFProj
//
//  Created by Wind on 2021/5/9.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HAppLocale.h"
#import "HDeviceLocale.h"

#define KUserCountryCodeKey   @"KUserCountryCodeKey"
#define KUserLanguageCodeKey  @"KUserLanguageCodeKey"

@interface HAppLocale () {
    NSLocale *locale;
    NSString *_userLanguageCode;
    NSString *_userCountryCode;
}
@property (nonatomic, readonly) NSString *defaultUserCountryCode;
@property (nonatomic, readonly) NSString *defaultUserLanguageCode;
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

- (NSString *)defaultUserCountryCode {
    return [HDeviceLocale locale].countryCode;
}
- (NSString *)defaultUserLanguageCode {
    return [HDeviceLocale locale].userLanguageCode;
}

- (NSString *)userLanguageCode {
    if (!_userLanguageCode) {
        _userLanguageCode = [[NSUserDefaults standardUserDefaults] valueForKey:KUserLanguageCodeKey];
        if (!_userLanguageCode) _userLanguageCode = self.defaultUserLanguageCode;
    }
    return _userLanguageCode;
}
- (void)setUserLanguageCode:(NSString *)userLanguageCode {
    if (_userLanguageCode != userLanguageCode) {
        _userLanguageCode = nil;
        _userLanguageCode = userLanguageCode;
        if (userLanguageCode.length > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:userLanguageCode forKey:KUserLanguageCodeKey];
        }else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:KUserLanguageCodeKey];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *localeIdentifier = [[self.userLanguageCode stringByAppendingString:@"-"] stringByAppendingString:self.userCountryCode];
        locale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
    }
}

- (NSString *)userCountryCode {
    if (!_userCountryCode) {
        _userCountryCode = [[NSUserDefaults standardUserDefaults] valueForKey:KUserCountryCodeKey];
        if (!_userCountryCode) _userLanguageCode = self.defaultUserCountryCode;
    }
    return _userCountryCode;
}
- (void)setUserCountryCode:(NSString *)userCountryCode {
    if (_userCountryCode != userCountryCode) {
        _userCountryCode = nil;
        _userCountryCode = userCountryCode;
        if (userCountryCode.length > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:userCountryCode forKey:KUserCountryCodeKey];
        }else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:KUserCountryCodeKey];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *localeIdentifier = [[self.userLanguageCode stringByAppendingString:@"-"] stringByAppendingString:self.userCountryCode];
        locale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
    }
}

- (NSString *)localeIdentifier {
    return locale.localeIdentifier;
}

- (NSString *)languageCode {
    //return locale.languageCode;
    NSString *localeIdentifier = self.localeIdentifier;
    if ([localeIdentifier hasSuffix:self.countryCode]) {
        localeIdentifier = [localeIdentifier substringToIndex:localeIdentifier.length-self.countryCode.length-1];
    }
    return localeIdentifier;
}

- (NSString *)languageName {
    //return [locale localizedStringForLanguageCode:self.languageCode];
    return [locale localizedStringForLocaleIdentifier:self.languageCode];
}

- (NSString *)countryCode {
    return locale.countryCode;
}

- (NSString *)countryName {
    return [locale localizedStringForCountryCode:self.countryCode];
}

- (NSString *)decimalSeparator {
    return locale.decimalSeparator;
}

- (NSString *)groupingSeparator {
    return locale.groupingSeparator;
}

- (NSString *)currencySymbol {
    return locale.currencySymbol;
}

- (NSString *)currencyCode {
    return locale.currencyCode;
}

- (void)setUserCountryCode:(NSString *)countryCode userLanguageCode:(NSString *)languageCode {
    if (countryCode.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:countryCode forKey:KUserCountryCodeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (languageCode.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:languageCode forKey:KUserLanguageCodeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString *localeIdentifier = [[self.userLanguageCode stringByAppendingString:@"-"] stringByAppendingString:self.userCountryCode];
    locale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
}

@end
