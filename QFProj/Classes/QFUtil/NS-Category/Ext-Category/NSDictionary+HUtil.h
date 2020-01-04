//
//  NSDictionary+HUtil.h
//  QFProj
//
//  Created by dqf on 2019/5/1.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (HUtil)
- (BOOL)containsObject:(NSString *)anObject;
- (nullable NSString *)stringForKey:(NSString *)aKey;
@end

NS_ASSUME_NONNULL_END
