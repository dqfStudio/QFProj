//
//  HJsonFileManager.m
//  QFProj
//
//  Created by wind on 2019/12/13.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HJsonFileManager.h"

@interface HJsonFileManager ()
@property (nonatomic) NSMutableDictionary *mutableDict;
@end

@implementation HJsonFileManager
+ (instancetype)share {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (NSMutableDictionary *)mutableDict {
    if (!_mutableDict) {
        _mutableDict = NSMutableDictionary.dictionary;
    }
    return _mutableDict;
}
+ (nullable id)resourceWithName:(NSString *)name {
    if (![name isKindOfClass:NSString.class]) return nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    if (path) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            id resource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([resource isKindOfClass:NSArray.class] || [resource isKindOfClass:NSDictionary.class]) {
                return resource;
            }
        }
    }
    return nil;
}
- (nullable id)resourceWithName:(NSString *)name {
    if (![name isKindOfClass:NSString.class]) return nil;
    id resource = [self.mutableDict objectForKey:name];
    if (!resource) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        if (path) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            if (data) {
                resource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([resource isKindOfClass:NSArray.class] || [resource isKindOfClass:NSDictionary.class]) {
                    [self.mutableDict setObject:resource forKey:name];
                }else {
                    return nil;
                }
            }
        }
    }
    return resource;
}
- (void)releaseResource:(NSString *)name {
    if (![name isKindOfClass:NSString.class]) return;
    if ([self.mutableDict.allKeys containsObject:name]) {
        [self.mutableDict removeObjectForKey:name];
    }
}
@end
