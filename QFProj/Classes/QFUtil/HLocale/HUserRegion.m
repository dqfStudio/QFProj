//
//  HUserRegion.m
//  QFProj
//
//  Created by Wind on 2021/5/13.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HUserRegion.h"

#define KRegionCodeKey    @"KRegionCodeKey"
#define KLanguageCodeKey  @"KLanguageCodeKey"

@interface HUserRegion () {
    NSString *_regionCode;
    NSString *_languageCode;
}
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
    static dispatch_once_t once;
    static NSDictionary *dictionary;
    dispatch_once(&once, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HRegionInfo" ofType:@"json"];
        if (path) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            if (data) {
                id resource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([resource isKindOfClass:NSDictionary.class]) {
                    dictionary = resource;
                }
            }
        }
    });
    return dictionary;
}

//区域代码
- (NSString *)regionCode {
    if (!_regionCode) {
        NSString *userRegionCode = [[NSUserDefaults standardUserDefaults] objectForKey:KRegionCodeKey];
        if (!userRegionCode) {
            //如果用户没有设置区域，读取“设置-通用-地区”中默认的区域
            userRegionCode = [NSLocale autoupdatingCurrentLocale].countryCode;
            if (![self.regionDict.allKeys containsObject:userRegionCode]) {
                //如果用户没有设置区域，读取区域json文件中最后一项
                userRegionCode = self.regionDict.allKeys.lastObject;
            }
            [[NSUserDefaults standardUserDefaults] setObject:userRegionCode forKey:KRegionCodeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        _regionCode = userRegionCode;
    }
    return _regionCode;
}
- (void)setRegionCode:(NSString *)regionCode {
    if (_regionCode != regionCode) {
        _regionCode = nil;
        _regionCode = regionCode;
        if (regionCode && [self.regionDict.allKeys containsObject:regionCode]) {
            [[NSUserDefaults standardUserDefaults] setObject:regionCode forKey:KRegionCodeKey];
        }else {
            //如果用户没有设置区域，读取“设置-通用-地区”中默认的区域
            NSString *regionCode = [NSLocale autoupdatingCurrentLocale].countryCode;
            if (![self.regionDict.allKeys containsObject:regionCode]) {
                //如果用户没有设置区域，读取区域json文件中最后一项
                regionCode = self.regionDict.allKeys.lastObject;
            }
            [[NSUserDefaults standardUserDefaults] setObject:regionCode forKey:KRegionCodeKey];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
//区域名称
- (NSString *)regionName {
    for (NSDictionary *dict in self.supportedRegions) {
        if ([self.regionCode isEqualToString:dict[@"regionCode"]]) {
            return dict[@"regionName"];
        }
    }
    return @"";
}
//支持的区域列表
- (NSArray *)supportedRegions {
    //获取不同的语言文件
    NSString *path = [[NSBundle mainBundle] pathForResource:self.languageCode ofType:@"lproj"];
    NSBundle *currentBundle = [NSBundle bundleWithPath:path];
    path = [currentBundle pathForResource:@"HRegionList" ofType:@"json"];
    NSArray *array = nil;
    if (path) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            id resource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([resource isKindOfClass:NSArray.class]) {
                array = resource;
            }
        }
    }
    return array;
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
    for (NSDictionary *dict in self.supportedLanguages) {
        if ([self.languageCode isEqualToString:dict[@"languageCode"]]) {
            return dict[@"languageName"];
        }
    }
    return @"";
}
//支持的语言列表
- (NSArray *)supportedLanguages {
    static dispatch_once_t once;
    static NSArray *array;
    dispatch_once(&once, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HLanguageList" ofType:@"json"];
        if (path) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            if (data) {
                id resource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([resource isKindOfClass:NSArray.class]) {
                    array = resource;
                }
            }
        }
    });
    return array;
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
    NSDictionary *dict = [self.regionDict objectForKey:self.regionName];
    return [UIImage imageNamed:dict[@"currencyIconName"]];
}

//分组分隔符
- (NSString *)groupingSeparator {
    NSDictionary *dict = [self.regionDict objectForKey:self.regionName];
    return dict[@"groupingSeparator"];
}
//小数分隔符
- (NSString *)decimalSeparator {
    NSDictionary *dict = [self.regionDict objectForKey:self.regionName];
    return dict[@"decimalSeparator"];
}


- (UIImage *)currencyIconWithFactors:(NSString *)factors {
    if (factors.length > 0) {
        for (NSDictionary *dict in self.regionDict.allValues) {
            if ([dict.allValues containsObject:factors]) {
                return [UIImage imageNamed:dict[@"currencyIconName"]];
            }
        }
    }
    return nil;
}
- (NSString *)currencySymbolWithFactors:(NSString *)factors {
    if (factors.length > 0) {
        for (NSDictionary *dict in self.regionDict.allValues) {
            if ([dict.allValues containsObject:factors]) {
                return dict[@"currencySymbol"];
            }
        }
    }
    return @"";
}
- (NSString *)currencyCodeWithFactors:(NSString *)factors {
    if (factors.length > 0) {
        for (NSDictionary *dict in self.regionDict.allValues) {
            if ([dict.allValues containsObject:factors]) {
                return dict[@"currencyCode"];
            }
        }
    }
    return @"";
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
