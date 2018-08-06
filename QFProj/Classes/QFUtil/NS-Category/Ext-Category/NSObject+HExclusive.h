//
//  NSObject+HExclusive.h
//  TestProject
//
//  Created by dqf on 2018/7/12.
//  Copyright © 2018年 socool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class NSMutableSet;

typedef void(^HExclusive)(void);

@interface NSObject (HExclusive)

- (void)exclusive:(NSString * _Nonnull)exc block:(void (^)(HExclusive stop))block;
- (void)removeExclusive:(NSString * _Nonnull)exc;
- (void)synchronized:(void (^)(void))sync;

@end

@interface UIView (HExclusive)
- (void)setTouchExclusive;
+ (void)setTouchExclusive;
@end
