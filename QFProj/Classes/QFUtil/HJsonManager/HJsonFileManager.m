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
- (instancetype)init {
    self = [super init];
    if (self) {
        _mutableDict = NSMutableDictionary.dictionary;
    }
    return self;
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
    id resource = [_mutableDict objectForKey:name];
    if (!resource) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        if (path) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            if (data) {
                resource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([resource isKindOfClass:NSArray.class] || [resource isKindOfClass:NSDictionary.class]) {
                    [_mutableDict setObject:resource forKey:name];
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
    if ([_mutableDict.allKeys containsObject:name]) {
        [_mutableDict removeObjectForKey:name];
    }
}
@end
