//
//  HDictionary.h
//  QFProj
//
//  Created by dqf on 2018/7/3.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDictionary : NSObject
@property (readonly) NSUInteger count;
@property (nonatomic, readonly) NSArray *allKeys;
@property (nonatomic, readonly) NSArray *allValues;

+ (instancetype)dictionary;

- (nullable id)objectForKey:(NSString *)aKey;
- (void)setObject:(id)anObject forKey:(NSString *)aKey;
- (void)removeObjectForKey:(NSString *)aKey;

- (id)objectAtIndexedSubscript:(NSInteger)index;
- (id)objectForKeyedSubscript:(NSString *)aKey;

@end

NS_ASSUME_NONNULL_END
