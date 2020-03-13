//
//  NSObject+HMessy.h
//  QFProj
//
//  Created by dqf on 2018/4/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HAssociatedObject)
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
//将json文件转为字典
+ (instancetype)dictionaryWithResource:(NSString *)jsonResource;
@end

@interface NSArray (HJson)
//将json文件转为数组
+ (instancetype)arrayithResource:(NSString *)jsonResource;
@end

@interface NSString (HJson)
//将json字符串转化成字典
- (NSDictionary *)dictionary;
//将json字符串转化成数组
- (NSArray *)array;
//将字符串转化data
- (NSData *)dataValue;
//将json文件转为string
+ (NSString *)stringWithResource:(NSString *)jsonResource;
@end

@interface NSData (HJson)
//将json data转化成字典
- (NSDictionary *)dictionary;
//将json data转化成数组
- (NSArray *)array;
//将data转化成字符串
- (NSString *)stringValue;
//将json文件转为data
+ (NSData *)dataWithResource:(NSString *)jsonResource;
@end

NS_ASSUME_NONNULL_END
