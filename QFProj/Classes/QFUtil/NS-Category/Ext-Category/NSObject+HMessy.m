//
//  NSObject+HMessy.m
//  QFProj
//
//  Created by dqf on 2018/4/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "NSObject+HMessy.h"
#import <objc/runtime.h>

@implementation NSObject (HMessy)
+ (NSString *)className {
    return NSStringFromClass(self.class);;
}
@end

@implementation NSArray (HMessy)
- (id)containsClass:(Class)cls {
    for (id kls in self) {
        if ([kls isKindOfClass:cls]) {
            return kls;
        }
    }
    return nil;
}
@end

@implementation NSNumber (HMessy)
+ (NSNumber *)numberFrom:(id)value {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *valueNum = [formatter numberFromString:value];
    //if cannot convert value to number , set to 0 by defaylt
    if (!valueNum) valueNum = @(0);
    return valueNum;
}
@end