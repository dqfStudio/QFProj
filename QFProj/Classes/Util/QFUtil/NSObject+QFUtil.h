//
//  NSObject+QFUtil.h
//  TestProject
//
//  Created by dqf on 2017/9/27.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (QFUtil)

// property list
- (NSArray *)ppList;

// property list of some class
+ (NSArray *)ppListOfClass:(Class)theClass;

// property list of some class , it will iterate search
+ (NSArray *)depPPListOfClass:(Class)theClass;

@end
