//
//  HJsonManager.m
//  QFProj
//
//  Created by wind on 2019/12/13.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HJsonManager.h"

@interface HJsonManager () {
    NSDictionary *_dictionary;
}
@end

@implementation HJsonManager
- (instancetype)initWithResource:(NSString *)name {
    self = [super init];
    if (self) {
        _dictionary = [self dictionaryWithResource:name];
    }
    return self;
}
- (NSDictionary *)dictionary {
    return _dictionary;
}
- (NSDictionary *)dictionaryWithResource:(NSString *)name {
    if (![name isKindOfClass:NSString.class]) return nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}
+ (NSDictionary *)dictionaryWithResource:(NSString *)name {
    if (![name isKindOfClass:NSString.class]) return nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}
@end
