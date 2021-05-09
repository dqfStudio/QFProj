//
//  HUserRegion.m
//  QFProj
//
//  Created by Wind on 2021/5/7.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HUserRegion.h"

#define KUserRegionKey    @"KUserRegionKey"
#define KUserLanguageKey  @"KUserLanguageKey"

@implementation HUserRegion

#pragma mark - 地区

//设备所在地区
+ (NSString *)localRegion {
    return [[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
}

//用户设置的地区
+ (NSString *)getUserRegion {
    return [[NSUserDefaults standardUserDefaults] valueForKey:KUserRegionKey];
}

//用户设置的地区的全称
+ (NSString *)getUserRegionFullName {
    NSString *region = [self getUserRegion];
    if (region.length > 0) return region;
    return @"Others";
}

//用户设置的地区的简写
+ (NSString *)getUserRegionShortFor {
    NSString *region = [self getUserRegion];
    if ([region isEqual:@"Vietnam"]) {
        return @"VN";
    }else if ([region isEqual:@"India"]) {
        return @"IN";
    }else if ([region isEqual:@"Silver"]) {
        return @"SILVER";
    }
    return @"OTHERS";
}

//设置用户的地区
+ (void)setUserRegion:(NSString *)userRegion {
    if (!userRegion.length) {
        [self resetRegion];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:userRegion forKey:KUserRegionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//重置成设备所在地区
+ (void)resetRegion {
    NSString *localeIdentifier = [self localRegion];
    if ([localeIdentifier containsString:@"VN"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"Vietnam" forKey:KUserRegionKey];
    }else if ([localeIdentifier containsString:@"IN"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"India" forKey:KUserRegionKey];
    }else {
        [[NSUserDefaults standardUserDefaults] setValue:@"Others" forKey:KUserRegionKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - 语言

//设备所在地区
+ (NSString *)localLanguage {
    return [[NSLocale preferredLanguages] firstObject];
}

//获取用户设置的语言
+ (NSString *)getUserLanguage {
    NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:KUserLanguageKey];
    if (language.length > 0) return language;
    return self.localLanguage;
}

//获取用户设置的语言全称
+ (NSString *)getUserLanguageFullName {
    NSString *language = [self getUserLanguage];
    NSString *defaultLanguage = @"";
    if ([language isEqualToString:@"zh-Hans"]) { defaultLanguage = @"简体中文"; }
    else if ([language isEqualToString:@"zh-Hant"]) { defaultLanguage = @"繁體中文"; }
    else if ([language isEqualToString:@"en"]) { defaultLanguage = @"English"; }
    else if ([language isEqualToString:@"ja"]) { defaultLanguage = @"日本語"; }
    else if ([language isEqualToString:@"ko"]) { defaultLanguage = @"한국어"; }
    else if ([language containsString:@"vi"]) { defaultLanguage = @"Tiếng Việt"; }
    else if ([language isEqualToString:@"en-IN"]) { defaultLanguage = @"भारत गणराज्य"; }
    return defaultLanguage;
}

//获取用户设置的语言简称
+ (NSString *)getUserLanguageShortFor {
    NSString *language = [self getUserLanguage];
    NSString *defaultLanguage = @"";
    if ([language isEqualToString:@"zh-Hans"]) { defaultLanguage = @"CN"; }
    else if ([language isEqualToString:@"zh-Hant"]) { defaultLanguage = @""; }
    else if ([language isEqualToString:@"en"]) { defaultLanguage = @"EN"; }
    else if ([language isEqualToString:@"ja"]) { defaultLanguage = @""; }
    else if ([language isEqualToString:@"ko"]) { defaultLanguage = @""; }
    else if ([language containsString:@"vi"]) { defaultLanguage = @"VN"; }
    else if ([language isEqualToString:@"en-IN"]) { defaultLanguage = @"IN"; }
    else { defaultLanguage = @"CN"; }
    return defaultLanguage;
}

//设置用户的语言
+ (void)setUserLanguage:(NSString *)userLanguage {
    if (!userLanguage.length) {
        [self resetLanguage];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:userLanguage forKey:KUserLanguageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//重置成设备所在地区的语言
+ (void)resetLanguage {
    NSString *language = [self localLanguage];
    if ([language isEqualToString:@"vi"]) {
        [HUserRegion setUserLanguage:@"vi"];
    }else if ([language isEqualToString:@"en-IN"]) {
        [HUserRegion setUserLanguage:@"en-IN"];
    }else {
        [HUserRegion setUserLanguage:@"en"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
