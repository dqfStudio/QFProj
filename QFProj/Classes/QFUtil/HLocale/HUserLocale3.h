//
//  HUserLocale3.h
//  QFProj
//
//  Created by Wind on 2021/5/13.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HUserRegion : NSObject

+ (HUserRegion *)defaultLocale;

//APP中可设置某个区域语言代码
@property (nonatomic) NSString *languageCode;//语言代码
@property (nonatomic, readonly) NSString *languageName;//语言名称

//APP中可设置某个地区名称
@property (nonatomic) NSString *regionName;//区域名称
@property (nonatomic, readonly) NSString *regionCode;//区域代码

@property (nonatomic, readonly) NSString *currencyCode;//货币代码
@property (nonatomic, readonly) NSString *currencySymbol;//货币符号

//获取语言代码的序号
- (NSInteger)sceneLanguageCodeIndex;
//获取地区代码
- (NSString *)sceneRegionCode;
//获取地区名称序号
- (NSInteger)sceneRegionNameIndex;

@end

NS_ASSUME_NONNULL_END
