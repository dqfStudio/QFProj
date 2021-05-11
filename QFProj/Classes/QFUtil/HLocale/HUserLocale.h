//
//  HUserLocale.h
//  QFProj
//
//  Created by Wind on 2021/5/10.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HAppLocale.h"

NS_ASSUME_NONNULL_BEGIN

@interface HUserLocale : HAppLocale
+ (HUserLocale *)defaultLocale;
- (NSString *)silverCode;
- (NSString *)localeLanguageName;
- (NSString *)localeLanguageCode;
- (NSInteger)localeLanguageCodeIndex;
- (NSInteger)localeCountryNameIndex;
@end

NS_ASSUME_NONNULL_END
