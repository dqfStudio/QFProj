//
//  NSObject+HExclusive.h
//  HProj
//
//  Created by dqf on 2018/7/12.
//  Copyright © 2018年 socool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class NSMutableSet;

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HExclusive)
- (void)exclusive:(NSString *_Nonnull)exc delay:(NSTimeInterval)interval block:(void (^)(void))block;
- (void)removeExclusive:(NSString *_Nonnull)exc;
- (void)synchronized:(void (^)(void))sync;
@end

@interface UIView (HExclusiveTouch)
- (void)exclusiveOtherTouch;
+ (void)exclusiveOtherTouch;
@end

@interface UIView (HMark)
- (BOOL)containsId:(NSString *)anId;
- (void)addId:(NSString *)anId;
- (void)removeId:(NSString *)anId;
@end

@interface NSObject (HSegState)
- (NSInteger)segStatue;
- (NSInteger)segTotalStatue;
- (void)setObject:(id)anObject forKey:(NSString *)aKey segStatue:(NSInteger)statue;
- (nullable id)objectForKey:(NSString *)aKey segStatue:(NSInteger)statue;
- (void)removeObjectForKey:(NSString *)aKey segStatue:(NSInteger)statue;
- (void)removeObjectForSegStatue:(NSInteger)statue;
- (void)clearSegStatue;
@end


NS_ASSUME_NONNULL_END
