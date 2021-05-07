//
//  HUserRegion.h
//  QFProj
//
//  Created by Wind on 2021/5/7.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HUserRegion : NSObject

#pragma mark - 地区

//设备所在地区
+ (NSString *)localRegion;

//用户设置的地区
+ (NSString *)getUserRegion;

//用户设置的地区的全称
+ (NSString *)getUserRegionFullName;

//用户设置的地区的简写
+ (NSString *)getUserRegionShortFor;

//设置用户的地区
+ (void)setUserRegion:(NSString *)userRegion;


#pragma mark - 语言

//设备所在地区
+ (NSString *)localLanguage;

//获取用户设置的语言
+ (NSString *)getUserLanguage;

//获取用户设置的语言全称
+ (NSString *)getUserLanguageFullName;

//获取用户设置的语言简称
+ (NSString *)getUserLanguageShortFor;

//设置用户的语言
+ (void)setUserLanguage:(NSString *)userLanguage;

@end

NS_ASSUME_NONNULL_END
