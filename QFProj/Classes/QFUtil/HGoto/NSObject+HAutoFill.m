//
//  NSObject+HAutoFill.m
//  QFProj
//
//  Created by dqf on 2018/5/14.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "NSObject+HAutoFill.h"

@implementation NSObject (HAutoFill)

- (void)autoFillWithParams:(NSDictionary *)params {
    [self autoFillWithParams:params map:nil];
}

- (void)autoFillWithParams:(NSDictionary *)params map:(NSDictionary *)mapKeys {
    NSArray<HGOTOPropertyDetail *> *pplist = [HGotoRuntimeSupport entityPropertyDetailList:[self class] isDepSearch:YES];
    for (HGOTOPropertyDetail *ppDetail in pplist) {
        NSString *mappedKey = nil;
        if (!mappedKey) mappedKey = mapKeys[ppDetail.name];
        if (!mappedKey) mappedKey = ppDetail.name;
        id value = [params valueForKey:mappedKey];
        if (value && [value isKindOfClass:[NSString class]]) {
            if ([ppDetail.typeString isEqualToArrayAny:@[NSString.name(), NSMutableString.name()]]) {
                [self setValue:value forKey:ppDetail.name];
            }
            else if (!ppDetail.isObj || [ppDetail.typeString isEqualToString:NSNumber.name()]) {
                [self setValue:[NSNumber numberFrom:value] forKey:ppDetail.name];
            }
            else if ([ppDetail.typeString isEqualToString:NSDate.name()]) {
                [self setValue:[NSDate dateWithTimeIntervalSince1970:[value floatValue]] forKey:ppDetail.name];
            }
        }
    }
}

@end

