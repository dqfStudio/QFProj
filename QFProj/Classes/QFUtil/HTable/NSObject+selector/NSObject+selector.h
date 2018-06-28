//
//  NSObject+selector.h
//  MGMobileMusic
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (selector)

- (id)performSelector:(SEL)aSelector withObjects:(NSArray*)objects;

- (id)performSelector:(SEL)aSelector withMethodArgments:(void *)firstParameter, ...;

- (id)performSelector:(SEL)aSelector withPre:(NSString *)pre withMethodArgments:(void *)firstParameter, ...;

@end
