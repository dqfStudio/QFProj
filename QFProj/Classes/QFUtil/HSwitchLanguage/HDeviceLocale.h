//
//  HDeviceLocale.h
//  QFProj
//
//  Created by Wind on 2021/5/9.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 此类用于获取设备所设置的国家和语言代码
 */
@interface HDeviceLocale : NSObject

+ (HDeviceLocale *)locale;

@property (nonatomic, readonly) NSString *localeIdentifier;  // same as NSLocaleIdentifier
//国家本身的语言属性，如中国，默认语言就是中文
@property (nonatomic, readonly) NSString *languageCode API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));
//用户在设备中所设置的语言，如中国，但是语言可以是英语
@property (nonatomic, readonly) NSString *userLanguageCode API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property (nonatomic, nullable, readonly) NSString *countryCode API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property (nonatomic, readonly) NSString *decimalSeparator API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property (nonatomic, readonly) NSString *groupingSeparator API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property (nonatomic, readonly) NSString *currencySymbol API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property (nonatomic, nullable, readonly) NSString *currencyCode API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@end

NS_ASSUME_NONNULL_END
