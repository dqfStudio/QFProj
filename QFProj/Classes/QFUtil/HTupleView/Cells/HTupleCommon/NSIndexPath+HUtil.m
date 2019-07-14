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
    return [NSString stringWithFormat:@"%@%@",@(self.section),@(self.row)];
}
+ (NSIndexPath *(^)(NSInteger row, NSInteger section))returnValue {
    return ^NSIndexPath *(NSInteger row, NSInteger section) {
        return [NSIndexPath indexPathForRow:row inSection:section];
    };
}
@end
