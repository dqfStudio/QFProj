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
 将data赋值给modul
 */
- (void)autoFillWithData:(NSData *)data {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    [self autoFillWithParams:dict];
}
- (void)autoFillWithData:(NSData *)data map:(NSDictionary *)mapKeys {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    [self autoFillWithParams:dict map:mapKeys];
}


/**
 将json string赋值给modul
 */
- (void)autoFillWithString:(NSString *)aString {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[aString dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:NSJSONReadingMutableContainers
                                                            error:nil];
    [self autoFillWithParams:dict];
}
- (void)autoFillWithString:(NSString *)aString map:(NSDictionary *)mapKeys {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[aString dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    [self autoFillWithParams:dict map:mapKeys];
}


/**
 将dictionary赋值给modul
 */
- (void)autoFillWithParams:(NSDictionary *)params {
    [self autoFillWithParams:params map:nil];
}
- (void)autoFillWithParams:(NSDictionary *)params map:(NSDictionary *)mapKeys {
    [self autoFillWithParams:params map:mapKeys exclusive:NO];
}


/**
 基础方法
 */
- (void)autoFillWithParams:(NSDictionary *)params map:(NSDictionary *)mapKeys exclusive:(BOOL)exclusive {
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
        }else if ((!value || [value isKindOfClass:NSNull.class]) && exclusive) {
            if ([ppDetail.typeString isEqualToArrayAny:@[NSString.name(), NSMutableString.name()]]) {
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

@end

