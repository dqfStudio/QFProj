//
//  NSDictionary+Util.m
//  QFProj
//
//  Created by wind on 2019/5/1.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "NSDictionary+Util.h"

@implementation NSDictionary (Util)
- (BOOL)containsObject:(NSString *)anObject {
    return [self.allKeys containsObject:anObject];
}
@end
