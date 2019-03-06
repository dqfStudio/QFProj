//
//  HAspectsCenter.m
//  QFProj
//
//  Created by dqf on 2018/5/8.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HAspectsCenter.h"

@interface HAspectsCenter ()
@property (nonatomic) NSMutableDictionary *aspectsDict;
@end

@implementation HAspectsCenter

- (NSMutableDictionary *)aspectsDict {
    if (!_aspectsDict) {
        _aspectsDict = [[NSMutableDictionary alloc] init];
    }
    return _aspectsDict;
}

+ (HAspectsCenter *)defaultCenter {
    static HAspectsCenter *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (void)setAspects:(id)aspects forKey:(NSString *)aKey {
    if (aspects && aKey) {
        [self.aspectsDict setObject:aspects forKey:aKey];
    }
}

- (void)setAspects:(id)aspects forClass:(Class)cls {
    if (aspects && cls) {
        NSString *aKey = NSStringFromClass(cls);
        if (aKey) {
            [self.aspectsDict setObject:aspects forKey:aKey];
        }
    }
}

- (void)removeAspectsForKey:(NSString *)aKey {
    if (aKey) {
        id<AspectToken> aspectToken = [self.aspectsDict objectForKey:aKey];
        [aspectToken remove];
        [self.aspectsDict removeObjectForKey:aKey];
    }
}

- (void)removeAspectsForClass:(Class)cls {
    if (cls) {
        NSString *aKey = NSStringFromClass(cls);
        if (aKey) {
            id<AspectToken> aspectToken = [self.aspectsDict objectForKey:aKey];
            [aspectToken remove];
            [self.aspectsDict removeObjectForKey:aKey];
        }
    }
}

@end
