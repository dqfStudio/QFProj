//
//  HUserLocale3.m
//  QFProj
//
//  Created by Wind on 2021/5/13.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HUserLocale3.h"

#define KRegionNameKey    @"KRegionNameKey"
#define KLanguageCodeKey  @"KLanguageCodeKey"

@interface HUserLocale3 () {
    NSString *_languageCode;
    NSString *_regionCode;
    NSString *_regionName;
}
@property(nonatomic) NSDictionary *regionDict;
@property(nonatomic) NSDictionary *regionMapDict;
@end

@implementation HUserLocale3

+ (HUserLocale3 *)defaultLocale {
    static HUserLocale3 *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (NSDictionary *)regionDict {
    if (!_regionDict) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"countryInfo" ofType:@"json"];
        if (path) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            if (data) {
                id resource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([resource isKindOfClass:NSDictionary.class]) {
                    _regionDict = resource;
                }
            }
        }
    }
    return _regionDict;
}
- (NSDictionary *)regionMapDict {
    if (!_regionMapDict) {
        _regionMapDict = @{@"VN" : @"Vietnam", @"IN" : @"India", @"OTHERS" : @"Others"};
    }
    return _regionMapDict;
}

- (NSString *)languageCode {
    if (!_languageCode) {
        NSString *defaultLanguageCode = [[NSUserDefaults standardUserDefaults] objectForKey:KLanguageCodeKey];
        if (!defaultLanguageCode) {
            for (NSDictionary *dict in self.regionDict.allValues) {
                NSString *languageCode = dict[@"languageCode"];
                if ([languageCode isEqualToString:[[NSLocale preferredLanguages] firstObject]]) {
                    [[NSUserDefaults standardUserDefaults] setObject:languageCode forKey:KLanguageCodeKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    defaultLanguageCode = languageCode;
                    break;
                }
            }
            if (!defaultLanguageCode) {
                NSDictionary *dict = self.regionDict.allValues.lastObject;
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
//    NSString *languageName = [[NSLocale localeWithLocaleIdentifier:self.languageCode] localizedStringForLocaleIdentifier:self.languageCode];
//    if ([languageName isEqualToString:@"en-IN"]) { languageName = @"भारत गणराज्य"; }
//    return languageName ?: @"";
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



- (NSString *)regionCode {
    if (!_regionCode) {
        for (NSString *key in self.regionMapDict.allKeys) {
            NSString *value = self.regionMapDict[key];
            if ([value isEqualToString:self.regionName]) {
                _regionCode = [key mutableCopy];
                break;
            }
        }
    }
    return _regionCode;
}

- (NSString *)regionName {
    if (!_regionName) {
        NSString *defaultRegionName = [[NSUserDefaults standardUserDefaults] objectForKey:KRegionNameKey];
        if (!defaultRegionName) {
            NSString *regionCode = [NSLocale autoupdatingCurrentLocale].countryCode;
            defaultRegionName = self.regionMapDict[regionCode];
            if (![self.regionDict.allKeys containsObject:defaultRegionName]) {
                defaultRegionName = self.regionDict.allKeys.lastObject;
            }
            [[NSUserDefaults standardUserDefaults] setObject:defaultRegionName forKey:KRegionNameKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        _regionName = defaultRegionName;
    }
    return _regionName;
}
- (void)setRegionName:(NSString *)regionName {
    if (_regionName != regionName) {
        _regionName = nil;
        _regionName = regionName;
        if (regionName && [self.regionDict.allKeys containsObject:regionName]) {
            [[NSUserDefaults standardUserDefaults] setObject:regionName forKey:KRegionNameKey];
        }else {
            NSString *regionCode = [NSLocale autoupdatingCurrentLocale].countryCode;
            if ([self.regionDict.allKeys containsObject:self.regionMapDict[regionCode]]) {
                [[NSUserDefaults standardUserDefaults] setObject:self.regionMapDict[regionCode] forKey:KRegionNameKey];
            }else {
                [[NSUserDefaults standardUserDefaults] setObject:self.regionDict.allKeys.lastObject forKey:KRegionNameKey];
            }
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)currencySymbol {
    NSDictionary *dict = [self.regionDict objectForKey:self.regionName];
    return dict[@"currencySymbol"];
}

- (NSString *)currencyCode {
    NSDictionary *dict = [self.regionDict objectForKey:self.regionName];
    return dict[@"currencyCode"];
}



//- (NSString *)sceneLanguageName {
////    NSString *languageName = [[NSLocale localeWithLocaleIdentifier:self.languageCode] localizedStringForLocaleIdentifier:self.languageCode];
////    if ([languageName isEqualToString:@"en-IN"]) { languageName = @"भारत गणराज्य"; }
////    return languageName ?: @"";
//    NSString *defaultLanguageName = @"";
//    if ([self.languageCode isEqualToString:@"zh-Hans"]) { defaultLanguageName = @"简体中文"; }
//    else if ([self.languageCode isEqualToString:@"zh-Hant"]) { defaultLanguageName = @"繁體中文"; }
//    else if ([self.languageCode isEqualToString:@"en"]) { defaultLanguageName = @"English"; }
//    else if ([self.languageCode isEqualToString:@"ja"]) { defaultLanguageName = @"日本語"; }
//    else if ([self.languageCode isEqualToString:@"ko"]) { defaultLanguageName = @"한국어"; }
//    else if ([self.languageCode containsString:@"vi"]) { defaultLanguageName = @"Tiếng Việt"; }
//    else if ([self.languageCode isEqualToString:@"en-IN"]) { defaultLanguageName = @"भारत गणराज्य"; }
//    return defaultLanguageName;
//}
- (NSInteger)sceneLanguageCodeIndex {
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
- (NSString *)sceneRegionCode {
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
- (NSInteger)sceneRegionNameIndex {
    NSInteger index = -1;
    if ([self.regionName isEqualToString:@"Vietnam"]) { index = 0; }
    else if ([self.regionName isEqualToString:@"India"]) { index = 1; }
    else { index = 2; }
    return index;
}

@end
