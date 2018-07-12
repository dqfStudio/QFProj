//
//  NSObject+HExclusive.h
//  TestProject
//
//  Created by dqf on 2018/7/12.
//  Copyright © 2018年 socool. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSMutableSet;

@interface NSObject (HExclusive)

- (void)exclusive:(void (^)(void))exc;
- (void)synchronized:(void (^)(void))sync;

@end
