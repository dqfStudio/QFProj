//
//  HRegionQuery.h
//  QFProj
//
//  Created by Wind on 2021/5/10.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HAppLocale.h"

NS_ASSUME_NONNULL_BEGIN

@interface HRegionInfo : NSObject
@property(nonatomic) NSString *countryCode;
@property(nonatomic) NSString *countryName;
@property(nonatomic) NSString *languageCode;
@property(nonatomic) NSString *languageName;
@end

@interface HRegionQuery : NSObject
//当前设置语言下的region.json文件内容
+ (NSArray *(^)(void))regionArray;
//查询当前设置语言下region.json文件内容的某项信息
+ (HRegionInfo *)makeQuery:(void(^)(HRegionInfo *make))block;
@end

NS_ASSUME_NONNULL_END
