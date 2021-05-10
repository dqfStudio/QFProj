//
//  HLocaleQuery.h
//  QFProj
//
//  Created by Wind on 2021/5/10.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HAppLocale.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLocaleInfo : NSObject
@property(nonatomic) NSString *countryCode;
@property(nonatomic) NSString *countryName;
@property(nonatomic) NSString *languageCode;
@property(nonatomic) NSString *languageName;
@end

@interface HLocaleQuery : NSObject
//当前设置语言下的region.json文件内容
+ (NSArray *(^)(void))regionArray;
//查询当前设置语言下region.json文件内容的某项信息
+ (HLocaleInfo *)makeQuery:(void(^)(HLocaleInfo *make))block;
@end

NS_ASSUME_NONNULL_END
