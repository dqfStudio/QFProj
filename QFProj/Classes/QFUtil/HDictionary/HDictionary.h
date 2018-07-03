//
//  HDictionary.h
//  QFProj
//
//  Created by dqf on 2018/7/3.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDictionary : NSObject
@property (nonatomic, readonly) NSArray *allKeys;
@property (nonatomic, readonly) NSArray *allValues;

+ (instancetype)dictionary;

- (void)setObject:(id)anObject forKey:(NSString *)aKey;
- (void)removeObjectForKey:(NSString *)aKey;

- (id)objectAtIndexedSubscript:(NSInteger)index;
- (id)objectForKeyedSubscript:(NSString *)aKey;

@end
