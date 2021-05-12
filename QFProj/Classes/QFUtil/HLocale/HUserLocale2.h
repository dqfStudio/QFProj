//
//  HUserLocale2.h
//  QFProj
//
//  Created by Wind on 2021/5/12.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HUserLocale2 : NSObject

//APP中可设置某个国家语言代码
@property (nonatomic) NSString *languageCode API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property (nonatomic, readonly) NSString *languageName API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

//APP中可设置某个国家代码
@property (nonatomic) NSString *countryCode API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property (nonatomic, readonly) NSString *countryName API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property (nonatomic, readonly) NSString *currencySymbol API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property (nonatomic, readonly) NSString *currencyCode API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@end

NS_ASSUME_NONNULL_END
