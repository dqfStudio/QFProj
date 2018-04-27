//
//  NSError+HUtil.h
//  TestProject
//
//  Created by dqf on 13-6-5.
//  Copyright (c) 2013年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (HUtil)

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code;

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description;

+ (instancetype)errorWithDomain:(NSString *)domain
                           code:(NSInteger)code
                    description:(NSString *)description
                         reason:(NSString *)reason;
@end

extern const int kCodeOK;
extern const int kInnerErrorCode;
extern const int kCancelCode;
extern const int kDataFormatErrorCode;
extern const int kNetWorkErrorCode;
extern const int kLogicErrorCode;
extern const int kNoDataErrorCode;
extern const int kAsyncCanelErrorCode;

#define herr(theCode, desc) [NSError errorWithDomain:[[NSString stringWithFormat:@"%s", __FILE__] lastPathComponent] code:theCode description:desc]

