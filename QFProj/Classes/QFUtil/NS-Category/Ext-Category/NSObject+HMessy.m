//
//  NSObject+HMessy.m
//  QFProj
//
//  Created by dqf on 2018/4/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "NSObject+HMessy.h"
#import <objc/runtime.h>

@implementation NSObject (HAssociatedObject)
- (void)setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAssociateWeakValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setAssociateCopyValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)removeAssociatedValues {
    objc_removeAssociatedObjects(self);
}

- (id)getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}
@end

@implementation NSDictionary (HJson)
//将字典转化成json data
- (NSData *)jsonData {
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
}
//将字典转化成字符串 如：rn=1&tt=3&rr=4
- (NSString *)linkString {
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    for (NSString *key in self.allKeys) {
        NSString *value = self[key];
        [mutableString appendString:key];
        [mutableString appendString:@"="];
        [mutableString appendString:value];
        [mutableString appendString:@"&"];
    }
    return [mutableString substringToIndex:mutableString.length-1];;
}
//将字典转化成json字符串
- (NSString *)jsonString {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
//去掉json字符串中的空格和换行符
- (NSString *)jsonString2 {
    NSString *jsonString = [self jsonString];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}
//将json文件转为data
+ (NSData *)dataWithResource:(NSString *)jsonResource {
    if (![jsonResource isKindOfClass:NSString.class]) return nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonResource ofType:nil];
    if (path) {
        return [NSData dataWithContentsOfFile:path];
    }
    return nil;
}
//将json文件转为string
+ (NSString *)stringWithResource:(NSString *)jsonResource {
    if (![jsonResource isKindOfClass:NSString.class]) return nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonResource ofType:nil];
    if (path) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    return nil;
}
//将json文件转为字典
+ (instancetype)dictionaryWithResource:(NSString *)jsonResource {
    if (![jsonResource isKindOfClass:NSString.class]) return nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonResource ofType:nil];
    if (path) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            id resource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([resource isKindOfClass:NSDictionary.class]) {
                return resource;
            }
        }
    }
    return nil;
}
@end

@implementation NSArray (HJson)
//将json文件转为data
+ (NSData *)dataWithResource:(NSString *)jsonResource {
    if (![jsonResource isKindOfClass:NSString.class]) return nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonResource ofType:nil];
    if (path) {
        return [NSData dataWithContentsOfFile:path];
    }
    return nil;
}
//将json文件转为string
+ (NSString *)stringWithResource:(NSString *)jsonResource {
    if (![jsonResource isKindOfClass:NSString.class]) return nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonResource ofType:nil];
    if (path) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    return nil;
}
//将json文件转为数组
+ (instancetype)arrayithResource:(NSString *)jsonResource {
    if (![jsonResource isKindOfClass:NSString.class]) return nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonResource ofType:nil];
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
}
@end


@implementation NSString (HJson)
//将json字符串转化成字典
- (NSDictionary *)dictionary {
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                           options:NSJSONReadingMutableContainers
                                             error:nil];
}
//将json字符串转化成数组
- (NSArray *)array {
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                           options:NSJSONReadingAllowFragments
                                             error:nil];
}
//将字符串转化data
- (NSData *)dataValue {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}
@end

@implementation NSData (HJson)
//将json data转化成字典
- (NSDictionary *)dictionary {
    return [NSJSONSerialization JSONObjectWithData:self
                                           options:NSJSONReadingMutableContainers
                                             error:nil];
}
//将json data转化成数组
- (NSArray *)array {
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:nil];
}
//将data转化成字符串
- (NSString *)stringValue {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}
@end
