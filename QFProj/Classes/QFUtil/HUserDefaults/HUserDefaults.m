//
//  HUserDefaults.m
//  HProjectModel1
//
//  Created by txkj_mac on 2018/9/27.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HUserDefaults.h"
#import "NSTimer+HUtil.h"
#import <objc/runtime.h>

#define KUSER @"H_USER_DEFAULTS"

@implementation HUserDefaults

- (void)encodeWithCoder:(NSCoder *)coder {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        [coder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(ivars);
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i=0; i<count; i++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [coder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}

+ (HUserDefaults *)defaults {
    static HUserDefaults *share = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        //初始化数据
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:KUSER];
        if (data) {
            share = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        if (!share || ![share respondsToSelector:@selector(initData)]) {
            share = HUserDefaults.new;
        }
        [share initData];
    });
    return share;
}

//初始化数据
- (void)initData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveUser) name:UIApplicationWillTerminateNotification object:nil];
#if DEBUG
    [NSTimer scheduledTimerImmediatelyWithTimeInterval:15 times:MAXFLOAT block:^(NSTimer *timer) {
        dispatch_async(dispatch_queue_create(0, 0), ^{
            [self saveUser];
        });
    }];
#endif
}

- (void)saveUser {
    if (self.isLogin) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:KUSER];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:KUSER];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)removeUser {
    //清空所有属性值
    [self cleanAllProperties];
    //保存相关属性值
    [self saveUser];
}

/**
清空属性值
*/
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
        if ([propertyValue isKindOfClass:[NSString class]]) {
            [self setValue:@"" forKey:propertyName];
        }
        else if ([propertyValue isKindOfClass:[NSNumber class]]) {
            [self setValue:@(0) forKey:propertyName];
        }
        else if ([propertyValue isKindOfClass:[NSMutableDictionary class]] ||
                 [propertyValue isKindOfClass:[NSDictionary class]]) {
            [self setValue:@{} forKey:propertyName];
        }
        else if ([propertyValue isKindOfClass:[NSMutableArray class]] ||
                 [propertyValue isKindOfClass:[NSArray class]]) {
            [self setValue:@[] forKey:propertyName];
        }
        else {
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


- (void)setBaseLink:(NSString *)baseLink {
    [[NSUserDefaults standardUserDefaults] setObject:baseLink forKey:@"baseLink"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)baseLink {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"baseLink"];
}



- (void)setH5Link:(NSString *)h5Link {
    [[NSUserDefaults standardUserDefaults] setObject:h5Link forKey:@"h5Link"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)h5Link {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"h5Link"];
}



- (void)setPlatCodeLink:(NSString *)platCodeLink {
    [[NSUserDefaults standardUserDefaults] setObject:platCodeLink forKey:@"platCodeLink"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)platCodeLink {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"platCodeLink"];
}


- (void)setSrc1Link:(NSString *)src1Link {
    [[NSUserDefaults standardUserDefaults] setObject:src1Link forKey:@"src1Link"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)src1Link {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"src1Link"];
}

@end
