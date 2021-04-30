//
//  HUserDefaults+Properties.m
//  QFProj
//
//  Created by dqf on 2018/9/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HUserDefaults+Properties.h"

@implementation HUserDefaults (Properties)

@dynamic userName;
@dynamic userId;
@dynamic integerValue;
@dynamic boolValue;
@dynamic floatValue;

- (NSString *)suiteName {
    return @"UserId";
}

- (NSDictionary *)setupDefaults {
    return @{
        @"userName": @"default",
        @"userId": @1,
        @"integerValue": @123,
        @"boolValue": @YES,
        @"floatValue": @12.3,
    };
}

- (NSString *)transformKey:(NSString *)key {
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] uppercaseString]];
    return [NSString stringWithFormat:@"NSUserDefault%@", key];
}

@end
