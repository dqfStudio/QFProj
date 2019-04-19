//
//  HDictionary.m
//  QFProj
//
//  Created by dqf on 2018/7/3.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HDictionary.h"

@interface HDictionary ()
@property (nonatomic) NSMutableArray *_allKeys;
@property (nonatomic) NSMutableArray *_allValues;
@end

@implementation HDictionary

- (NSUInteger)count {
    return self._allKeys.count;
}

- (NSArray *)allKeys {
    return self._allKeys;
}

- (NSArray *)allValues {
    return self._allValues;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self._allKeys   = NSMutableArray.array;
        self._allValues = NSMutableArray.array;
    }
    return self;
}

+ (instancetype)dictionary {
    return HDictionary.new;
}

- (nullable id)objectForKey:(NSString *)aKey {
    @synchronized(self) {
        if ([self._allKeys containsObject:aKey]) {
            NSInteger keyIndex = [self._allKeys indexOfObject:aKey];
            return [self._allValues objectAtIndex:keyIndex];
        }
        return nil;
    }
}

- (void)setObject:(id)anObject forKey:(NSString *)aKey {
    @synchronized(self) {
        if ([self._allKeys containsObject:aKey]) {
            NSInteger keyIndex = [self._allKeys indexOfObject:aKey];
            [self._allValues replaceObjectAtIndex:keyIndex withObject:anObject];
        }else {
            [self._allKeys addObject:aKey];
            [self._allValues addObject:anObject];
        }
    }
}

- (void)removeObjectForKey:(NSString *)aKey {
    @synchronized(self) {
        if ([self._allKeys containsObject:aKey]) {
            NSInteger keyIndex = [self._allKeys indexOfObject:aKey];
            [self._allKeys removeObjectAtIndex:keyIndex];
            [self._allValues removeObjectAtIndex:keyIndex];
        }
    }
}

- (id)objectAtIndexedSubscript:(NSInteger)index {
    @synchronized(self) {
        if(index >= 0 && index < self._allKeys.count) {
            id object = self._allValues[index];
            NSString *key = self._allKeys[index];
            return [NSDictionary dictionaryWithObject:object forKey:key];
        }
        return nil;
    }
}


- (id)objectForKeyedSubscript:(NSString *)aKey {
    @synchronized(self) {
        if ([self._allKeys containsObject:aKey]) {
            NSInteger keyIndex = [self._allKeys indexOfObject:aKey];
            [self._allValues objectAtIndex:keyIndex];
        }
        return nil;
    }
}

@end
