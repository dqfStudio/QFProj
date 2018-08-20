//
//  MGHostUrlManager.h
//  MGMobileMusic
//
//  Created by dqf on 17/1/18.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TMGHostUrlMode)
{
    /** 正式环境 */
    EMGHostUrlModeRelease = 0,
    /** 测试环境 */
    EMGHostUrlModeDebug = 1,
    /** 准上线环境 */
    EMGHostUrlModeTest = 2,
    /** simulate */
    EMGHostUrlModeSimulation = 3
};

#define KMGVersion1 @"MIGUM2.0/v1.0/"
#define KMGVersion2 @"MIGUM2.0/v2.0/"
#define KMGVersion2_1 @"MIGUM2.0/v2.1/"

@interface MGHostUrlManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic) TMGHostUrlMode hostUrlMode;

- (NSString *(^)(NSString *))contentServerBaseUrl;
- (NSString *(^)(NSString *))productServerBaseUrl;
- (NSString *(^)(NSString *))userServerBaseUrl;
- (NSString *(^)(NSString *))barrageServerBaseUrl;
- (NSString *(^)(NSString *))resourceServerBaseUrl;
- (NSString *(^)(void))h5ServerBaseUrl;

@end
