//
//  NSIndexPath+HUtil.m
//  QFProj
//
//  Created by wind on 2019/7/14.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "NSIndexPath+HUtil.h"

@implementation NSIndexPath (HUtil)
- (NSString *)stringValue {
    return [NSString stringWithFormat:@"%@%@",@(self.row), @(self.section)];
}
+ (NSString *(^)(NSInteger row, NSInteger section))stringValue {
    return ^NSString *(NSInteger row, NSInteger section) {
        return [NSString stringWithFormat:@"%@%@",@(row), @(section)];
    };
}
+ (NSIndexPath *(^)(NSInteger row, NSInteger section))getValue {
    return ^NSIndexPath *(NSInteger row, NSInteger section) {
        return [NSIndexPath indexPathForRow:row inSection:section];
    };
}
@end
