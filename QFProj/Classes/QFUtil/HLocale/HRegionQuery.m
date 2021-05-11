//
//  HRegionQuery.m
//  QFProj
//
//  Created by Wind on 2021/5/10.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HRegionQuery.h"

@implementation HRegionInfo

@end

@implementation HRegionQuery
+ (NSArray *(^)(void))regionArray {
   return ^NSArray *(void) {
       NSString *path = [[NSBundle mainBundle] pathForResource:@"region" ofType:@"json" inDirectory:nil forLocalization:[HAppLocale defaultLocale].languageCode];
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
+ (HRegionInfo *)queryWithRegionInfo:(HRegionInfo *)regionInfo {
    NSDictionary *tmpDict = nil;
    NSArray *regionArray = self.regionArray();
    if (regionInfo.countryCode.length > 0) {
        for (NSDictionary *dict in regionArray) {
            if ([regionInfo.countryCode isEqualToString:dict[@"countryCode"]]) {
                tmpDict = [dict mutableCopy];
                break;
            }
        }
    }else if (regionInfo.countryName.length > 0) {
        for (NSDictionary *dict in regionArray) {
            if ([regionInfo.countryName isEqualToString:dict[@"countryName"]]) {
                tmpDict = [dict mutableCopy];
                break;
            }
        }
    }else if (regionInfo.languageCode.length > 0) {
        for (NSDictionary *dict in regionArray) {
            if ([regionInfo.languageCode isEqualToString:dict[@"languageCode"]]) {
                tmpDict = [dict mutableCopy];
                break;
            }
        }
    }else if (regionInfo.languageName.length > 0) {
        for (NSDictionary *dict in regionArray) {
            if ([regionInfo.languageName isEqualToString:dict[@"languageName"]]) {
                tmpDict = [dict mutableCopy];
                break;
            }
        }
    }
    if (tmpDict) {
        regionInfo.countryCode  = tmpDict[@"countryCode"];
        regionInfo.countryName  = tmpDict[@"countryName"];
        regionInfo.languageCode = tmpDict[@"languageCode"];
        regionInfo.languageName = tmpDict[@"languageName"];
    }
    return regionInfo;
}
+ (HRegionInfo *)makeQuery:(void(^)(HRegionInfo *make))block {
    HRegionInfo *make = HRegionInfo.new;
    block(make);
    return [self queryWithRegionInfo:make];
}
@end
