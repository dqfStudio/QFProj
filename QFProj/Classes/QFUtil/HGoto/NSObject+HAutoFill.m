//
//  NSObject+HAutoFill.m
//  QFProj
//
//  Created by dqf on 2018/5/14.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "NSObject+HAutoFill.h"

@implementation NSObject (HAutoFill)

/**
 将值赋给model，params支持data、string和dictionary
 */
- (void)autoFill:(id)params {
    [self autoFill:params map:nil];
}
- (void)autoFill:(id)params map:(NSDictionary *)mapKeys {
    [self autoFill:params map:mapKeys exclusive:NO];
}
- (void)autoFill:(id)params map:(NSDictionary *)mapKeys exclusive:(BOOL)exclusive {
    NSDictionary *dict = nil;
    if ([params isKindOfClass:NSData.class]) {
        dict = [NSJSONSerialization JSONObjectWithData:params
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
    }else if ([params isKindOfClass:NSArray.class]) {
        dict = [NSJSONSerialization JSONObjectWithData:[params dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
    }else if ([params isKindOfClass:NSDictionary.class]) {
        dict = params;
    }
    
    if (dict) {
        NSArray<HGOTOPropertyDetail *> *pplist = [HGotoRuntimeSupport entityPropertyDetailList:[self class] isDepSearch:YES];
        for (HGOTOPropertyDetail *ppDetail in pplist) {
            NSString *mappedKey = nil;
            if (!mappedKey) mappedKey = mapKeys[ppDetail.name];
            if (!mappedKey) mappedKey = ppDetail.name;
            id value = [dict valueForKey:mappedKey];
            if (value && [value isKindOfClass:[NSString class]]) {
                if ([ppDetail.typeString isEqualToString:NSString.name()]) {
                    [self setValue:value forKey:ppDetail.name];
                }
                else if (!ppDetail.isObj || [ppDetail.typeString isEqualToString:NSNumber.name()]) {
                    [self setValue:[NSNumber numberFrom:value] forKey:ppDetail.name];
                }
                else if ([ppDetail.typeString isEqualToString:NSDate.name()]) {
                    [self setValue:[NSDate dateWithTimeIntervalSince1970:[value floatValue]] forKey:ppDetail.name];
                }
            }else if ((!value || [value isKindOfClass:NSNull.class]) && exclusive) {
                if ([ppDetail.typeString isEqualToString:NSString.name()]) {
                    [self setValue:@"" forKey:ppDetail.name];
                }
                else if (!ppDetail.isObj || [ppDetail.typeString isEqualToString:NSNumber.name()]) {
                    [self setValue:[NSNumber numberFrom:nil] forKey:ppDetail.name];
                }
                else if ([ppDetail.typeString isEqualToString:NSDate.name()]) {
                    [self setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:ppDetail.name];
                }
            }
        }
    }
}

@end

