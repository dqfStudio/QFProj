//
//  HAppLocale.h
//  QFProj
//
//  Created by Wind on 2021/5/9.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HDeviceLocale.h"

NS_ASSUME_NONNULL_BEGIN

/*
 此类用于APP中设置本地化的信息，如国家和语言代码
 */
@interface HAppLocale : NSObject

+ (HAppLocale *)locale;

@property (nonatomic, readonly) NSString *localeIdentifier;  // same as NSLocaleIdentifier

//APP中可设置某个国家语言代码
@property (nonatomic) NSString *languageCode API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property (nonatomic, readonly) NSString *languageName API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

//APP中可设置某个国家代码
@property (nonatomic) NSString *countryCode API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property (nonatomic, readonly) NSString *countryName API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property (nonatomic, readonly) NSString *decimalSeparator API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property (nonatomic, readonly) NSString *groupingSeparator API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property (nonatomic, readonly) NSString *currencySymbol API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property (nonatomic, readonly) NSString *currencyCode API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@end

NS_ASSUME_NONNULL_END
