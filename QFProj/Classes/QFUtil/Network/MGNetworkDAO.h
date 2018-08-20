//
//  MGNetworkDAO.h
//  MGFundation
//
//  Created by zct on 2017/6/26.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <HAccess/HNetworkDAO.h>

@protocol MGNeworkDAODataSource <NSObject>
@property (nonatomic, readonly) NSString *appId;
@property (nonatomic, readonly) NSString *channel;
@property (nonatomic, readonly) NSString *ua; //??
//@property (nonatomic, readonly) NSString *os; //iOS 10.0.1
//@property (nonatomic, readonly) NSString *appVersion;
//@property (nonatomic, readonly) NSString *deviceName;
//@property (nonatomic, readonly) NSString *deviceId;

@property (nonatomic, readonly) NSString *idfa; //idfa
@property (nonatomic, readonly) NSString *uuid; //补充设备标志
@property (nonatomic, readonly) NSString *ip; //IP地址


@property (nonatomic, readonly) NSString *networkType; //01：不清楚网络类型 02：CMWAP 03：CMNET 04：WLAN
@property (nonatomic, readonly) NSString *networkStandard; //01：不清楚网络制式 02：2G 03：3G 04：4G
@property (nonatomic, readonly) NSString *networkOperators; //01：不清楚运营商类型 02：中国移动 03：中国联通 04：中国电信

@property (nonatomic, readonly) NSString *longitude; //经度
@property (nonatomic, readonly) NSString *latitude; //纬度
@property (nonatomic, readonly) NSString *cityCode; //城市码
@property (nonatomic, readonly) NSString *adCode;  //行政区码

//@property (nonatomic, readonly) NSString *location; //经度,纬度
@property (nonatomic, readonly) NSString *address; //XX省XX市XX区XX街

//@property (nonatomic, readonly) NSString *language;


@property (nonatomic, readonly) NSString *uid; //app的用户id
@property (nonatomic, readonly) NSString *token; //app的授权令牌
@property (nonatomic, readonly) NSString *msisdn; //用户号码
@property (nonatomic, readonly) BOOL isTest;
//上报错误
- (void)reportError:(NSError *)error;
@end


#define MGNetworkRespCodeSuccess @"000000"
#define MGNetworkRespCodeUseCache @"000005"
#define MGNetworkRespCodeErrorTimestamp @"199997"

//获取时间差，单位毫秒
long long MGNetworkDAOGetTimestampDiff();
//获取服务端准确时间
NSDate *MGServerDate();

@interface MGNetworkDAO : HNetworkDAO
@property (nonatomic, readonly) id<MGNeworkDAODataSource> datasource;
@property (nonatomic) NSString *respDataVersion;
@end

typedef enum{
    MGNDCacheTypeReadBeforeRequest,
    MGNDCacheTypeReadAfterRequest,
    MGNDCacheTypeCallbackOnChange
}MGNDCacheType;

@interface MGCacheTypeByDataVersion : HNCustomCacheStrategy
@property (nonatomic) MGNDCacheType type;
@property (nonatomic) NSString *nextDataVersion;
@property (nonatomic) BOOL onReading;
- (NSString *)oldDataVersion;
- (NSData *)getCacheData;
+ (instancetype)createWithType:(MGNDCacheType)type;

@end

@interface HNetworkDAO (MGNetwork)
- (id)processData:(NSData *)responseInfo;//仅仅是暴露一下
@end
