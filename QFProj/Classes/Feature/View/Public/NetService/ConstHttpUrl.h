//
//  ConstHttpUrl.h
//  MGMobileMusic
//
//  Created by MikeWang on 16/8/22.
//  Copyright © 2016年 migu. All rights reserved.
//

#import <Foundation/Foundation.h>

// Header Key
extern NSString *TIMESTEP;
extern NSString *RANDKEY;
extern NSString *IMEI;
extern NSString *UID;
extern NSString *IMSI;
extern NSString *UA;

@interface ConstHttpUrl : NSObject

// 添加UA,Version等参数
+ (NSString*)appendUAVersion:(NSString*)relativeurl andOthers:(NSString*)others;

@end
