//
//  NSObject+HMessy.h
//  QFProj
//
//  Created by dqf on 2018/4/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HMessy)
#pragma mark - Associate value
- (void)setAssociateValue:(nullable id)value withKey:(void *)key;
- (void)setAssociateWeakValue:(nullable id)value withKey:(void *)key;
- (void)setAssociateCopyValue:(id)value withKey:(void *)key;
- (nullable id)getAssociatedValueForKey:(void *)key;
- (void)removeAssociatedValues;
@end

@interface NSDictionary (HJson)
//将字典转化成json data
- (NSData *)jsonData;
//将字典转化成字符串 如：rn=1&tt=3&rr=4
- (NSString *)linkString;
//将字典转化成json字符串
- (NSString *)jsonString;
//去掉json字符串中的空格和换行符
- (NSString *)jsonString2;
@end

@interface NSString (HJson)
//将json字符串转化成字典
- (NSDictionary *)dictionary;
//将字符串转化data
- (NSData *)data;
@end

@interface NSData (HJson)
//将json data转化成字典
- (NSDictionary *)dictionary;
//将data转化成字符串
- (NSString *)string;
@end

@interface NSNull (HMessy)
+ (NSString *)stringValue;
- (NSString *)stringValue;
+ (NSUInteger)length;
- (NSUInteger)length;
+ (BOOL)isEmpty;
- (BOOL)isEmpty;
@end

@interface NSNumber (HMessy)
- (NSUInteger)length;
- (BOOL)isEmpty;
@end

@interface NSString (HMessy)
- (NSString *)stringValue;
- (BOOL)isEmpty;
@end

NS_ASSUME_NONNULL_END
