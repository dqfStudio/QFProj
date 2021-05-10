//
//  HUserLocale.m
//  QFProj
//
//  Created by Wind on 2021/5/10.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HUserLocale.h"

@implementation HUserLocale
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
    NSString *name = super.countryName;
    NSArray *countryNameArray = @[@"Vietnam", @"India"];
    if ([countryNameArray containsObject:name]) {
        return name;
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
@end
