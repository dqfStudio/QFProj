//
//  HPrinterManager.m
//  QFProj
//
//  Created by dqf on 2018/8/7.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HPrinterManager.h"

#if DEBUG

@interface HPrinterManager ()
@property (nonatomic) NSMutableDictionary *printerDict;
@end

@implementation HPrinterManager
- (NSMutableDictionary *)printerDict {
    if (!_printerDict) {
        _printerDict = NSMutableDictionary.dictionary;
    }
    return _printerDict;
}
+ (instancetype)share {
    static dispatch_once_t pred;
    static HPrinterManager *o = nil;
    dispatch_once(&pred, ^{ o = [[self alloc] init]; });
    return o;
}
- (void)setObject:(id)anObject forKey:(NSString *)aKey {
    [self.printerDict setObject:anObject forKey:aKey];
}
- (BOOL)containsObject:(id)anObject {
    return [self.printerDict.allKeys containsObject:anObject];
}
- (NSString *)objectForKey:(NSString *)aKey {
    if ([self.printerDict.allKeys containsObject:aKey]) {
        return [self.printerDict objectForKey:aKey];
    }
    return nil;
}
@end

#endif
