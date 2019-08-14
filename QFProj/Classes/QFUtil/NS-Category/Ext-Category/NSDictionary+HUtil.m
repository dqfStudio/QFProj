//
//  NSDictionary+HUtil.m
//  QFProj
//
//  Created by wind on 2019/5/1.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "NSDictionary+HUtil.h"

@implementation NSDictionary (HUtil)
- (BOOL)containsObject:(NSString *)anObject {
    return [self.allKeys containsObject:anObject];
}
@end
