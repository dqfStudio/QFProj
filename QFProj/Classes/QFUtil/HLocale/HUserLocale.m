//
//  HUserLocale.m
//  QFProj
//
//  Created by Wind on 2021/5/10.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HUserLocale.h"

@interface HUserLocale ()
@property(nonatomic) NSArray *countryCodeArray;
@property(nonatomic) NSArray *languageCodeArray;
@end

@implementation HUserLocale
+ (HUserLocale *)defaultLocale {
    static HUserLocale *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
- (id)init {
    self = [super init];
    if (self) {
        self.countryCodeArray  = @[@"VN", @"IN"];
        self.languageCodeArray = @[@"vi", @"en-IN"];
    }
    return self;
}
- (NSString *)localeIdentifier {
    //正常写法
//    return [[super.languageCode stringByAppendingString:@"-"] stringByAppendingString:super.countryCode];
    //有国家限制时的写法
    return [[self.languageCode stringByAppendingString:@"-"] stringByAppendingString:self.countryCode];
}
- (NSString *)countryCode {
    //正常写法
//    NSString *localeIdentifier = self.localeIdentifier;
//    if ([localeIdentifier hasSuffix:super.countryCode]) {
//        localeIdentifier = [localeIdentifier substringFromIndex:localeIdentifier.length-super.countryCode.length];
//    }
//    return localeIdentifier.uppercaseString;
    //有国家限制时的写法
    if (![self.countryCodeArray containsObject:super.countryCode]) {
        super.countryCode = @"en";
    }
    return super.countryCode;
}
- (void)setCountryCode:(NSString *)countryCode {
    //有国家限制且有SILVER时的写法
//    NSArray *countryCodeArray = @[@"VN", @"IN"];
//    if (![countryCodeArray containsObject:countryCode]) {
//        if ([countryCode.uppercaseString isEqual:@"SILVER"]) {
//            countryCode = @"SILVER";
//        }else {
//            countryCode = @"OTHERS";
//        }
//    }
//    super.countryCode = countryCode;
    //有国家限制时的写法
    if (![self.countryCodeArray containsObject:countryCode]) {
        countryCode = @"OTHERS";
    }
    super.countryCode = countryCode;
}
- (NSString *)countryName {
    //有国家限制且有SILVER时的写法
//    if ([[NSLocale ISOCountryCodes] containsObject:super.countryCode]) {
//        return super.countryName;
//    }else {
//        NSString *localeIdentifier = self.localeIdentifier;
//        if ([localeIdentifier hasSuffix:super.countryCode]) {
//            localeIdentifier = [localeIdentifier substringFromIndex:localeIdentifier.length-super.countryCode.length];
//        }
//        if ([localeIdentifier isEqual:@"SILVER"]) {
//            localeIdentifier = @"Silver";
//        }else {
//            localeIdentifier = @"Others";
//        }
//        return localeIdentifier;
//    }
    //有国家限制时的写法
    if ([[NSLocale ISOCountryCodes] containsObject:super.countryCode]) {
        return super.countryName;
    }
    return @"Others";
}
- (NSString *)languageCode {
    //有国家限制时的写法
    if (![self.languageCodeArray containsObject:super.languageCode]) {
        super.languageCode = @"en";
    }
    return super.languageCode;
}
- (void)setLanguageCode:(NSString *)languageCode {
    //有国家限制时的写法
    if (![self.languageCodeArray containsObject:languageCode]) {
        languageCode = @"en";
    }
    super.languageCode = languageCode;
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
    else { index = 2; }
    return index;
}
@end
