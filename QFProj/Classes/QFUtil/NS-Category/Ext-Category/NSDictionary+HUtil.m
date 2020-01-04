//
//  NSDictionary+HUtil.m
//  QFProj
//
//  Created by dqf on 2019/5/1.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "NSDictionary+HUtil.h"

@implementation NSDictionary (HUtil)
- (BOOL)containsObject:(NSString *)anObject {
    return [self.allKeys containsObject:anObject];
}
- (nullable NSString *)stringForKey:(NSString *)aKey {
    id value = [self objectForKey:aKey];
    if (!value || [value isKindOfClass:NSNull.class]) {
        return nil;
    }else if ([value isKindOfClass:NSString.class]) {
        return value;
    }else if ([value isKindOfClass:NSNumber.class]) {
        NSNumber *number = value;
        return number.stringValue;
    }
    return value;
}
@end
