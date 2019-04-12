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

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HExclusive)

- (void)exclusive:(NSString * _Nonnull)exc block:(void (^)(HExclusive stop))block;
- (void)removeExclusive:(NSString * _Nonnull)exc;
- (void)synchronized:(void (^)(void))sync;

@end

@interface UIView (HExclusive)
- (void)exclusiveOtherTouch;
+ (void)exclusiveOtherTouch;
@end

@interface UIView (HMark)
- (BOOL)containsId:(NSString *)anId;
- (void)addId:(NSString *)anId;
- (void)removeId:(NSString *)anId;
@end

@interface NSObject (HState)
- (NSInteger)segStatue;
- (NSInteger)segStatues;
- (void)setObject:(id)anObject withKey:(NSString *)aKey forSegStatue:(NSInteger)segStatue;
- (nullable id)objectForKey:(NSString *)aKey andSegStatue:(NSInteger)segStatue;
- (void)removeObjectForKey:(NSString *)aKey andSegStatue:(NSInteger)segStatue;
- (void)removeObjectForSegStatue:(NSInteger)segStatue;
- (void)clearSegStatue;
@end


NS_ASSUME_NONNULL_END
