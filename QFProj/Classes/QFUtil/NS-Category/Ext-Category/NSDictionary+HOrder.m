//
//  NSDictionary+HOrder.m
//  QFProj
//
//  Created by dqf on 2018/6/21.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "NSDictionary+HOrder.h"

@interface NSDictionary ()
@property (nonatomic) NSMutableDictionary *indexDict;
@end

@implementation NSDictionary (HOrder)

- (NSMutableDictionary *)indexDict {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setIndexDict:(NSMutableDictionary *)indexDict {
    [self setAssociateValue:indexDict withKey:@selector(indexDict)];
}

+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSDictionaryI") methodSwizzleWithOrigSEL:@selector(objectForKey:) overrideSEL:@selector(safe_objectForKey:)];
    });
}
- (nullable id)safe_objectForKey:(id)aKey {
    if (aKey != nil) {
        return [self safe_objectForKey:aKey];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
    return nil;
}
- (NSString *)objectAtIndexedSubscript:(NSInteger)index {
    if(index >= 0 && index < self.count) {
        return self[self.indexDict[@(index).stringValue]];
    }
    return nil;
}
@end

@implementation NSMutableDictionary (HSafeUtil)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSDictionaryM") methodSwizzleWithOrigSEL:@selector(setObject:forKey:) overrideSEL:@selector(safe_setObject:forKey:)];
    });
}
- (void)safe_setObject:(id)anObject forKey:(id)aKey {
    if (aKey != nil) {
        [self safe_setObject:anObject forKey:aKey];
        [self.indexDict safe_setObject:aKey forKey:@(self.indexDict.count)];
    }else {
#if DEBUG
        NSAssert(NO,nil);
#endif
    }
}
@end

