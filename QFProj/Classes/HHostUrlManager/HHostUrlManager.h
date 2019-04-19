//
//  HHostUrlManager.h
//  MGMobileMusic
//
//  Created by dqf on 17/1/18.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, THostUrlMode) {
    /** 正式环境 */
    EHostUrlModeRelease = 0,
    /** 测试环境 */
    EHostUrlModeDebug = 1,
    /** 准上线环境 */
    EHostUrlModeTest = 2,
    /** simulate */
    EHostUrlModeSimulation = 3
};

#define KHostURLModelKey @"KHostURLModelKey"

#define KMGVersion1 @"MIGUM2.0/v1.0/"
#define KMGVersion2 @"MIGUM2.0/v2.0/"
#define KMGVersion2_1 @"MIGUM2.0/v2.1/"

@interface HHostUrlManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic) THostUrlMode hostUrlMode;

- (NSString *(^)(NSString *))contentServerBaseUrl;
- (NSString *(^)(NSString *))productServerBaseUrl;
- (NSString *(^)(NSString *))userServerBaseUrl;
- (NSString *(^)(NSString *))barrageServerBaseUrl;
- (NSString *(^)(NSString *))resourceServerBaseUrl;
- (NSString *(^)(void))h5ServerBaseUrl;

@end
