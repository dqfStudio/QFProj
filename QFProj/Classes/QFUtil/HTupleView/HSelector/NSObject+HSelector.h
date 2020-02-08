//
//  NSObject+HSelector.h
//  MGMobileMusic
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HSelector)

- (BOOL)respondsToSelector:(SEL)aSelector withPre:(NSString *)pre;

#pragma --make 执行实例方法

- (id)performSelector:(SEL)aSelector withPre:(NSString *)pre;

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects;

- (id)performSelector:(SEL)aSelector withMethodArgments:(void *)firstParameter, ...;

- (id)performSelector:(SEL)aSelector withPre:(NSString *)pre withMethodArgments:(void *)firstParameter, ...;

#pragma --make 执行类方法

+ (id)performClassSelector:(SEL)aSelector withObjects:(NSArray *)objects;
- (id)performClassSelector:(SEL)aSelector withObjects:(NSArray *)objects;

+ (id)performClassSelector:(SEL)aSelector withMethodArgments:(void *)firstParameter, ...;
- (id)performClassSelector:(SEL)aSelector withMethodArgments:(void *)firstParameter, ...;

+ (id)performClassSelector:(SEL)aSelector withPre:(NSString *)pre withMethodArgments:(void *)firstParameter, ...;
- (id)performClassSelector:(SEL)aSelector withPre:(NSString *)pre withMethodArgments:(void *)firstParameter, ...;

@end
