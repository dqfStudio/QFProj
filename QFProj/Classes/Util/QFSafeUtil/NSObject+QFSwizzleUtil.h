//
//  NSObject+QFSwizzleUtil.h
//  TestProject
//
//  Created by dqf on 2017/9/28.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (QFSwizzleUtil)
+ (void)methodSwizzleWithOrigSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL;
@end
