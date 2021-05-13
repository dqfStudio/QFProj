//
//  HUserLocale3.h
//  QFProj
//
//  Created by Wind on 2021/5/13.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HUserLocale3 : NSObject

+ (HUserLocale3 *)defaultLocale;

//APP中可设置某个国家语言代码
@property (nonatomic) NSString *languageCode;
@property (nonatomic, readonly) NSString *languageName;

//APP中可设置某个地区名称
@property (nonatomic) NSString *regionName;
@property (nonatomic, readonly) NSString *regionCode;

@property (nonatomic, readonly) NSString *currencyCode;
@property (nonatomic, readonly) NSString *currencySymbol;

//获取语言代码的序号
- (NSInteger)sceneLanguageCodeIndex;

//获取地区代码
- (NSString *)sceneRegionCode;
//获取地区名称序号
- (NSInteger)sceneRegionNameIndex;

@end

NS_ASSUME_NONNULL_END
