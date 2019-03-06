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
- (void)exclusiveOtherTouch;
+ (void)exclusiveOtherTouch;
@end

@interface UIView (HMark)
- (BOOL)containsId:(NSString *)anId;
- (void)addId:(NSString *)anId;
- (void)removeId:(NSString *)anId;
@end

@interface NSObject (HState)
@property (nonatomic) NSString *segAlias;
@property (nonatomic) NSInteger segStatue;
@property (nonatomic, readonly) NSInteger segStatues;
- (void)setObject:(id)anObject forSegStatue:(NSInteger)segStatue;
- (nullable id)objectForSegStatue:(NSInteger)segStatue;
- (void)removeObjectForSegStatue:(NSInteger)segStatue;
- (BOOL)containObjectOfSegAlias;
- (void)clearSegStatue;
@end
