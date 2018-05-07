//
//  HAutoFill.m
//  QFProj
//
//  Created by dqf on 2018/5/7.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HAutoFill.h"

@implementation HAutoFill

+ (void)autoFill:(id)cls params:(NSDictionary *)params {
    [self autoFill:cls params:params map:nil];
}

+ (void)autoFill:(id)cls params:(NSDictionary *)params map:(NSDictionary *)mapKeys {
    NSArray<HGOTOPropertyDetail *> *pplist = [HGotoRuntimeSupport entityPropertyDetailList:[cls class] isDepSearch:YES];
    for (HGOTOPropertyDetail *ppDetail in pplist) {
        NSString *mappedKey = nil;
        if (!mappedKey) mappedKey = mapKeys[ppDetail.name];
        if (!mappedKey) mappedKey = ppDetail.name;
        id value = [params valueForKey:mappedKey];
        if (value && [value isKindOfClass:[NSString class]]) {
            if ([ppDetail.typeString isEqualToString:[NSString className]] || [ppDetail.typeString isEqualToString:[NSMutableString className]]) {
                [cls setValue:value forKey:ppDetail.name];
            }
            else if (!ppDetail.isObj || [ppDetail.typeString isEqualToString:[NSNumber className]]) {
                [cls setValue:[NSNumber numberFrom:value] forKey:ppDetail.name];
            }
            else if ([ppDetail.typeString isEqualToString:[NSDate className]]) {
                [cls setValue:[NSDate dateWithTimeIntervalSince1970:[value floatValue]] forKey:ppDetail.name];
            }
        }
    }
}

@end
