//
//  NSObject+HMessy.h
//  QFProj
//
//  Created by dqf on 2018/4/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (HMessy)
+ (NSString *(^)(void))name;
#pragma mark - Associate value
- (void)setAssociateValue:(nullable id)value withKey:(void *)key;
- (void)setAssociateWeakValue:(nullable id)value withKey:(void *)key;
- (void)setAssociateCopyValue:(id)value withKey:(void *)key;
- (nullable id)getAssociatedValueForKey:(void *)key;
- (void)removeAssociatedValues;
@end

@interface NSArray (HMessy)
- (id)containsClass:(Class)cls;
@end

@interface NSNumber (HMessy)
//value需为数字型字符串
+ (NSNumber *)numberFrom:(id)value;
@end
