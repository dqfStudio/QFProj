//
//  HLocaleQuery.m
//  QFProj
//
//  Created by Wind on 2021/5/10.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HRegionQuery.h"

@implementation HLocaleInfo

@end

@implementation HRegionQuery
+ (NSArray *(^)(void))regionArray {
   return ^NSArray *(void) {
       NSString *path = [[NSBundle mainBundle] pathForResource:@"region" ofType:@"json" inDirectory:nil forLocalization:[HAppLocale locale].languageCode];
       if (path) {
           NSData *data = [NSData dataWithContentsOfFile:path];
           if (data) {
               id resource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
               if ([resource isKindOfClass:NSArray.class]) {
                   return resource;
               }
           }
       }
       return nil;
   };
}
+ (HLocaleInfo *)queryWithLocaleInfo:(HLocaleInfo *)localeInfo {
    NSDictionary *tmpDict = nil;
    NSArray *regionArray = self.regionArray();
    if (localeInfo.countryCode.length > 0) {
        for (NSDictionary *dict in regionArray) {
            if ([localeInfo.countryCode isEqualToString:dict[@"countryCode"]]) {
                tmpDict = [dict mutableCopy];
                break;
            }
        }
    }else if (localeInfo.countryName.length > 0) {
        for (NSDictionary *dict in regionArray) {
            if ([localeInfo.countryName isEqualToString:dict[@"countryName"]]) {
                tmpDict = [dict mutableCopy];
                break;
            }
        }
    }else if (localeInfo.languageCode.length > 0) {
        for (NSDictionary *dict in regionArray) {
            if ([localeInfo.languageCode isEqualToString:dict[@"languageCode"]]) {
                tmpDict = [dict mutableCopy];
                break;
            }
        }
    }else if (localeInfo.languageName.length > 0) {
        for (NSDictionary *dict in regionArray) {
            if ([localeInfo.languageName isEqualToString:dict[@"languageName"]]) {
                tmpDict = [dict mutableCopy];
                break;
            }
        }
    }
    if (tmpDict) {
        localeInfo.countryCode  = tmpDict[@"countryCode"];
        localeInfo.countryName  = tmpDict[@"countryName"];
        localeInfo.languageCode = tmpDict[@"languageCode"];
        localeInfo.languageName = tmpDict[@"languageName"];
    }
    return localeInfo;
}
+ (HLocaleInfo *)makeQuery:(void(^)(HLocaleInfo *make))block {
    HLocaleInfo *make = HLocaleInfo.new;
    block(make);
    return [self queryWithLocaleInfo:make];
}
@end
