//
//  HLocaleQuery.h
//  QFProj
//
//  Created by Wind on 2021/5/10.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLocaleInfo : NSObject
@property(nonatomic) NSString *countryCode;
@property(nonatomic) NSString *countryName;
@property(nonatomic) NSString *languageCode;
@property(nonatomic) NSString *languageName;
@end

@interface HLocaleQuery : NSObject
+ (HLocaleInfo *)makeQuery:(void(^)(HLocaleInfo *make))block;
@end

NS_ASSUME_NONNULL_END
