//
//  HUserRegion.m
//  QFProj
//
//  Created by Wind on 2021/5/13.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HUserRegion.h"

#define KRegionNameKey    @"KRegionNameKey"
#define KLanguageCodeKey  @"KLanguageCodeKey"

@interface HUserRegion () {
    NSString *_languageCode;
    NSString *_regionCode;
    NSString *_regionName;
}
//区域json文件内容
@property(nonatomic) NSDictionary *regionDict;
//区域代码和区域名称的映射表
@property(nonatomic) NSDictionary *regionMapDict;
@end

@implementation HUserRegion

+ (HUserRegion *)defaultRegion {
    static HUserRegion *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
//区域json文件内容
- (NSDictionary *)regionDict {
    if (!_regionDict) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HRegionInfo" ofType:@"json"];
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
//区域代码和区域名称的映射表
- (NSDictionary *)regionMapDict {
    if (!_regionMapDict) {
        _regionMapDict = @{@"VN" : @"Vietnam", @"IN" : @"India", @"BR" : @"Brazil", @"OTHERS" : @"Others"};
    }
    return _regionMapDict;
}
//语言代码
- (NSString *)languageCode {
    if (!_languageCode) {
        NSString *defaultLanguageCode = [[NSUserDefaults standardUserDefaults] objectForKey:KLanguageCodeKey];
        if (!defaultLanguageCode) {
            //如果用户没有设置语言，读取“设置-通用-语言”中默认的语言
            for (NSDictionary *dict in self.regionDict.allValues) {
                NSString *languageCode = dict[@"languageCode"];
                if ([languageCode isEqualToString:[[NSLocale preferredLanguages] firstObject]]) {
                    [[NSUserDefaults standardUserDefaults] setObject:languageCode forKey:KLanguageCodeKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    defaultLanguageCode = languageCode;
                    break;
                }
            }
            //如果用户没有设置语言，读取区域json文件中最后一项
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
//语言名称
- (NSString *)languageName {
//    NSString *languageName = [[NSLocale localeWithLocaleIdentifier:self.languageCode] localizedStringForLocaleIdentifier:self.languageCode];
//    if ([languageName isEqualToString:@"en-IN"]) { languageName = @"भारत गणराज्य"; }
//    else if ([languageName isEqualToString:@"pt-BR"]) { languageName = @"português"; }
//    return languageName ?: @"";
    NSString *languageName = @"";
    if ([self.languageCode isEqualToString:@"zh-Hans"]) { languageName = @"简体中文"; }
    else if ([self.languageCode isEqualToString:@"zh-Hant"]) { languageName = @"繁體中文"; }
    else if ([self.languageCode isEqualToString:@"en"]) { languageName = @"English"; }
    else if ([self.languageCode isEqualToString:@"ja"]) { languageName = @"日本語"; }
    else if ([self.languageCode isEqualToString:@"ko"]) { languageName = @"한국어"; }
    else if ([self.languageCode containsString:@"vi"]) { languageName = @"Tiếng Việt"; }
    else if ([self.languageCode isEqualToString:@"en-IN"]) { languageName = @"भारत गणराज्य"; }
    else if ([self.languageCode isEqualToString:@"pt-BR"]) { languageName = @"português"; }
    return languageName;
}


//区域代码
- (NSString *)regionCode {
    if (!_regionCode) {
        //如果用户没有设置区域，读取区域json文件中匹配的区域代码
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
//区域名称
- (NSString *)regionName {
    if (!_regionName) {
        NSString *defaultRegionName = [[NSUserDefaults standardUserDefaults] objectForKey:KRegionNameKey];
        if (!defaultRegionName) {
            //如果用户没有设置区域，读取“设置-通用-地区”中默认的区域
            NSString *regionCode = [NSLocale autoupdatingCurrentLocale].countryCode;
            defaultRegionName = self.regionMapDict[regionCode];
            if (![self.regionDict.allKeys containsObject:defaultRegionName]) {
                //如果用户没有设置区域，读取区域json文件中最后一项
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
            //如果用户没有设置区域，读取“设置-通用-地区”中默认的区域
            NSString *regionCode = [NSLocale autoupdatingCurrentLocale].countryCode;
            if ([self.regionDict.allKeys containsObject:self.regionMapDict[regionCode]]) {
                [[NSUserDefaults standardUserDefaults] setObject:self.regionMapDict[regionCode] forKey:KRegionNameKey];
            }else {
                //如果用户没有设置区域，读取区域json文件中最后一项
                [[NSUserDefaults standardUserDefaults] setObject:self.regionDict.allKeys.lastObject forKey:KRegionNameKey];
            }
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
//货币符号
- (NSString *)currencySymbol {
    NSDictionary *dict = [self.regionDict objectForKey:self.regionName];
    return dict[@"currencySymbol"];
}
//货币代码
- (NSString *)currencyCode {
    NSDictionary *dict = [self.regionDict objectForKey:self.regionName];
    return dict[@"currencyCode"];
}

//货币图标
- (UIImage *)currencyIcon {
    return [UIImage imageNamed:self.currencyIconName];
}
//货币图标名称
- (NSString *)currencyIconName {
    if ([self.regionName isEqual:@"Vietnam"]) {
        return @"越南盾";
    } else if([self.regionName isEqual:@"India"]) {
        return @"卢比";
    } else if([self.regionName isEqual:@"Brazil"]) {
        return @"巴西雷亚尔";
    }
    return @"USDT";
}


- (UIImage *)currencyIconWithFactors:(NSString *)factors {
    if (factors.length > 0) {
        for (NSDictionary *dict in self.regionDict.allValues) {
            if ([dict.allValues containsObject:factors]) {
                if ([dict[@"countryCode"] isEqual:@"VN"]) {
                    return [UIImage imageNamed:@"越南盾"];
                }else if ([dict[@"countryCode"] isEqual:@"IN"]) {
                    return [UIImage imageNamed:@"卢比"];
                }else if ([dict[@"countryCode"] isEqual:@"BR"]) {
                    return [UIImage imageNamed:@"巴西雷亚尔"];
                }
            }
        }
    }
    return [UIImage imageNamed:@"USDT"];
}
- (NSString *)currencySymbolWithFactors:(NSString *)factors {
    if (!factors || factors.length == 0) return @"₫";
    for (NSDictionary *dict in self.regionDict.allValues) {
        if ([dict.allValues containsObject:factors]) {
            return dict[@"currencySymbol"];
        }
    }
    return @"$";
}
- (NSString *)currencyCodeWithFactors:(NSString *)factors {
    if (!factors || factors.length == 0) return @"VND";
    for (NSDictionary *dict in self.regionDict.allValues) {
        if ([dict.allValues containsObject:factors]) {
            return dict[@"currencyCode"];
        }
    }
    return @"USD";
}
- (NSString *)currencyCodeWithServerCurrencyCode:(NSString *)code {
    if([code isEqual:@"USDT"]) {
        return @"USD";
    }
    return code;
}


//获取语言代码的序号
- (NSInteger)sceneLanguageCodeIndex {
    NSInteger index = -1;
#if DEBUG
    if ([self.languageCode isEqualToString:@""]) { index = 0; }
    else if ([self.languageCode isEqualToString:@"zh-Hans"]) { index = 0; }
    else if ([self.languageCode isEqualToString:@"en"]) { index = 1; }
    else if ([self.languageCode containsString:@"vi"]) { index = 2; }
    else if ([self.languageCode isEqualToString:@"en-IN"]) { index = 3; }
    else if ([self.languageCode isEqualToString:@"pt-BR"]) { index = 4; }
#else
    if ([self.languageCode isEqualToString:@""]) { index = 0; }
    else if ([self.languageCode isEqualToString:@"en"]) { index = 0; }
    else if ([self.languageCode containsString:@"vi"]) { index = 1; }
    else if ([self.languageCode isEqualToString:@"en-IN"]) { index = 2; }
    else if ([self.languageCode isEqualToString:@"zh-Hant"]) { index = 3; }
    else if ([self.languageCode isEqualToString:@"ja"]) { index = 4; }
    else if ([self.languageCode isEqualToString:@"ko"]) { index = 5; }
    else if ([self.languageCode isEqualToString:@"pt-BR"]) { index = 6; }
#endif
    return index;
}
//获取地区代码
- (NSString *)sceneRegionCode {
    NSString *defaultLanguageCode = @"";
    if ([self.languageCode isEqualToString:@"zh-Hans"]) { defaultLanguageCode = @"CN"; }
    else if ([self.languageCode isEqualToString:@"zh-Hant"]) { defaultLanguageCode = @""; }
    else if ([self.languageCode isEqualToString:@"en"]) { defaultLanguageCode = @"EN"; }
    else if ([self.languageCode isEqualToString:@"ja"]) { defaultLanguageCode = @""; }
    else if ([self.languageCode isEqualToString:@"ko"]) { defaultLanguageCode = @""; }
    else if ([self.languageCode containsString:@"vi"]) { defaultLanguageCode = @"VN"; }
    else if ([self.languageCode isEqualToString:@"en-IN"]) { defaultLanguageCode = @"IN"; }
    else if ([self.languageCode isEqualToString:@"pt-BR"]) { defaultLanguageCode = @"BR"; }
    else { defaultLanguageCode = @"CN"; }
    return defaultLanguageCode;
}
//获取地区名称序号
- (NSInteger)sceneRegionNameIndex {
    NSInteger index = -1;
    if ([self.regionName isEqualToString:@"Vietnam"]) { index = 0; }
    else if ([self.regionName isEqualToString:@"India"]) { index = 1; }
    else if ([self.regionName isEqualToString:@"Brazil"]) { index = 2; }
    else { index = 3; }
    return index;
}

@end
