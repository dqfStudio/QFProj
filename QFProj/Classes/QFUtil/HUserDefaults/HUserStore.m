//
//  HUserStore.m
//  QFProj
//
//  Created by dqf on 2018/9/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HUserStore.h"
#import <objc/runtime.h>
#import "NSObject+HKVO.h"

#define KUserStoreKey @"KUserStoreKey"

@implementation HUserStore (Defaults)
- (NSString *)suiteName {
    return self.userId;
}
- (NSDictionary *)setupDefaults {
    return @{
        @"isLogin": @0,
        @"userId": @"111"
    };
}
@end

@implementation HUserStore

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

+ (HUserStore *)defaults {
    static HUserStore *share = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString *_suiteName = [[HKeyChainStore keyChainStore] stringForKey:KUserStoreKey];
        if (_suiteName.length > 0) {
            NSData *data = [[HKeyChainStore keyChainStore] dataForKey:_suiteName];
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            if (data) share = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            #pragma clang diagnostic pop
        }
        if (!share || ![share respondsToSelector:@selector(initData)]) {
            share = HUserStore.new;
        }
        [share initData];
    });
    return share;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //设置初始默认值
        [self _setupDefaults];
    }
    return self;
}

- (NSString *)_suiteName {
    if ([self respondsToSelector:NSSelectorFromString(@"suiteName")]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [self performSelector:NSSelectorFromString(@"suiteName")];
        #pragma clang diagnostic pop
    }
    return nil;
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

//初始化数据
- (void)initData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveUser) name:UIApplicationWillTerminateNotification object:nil];
//    [self h_addObserverBlockForKeyPath:@"isLogin" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
//        if ([newVal boolValue]) {
//            [self saveUser];
//        }else {
//            [self removeUser];
//        }
//    }];
//    [[RACObserve(share, isLogin) skip:1] subscribeNext:^(id  _Nullable x) {
//        if ([x boolValue]) {
//            [self saveUser];
//        }else {
//            [self removeUser];
//        }
//    }];
}
- (void)setIsLogin:(BOOL)isLogin {
    if (_isLogin != isLogin) {
        _isLogin = isLogin;
        if (_isLogin) {
            [self saveUser];
        }else {
            [self removeUser];
        }
    }
}

- (void)saveUser {
    if (self.isLogin) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
        #pragma clang diagnostic pop
        NSString *_suiteName = [HUserStore.defaults _suiteName];
        if (_suiteName.length > 0 && data) {
            [[HKeyChainStore keyChainStore] setData:data forKey:_suiteName];
            [[HKeyChainStore keyChainStore] setString:_suiteName forKey:KUserStoreKey];
            [[HKeyChainStore keyChainStore] synchronizable];
        }
    }
}

//登出的时候需要移除用户信息
- (void)removeUser {
    //删除记录的登录标志
    [[HKeyChainStore keyChainStore] setString:nil forKey:KUserStoreKey];
    [[HKeyChainStore keyChainStore] synchronizable];
    //清空所有属性值
    [self cleanAllProperties];
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
//        id propertyValue = [self valueForKey:propertyName];
//
//        //跳过null
//        if (!propertyValue || [propertyValue isKindOfClass:[NSNull class]]) {
//            continue;
//        }
//
//        //通过KVC的方式赋值
//        if ([propertyValue isKindOfClass:[NSString class]]) {
//            [self setValue:@"" forKey:propertyName];
//        }
//        else if ([propertyValue isKindOfClass:[NSNumber class]]) {
//            [self setValue:@(0) forKey:propertyName];
//        }
//        else if ([propertyValue isKindOfClass:[NSMutableDictionary class]] ||
//                 [propertyValue isKindOfClass:[NSDictionary class]]) {
//            [self setValue:@{} forKey:propertyName];
//        }
//        else if ([propertyValue isKindOfClass:[NSMutableArray class]] ||
//                 [propertyValue isKindOfClass:[NSArray class]]) {
//            [self setValue:@[] forKey:propertyName];
//        }
//        else {
//            [self setValue:nil forKey:propertyName];
//        }
        
        [self setValue:nil forKey:propertyName];
    }
    // 释放
    free(properties);
    
    //设置初始默认值
    [self _setupDefaults];

}

// 如果属性和字典中的key不一致，可以重写此方法 / 或者readonly
// 不一致的key和对应的value都会通过这个方法返回，可以在此方法中做特殊处理
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    //NSLog(@"-------> forUndefinedKey:%@  value:%@",key,value);
}

//加载钥匙串中的数据
- (BOOL)loadKeyChainDataWith:(NSString *)userName pwd:(NSString *)pwd {
    BOOL boolValue = NO;
    if (userName.length > 3) {
        NSString *_suiteName = userName;
        NSData *data = [[HKeyChainStore keyChainStore] dataForKey:_suiteName];
        if (data) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            HUserStore *userDefaults = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            #pragma clang diagnostic pop
            id propertyValue = [userDefaults valueForKey:@"password"];
            //密码不相等则不能提取用户信息
            if (![pwd isEqualToString:propertyValue]) {
                userDefaults = nil;
                return boolValue;
            }
            boolValue = YES;
            unsigned int pro_count = 0;
            objc_property_t *properties = class_copyPropertyList([self class], &pro_count);
            for (int i = 0; i < pro_count; i ++) {
                objc_property_t property = properties[i];
                NSString *propertyName = [NSString stringWithFormat:@"%s", property_getName(property)];
                //isLogin 这个属性的值由外部业务赋值
                if (![propertyName isEqualToString:@"isLogin"]) {
                    //通过KVC的方式赋值
                    id propertyValue = [userDefaults valueForKey:propertyName];
                    [self setValue:propertyValue forKey:propertyName];
                }
            }
            // 释放
            userDefaults = nil;
            free(properties);
        }
    }
    return boolValue;
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

@end
