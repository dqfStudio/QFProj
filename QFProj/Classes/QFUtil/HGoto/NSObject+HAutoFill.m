//
//  NSObject+HAutoFill.m
//  QFProj
//
//  Created by dqf on 2018/5/14.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "NSObject+HAutoFill.h"

@interface NSNumber (HAutoFill)
//value需为数字型字符串
+ (NSNumber *)numberFrom:(id)value;
@end

@implementation NSNumber (HAutoFill)
+ (NSNumber *)numberFrom:(id)value {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *valueNum = [formatter numberFromString:value];
    //if cannot convert value to number , set to 0 by defaylt
    if (!valueNum) valueNum = @(0);
    return valueNum;
}
@end

@implementation NSObject (HAutoFill)

/**
 将值赋给model，params支持data、string和dictionary
 */
+ (id)autoFill {
    NSObject *object = [self new];
    [object autoFill:nil];
    return object;
}
+ (NSArray *)autoFillWithCount:(NSInteger)count {
    NSMutableArray *mutableArr = [NSMutableArray new];
    for (int i=0; i<count; i++) {
        [mutableArr addObject:[self autoFill]];
    }
    return mutableArr;
}


+ (id)autoFill:(id)params {
    NSObject *object = [self new];
    [object autoFill:params map:nil];
    return object;
}
- (void)autoFill:(id)params {
    [self autoFill:params map:nil];
}
+ (id)autoFill:(id)params map:(NSDictionary *)mapKeys {
    NSObject *object = [self new];
#ifdef DEBUG
    [object autoFill:params map:mapKeys exclusive:NO];
#else
    [object autoFill:params map:mapKeys exclusive:YES];
#endif
    return object;
}
- (void)autoFill:(id)params map:(NSDictionary *)mapKeys {
#ifdef DEBUG
    [self autoFill:params map:mapKeys exclusive:NO];
#else
    [self autoFill:params map:mapKeys exclusive:YES];
#endif
}
+ (id)autoFill:(id)params map:(NSDictionary *)mapKeys exclusive:(BOOL)exclusive {
    NSObject *object = [self new];
    [object autoFill:params map:mapKeys exclusive:exclusive];
    return object;
}
- (void)autoFill:(id)params map:(NSDictionary *)mapKeys exclusive:(BOOL)exclusive {
    [self autoFill:params map:mapKeys exclusive:exclusive isDepSearch:YES];
}
- (void)autoFill:(id)params map:(NSDictionary *)mapKeys exclusive:(BOOL)exclusive isDepSearch:(BOOL)deepSearch {
    NSDictionary *dict = nil;
    if ([params isKindOfClass:NSData.class]) {
        dict = [NSJSONSerialization JSONObjectWithData:params
                                               options:NSJSONReadingMutableContainers
                                                 error:nil];
    }else if ([params isKindOfClass:NSString.class]) {
        dict = [NSJSONSerialization JSONObjectWithData:[params dataUsingEncoding:NSUTF8StringEncoding]
                                               options:NSJSONReadingMutableContainers
                                                 error:nil];
    }else if ([params isKindOfClass:NSDictionary.class]) {
        dict = params;
    }
    
    if (dict) {
        NSArray<HGOTOPropertyDetail *> *pplist = [HGotoRuntimeSupport entityPropertyDetailList:[self class] isDepSearch:deepSearch];
        for (HGOTOPropertyDetail *ppDetail in pplist) {
            NSString *mappedKey = nil;
            if (!mappedKey) mappedKey = mapKeys[ppDetail.name];
            if (!mappedKey) mappedKey = ppDetail.name;
            id value = [dict valueForKey:mappedKey];
            if (value && [value isKindOfClass:[NSString class]]) {
                if ([ppDetail.typeString isEqualToString:NSStringFromClass(NSString.class)]) {
                    [self setValue:value forKey:ppDetail.name];
                }
                else if (!ppDetail.isObj || [ppDetail.typeString isEqualToString:NSStringFromClass(NSNumber.class)]) {
                    if (![ppDetail.typeString isEqualToString:@"NSRange"]) {
                        //Value range check
                        NSNumber *num = value;
                        NSString *tmpKeyPath = [NSString stringWithFormat:@"%@_",ppDetail.name];
                        if ([self respondsToSelector:NSSelectorFromString(tmpKeyPath)]) {
                            NSValue *value = [self valueForKey:tmpKeyPath];
                            NSRange range = [value rangeValue];
                            if (num.integerValue < range.location || num.integerValue > range.length) {
#if DEBUG
                                NSAssert(NO, @"Value out of range!");
#endif
                                [self setValue:@(range.location) forKey:ppDetail.name];
                                continue;
                            }
                        }
                        [self setValue:[NSNumber numberFrom:value] forKey:ppDetail.name];
                    }
                }
                else if ([ppDetail.typeString isEqualToString:NSStringFromClass(NSDate.class)]) {
                    [self setValue:[NSDate dateWithTimeIntervalSince1970:[value floatValue]] forKey:ppDetail.name];
                }
            }else if ((!value || [value isKindOfClass:NSNull.class]) && exclusive) {
                if ([ppDetail.typeString isEqualToString:NSStringFromClass(NSString.class)]) {
                    [self setValue:@"" forKey:ppDetail.name];
                }
                else if (!ppDetail.isObj || [ppDetail.typeString isEqualToString:NSStringFromClass(NSNumber.class)]) {
                    if (![ppDetail.typeString isEqualToString:@"NSRange"]) {
                        [self setValue:[NSNumber numberFrom:nil] forKey:ppDetail.name];
                    }
                }
                else if ([ppDetail.typeString isEqualToString:NSStringFromClass(NSDate.class)]) {
                    [self setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:ppDetail.name];
                }
            }
        }
    }else {
        NSString *mockString = @"太阳初升万物初始生之气最盛虽不能如传说中那般餐霞食气但这样迎霞锻体自也有莫大好处可充盈人体生机天之计在于晨每日早起多用功强筋壮骨活血炼筋将来才能在这苍莽山脉中有活命的本钱";
        NSArray<HGOTOPropertyDetail *> *pplist = [HGotoRuntimeSupport entityPropertyDetailList:[self class] isDepSearch:deepSearch];
        for (HGOTOPropertyDetail *ppDetail in pplist) {
            if ([ppDetail.typeString isEqualToString:NSStringFromClass(NSString.class)]) {
                int index = arc4random() % (mockString.length - 3);
                NSString *string = [mockString substringWithRange:NSMakeRange(index, 3)];
                [self setValue:string forKey:ppDetail.name];
            }
            else if (!ppDetail.isObj || [ppDetail.typeString isEqualToString:NSStringFromClass(NSNumber.class)]) {
                if (ppDetail.typeCode == 'B') {
                    [self setValue:@(0) forKey:ppDetail.name];
                }else if ([ppDetail.typeString isEqualToString:@"NSRange"]) {
                    //暂时不做处理
                }else {
                    //Value range check
                    NSInteger num = 123;
                    NSString *tmpKeyPath = [NSString stringWithFormat:@"%@_",ppDetail.name];
                    if ([self respondsToSelector:NSSelectorFromString(tmpKeyPath)]) {
                        NSValue *value = [self valueForKey:tmpKeyPath];
                        NSRange range = [value rangeValue];
                        if (num < range.location || num > range.length) {
                            NSAssert(NO, @"Value out of range!");
                            [self setValue:@(0) forKey:ppDetail.name];
                            continue;
                        }
                    }
                    [self setValue:@(num) forKey:ppDetail.name];
                }
            }
            else if ([ppDetail.typeString isEqualToString:NSStringFromClass(NSDate.class)]) {
                [self setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:ppDetail.name];
            }
        }
    }
}

- (void)autoClear {
    
    NSDictionary *dict = [self serialization];
    
    if (dict) {
        NSArray<HGOTOPropertyDetail *> *pplist = [HGotoRuntimeSupport entityPropertyDetailList:[self class] isDepSearch:YES];
        for (HGOTOPropertyDetail *ppDetail in pplist) {
            NSString *mappedKey = ppDetail.name;
            id value = [dict valueForKey:mappedKey];
            if (value && [value isKindOfClass:[NSString class]]) {
                if ([ppDetail.typeString isEqualToString:NSStringFromClass(NSString.class)]) {
                    [self setValue:nil forKey:ppDetail.name];
                }
                else if (!ppDetail.isObj || [ppDetail.typeString isEqualToString:NSStringFromClass(NSNumber.class)]) {
                    [self setValue:[NSNumber numberFrom:nil] forKey:ppDetail.name];
                }
                else if ([ppDetail.typeString isEqualToString:NSStringFromClass(NSDate.class)]) {
                    [self setValue:nil forKey:ppDetail.name];
                }
            }else if ((!value || [value isKindOfClass:NSNull.class])) {
                if ([ppDetail.typeString isEqualToString:NSStringFromClass(NSString.class)]) {
                    [self setValue:nil forKey:ppDetail.name];
                }
                else if (!ppDetail.isObj || [ppDetail.typeString isEqualToString:NSStringFromClass(NSNumber.class)]) {
                    [self setValue:[NSNumber numberFrom:nil] forKey:ppDetail.name];
                }
                else if ([ppDetail.typeString isEqualToString:NSStringFromClass(NSDate.class)]) {
                    [self setValue:nil forKey:ppDetail.name];
                }
            }
        }
    }
}

@end
