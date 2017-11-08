//
//  ConstHttpUrl.m
//  MGMobileMusic
//
//  Created by MikeWang on 16/8/22.
//  Copyright © 2016年 migu. All rights reserved.
//

#import "ConstHttpUrl.h"

const NSString *TIMESTEP = @"TimeStep";
const NSString *RANDKEY = @"RandKey";
const NSString *IMEI = @"IMEI";
const NSString *UID = @"uid";
const NSString *IMSI = @"IMSI";
const NSString *UA = @"Ios_migu";

@implementation ConstHttpUrl

+ (NSString *)appendUAVersion:(NSString *)relativeurl andOthers:(NSString *)others
{
//    if (others)
//    {
//        return [NSString stringWithFormat:@"%@?ua=%@&version=%@%@", relativeurl, UA, [[MGClient sharedInstance] appVersion], others];
//    }
//    else
//    {
//        return [NSString stringWithFormat:@"%@?ua=%@&version=%@", relativeurl, UA, [[MGClient sharedInstance] appVersion]];
//    }
}

@end
