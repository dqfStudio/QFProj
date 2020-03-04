//
//  NSObject+HSwizzleUtil.h
//  HProj
//
//  Created by dqf on 2017/9/28.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

void HSwizzleClassMethod(Class cls, SEL origSEL, SEL overrideSEL);
void HSwizzleInstanceMethod(Class cls, SEL origSEL, SEL overrideSEL);

void HSwizzleClassMethodNames(NSArray *classNames, SEL origSEL, SEL overrideSEL);
void HSwizzleInstanceMethodNames(NSArray *classNames, SEL origSEL, SEL overrideSEL);

@interface NSObject (HSwizzleUtil)
+ (void)methodSwizzleWithOrigSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL;
+ (void)classMethodSwizzleWithOrigSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL;
@end
