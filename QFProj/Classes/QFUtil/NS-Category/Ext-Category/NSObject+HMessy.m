//
//  NSObject+HMessy.m
//  QFProj
//
//  Created by dqf on 2018/4/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "NSObject+HMessy.h"
#import <objc/runtime.h>

@implementation NSObject (HMessy)
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
@end

@implementation NSString (HJson)
//将json字符串转化成字典
- (NSDictionary *)dictionary {
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                           options:NSJSONReadingMutableContainers
                                             error:nil];
}
//将字符串转化data
- (NSData *)data {
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
//将data转化成字符串
- (NSString *)stringValue {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}
@end
