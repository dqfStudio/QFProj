//
//  HLRDManager.m
//  QFProj
//
//  Created by Jovial on 2021/10/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLRDManager.h"

/// HUserLiveDataManager
@implementation HLRDManager

+ (HLRDManager *)defaults {
    static HLRDManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = HLRDManager.new;
    });
    return manager;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        //加载初始默认值
        [self _setupDefaults];
    }
    return self;
}
- (NSDictionary *)setupDefaults {
    return @{
        @"isLogin": @0,
        @"userId": @"111"
    };
}
//清空属性值
- (void)clear {
    [self cleanAllProperties];
}
- (void)_setupDefaults {
    SEL setupDefaultSEL = NSSelectorFromString(@"setupDefaults");
    if ([self respondsToSelector:setupDefaultSEL]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSDictionary *defaults = [self performSelector:setupDefaultSEL];
        #pragma clang diagnostic pop
        for (NSString *key in defaults) {
            id value = [defaults objectForKey:key];
            [self setValue:value forKey:key];
        }
    }
}
//清空属性值
- (void)cleanAllProperties {
    unsigned int pro_count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &pro_count);
    for (int i = 0; i < pro_count; i ++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [self valueForKey:propertyName];
        //跳过null
        if (!propertyValue || [propertyValue isKindOfClass:[NSNull class]]) {
            continue;
        }
        //通过KVC的方式赋值
        if ([self.setupDefaults containsObject:propertyName]) {
            //加载初始默认值
            id propertyValue = self.setupDefaults[propertyName];
            [self setValue:propertyValue forKey:propertyName];
        }else {
            [self setValue:nil forKey:propertyName];
        }
    }
    // 释放
    free(properties);
}

// 如果属性和字典中的key不一致，可以重写此方法 / 或者readonly
// 不一致的key和对应的value都会通过这个方法返回，可以在此方法中做特殊处理
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    //NSLog(@"-------> forUndefinedKey:%@  value:%@",key,value);
}

@end
