//
//  MGNetworkDAO.m
//  MGFundation
//
//  Created by zct on 2017/6/26.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "MGNetworkDAO.h"
#import <Hodor/HClassManager.h>
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import <Hodor/NSString+ext.h>
#import <Hodor/NSError+ext.h>
//#import "MGSignIOS.h"
#import <NSObject+ext.h>
#import "UIDevice+HUtil.h"

static long long MGNetworkDAOTimestampDiff = -888888888;
long long MGNetworkDAOGetTimestampDiff()
{
    if (MGNetworkDAOTimestampDiff == -888888888) {
        MGNetworkDAOTimestampDiff = 0;
    }
    return MGNetworkDAOTimestampDiff;
}
void MGNetworkDAOSetTimestampDiff(long long timestampDiff)
{
    MGNetworkDAOTimestampDiff = timestampDiff;
}

NSDate *MGServerDate() {
    long long timestamp = MGNetworkDAOGetTimestampDiff();
    long long time = [[NSDate date] timeIntervalSince1970] + timestamp / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    return localDate;
}


@interface MGNetworkDAO ()
@property (nonatomic, readwrite) id<MGNeworkDAODataSource> datasource;
@property (nonatomic) BOOL isRetrying;
@property (nonatomic) NSDictionary *params;
@end

@implementation MGNetworkDAO

ppx(datasource, HPIgnore)
ppx(isRetrying, HPIgnore)
ppx(respDataVersion, HPIgnore)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.datasource = HProtocalInstance(MGNeworkDAODataSource);
        self.deserializeKeyPath = @"data";
    }
    return self;
}

#define MGAddHeader(key,value) {if (value) headers[key] = value;}

- (void)setupHeader:(NSMutableDictionary *)headers
{
    static dispatch_once_t once;
    static NSString *deviceModel;
    static NSString *appVersion;
    static NSString *preferredLang;
    dispatch_once(&once, ^{
        struct utsname systemInfo;
        uname(&systemInfo);
        deviceModel = [UIDevice currentDevice].machineModelName;
        appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
        NSArray * allLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        preferredLang = [allLanguages objectAtIndex:0];
    });
    //设备
    MGAddHeader(@"brand", deviceModel);
    MGAddHeader(@"ip", self.datasource.ip);
    MGAddHeader(@"idfa", self.datasource.idfa);
    MGAddHeader(@"uuid", self.datasource.uuid);
    //环境
    MGAddHeader(@"mgmNetworkType", self.datasource.networkType);
    MGAddHeader(@"mgmNetworkStandard", self.datasource.networkStandard);
    MGAddHeader(@"mgmNetworkOperators", self.datasource.networkOperators);
    MGAddHeader(@"longitude", self.datasource.longitude);
    MGAddHeader(@"latitude", self.datasource.latitude);
    MGAddHeader(@"cityCode", self.datasource.cityCode);
    MGAddHeader(@"adCode", self.datasource.adCode);
    MGAddHeader(@"language", preferredLang)
    
    //软件
    MGAddHeader(@"platform", @"iOS");
    MGAddHeader(@"os", [[UIDevice currentDevice] systemName]);
    MGAddHeader(@"osVersion", [[UIDevice currentDevice] systemVersion]);
    MGAddHeader(@"ua", @"Ios_migu");
    MGAddHeader(@"version", appVersion);
    MGAddHeader(@"appId", self.datasource.appId);
    MGAddHeader(@"channel", self.datasource.channel);
    MGAddHeader(@"subchannel", self.datasource.channel);
    MGAddHeader(@"signVersion", @"V001");
    //用户
    MGAddHeader(@"uid", self.datasource.uid);
    MGAddHeader(@"msisdn", self.datasource.msisdn);
    MGAddHeader(@"token", self.datasource.token);
    
    
    //其他
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *logId = [NSString stringWithFormat:@"%f", timestamp];
    MGAddHeader(@"logId", logId);
    
    if (self.datasource.isTest)
    {
        MGAddHeader(@"test", @"01");
    }
}
- (void)setupParams:(NSMutableDictionary *)params
{
    [super setupParams:params];
    
    if ([self.cacheType isKindOfClass:[MGCacheTypeByDataVersion class]])
    {
        MGCacheTypeByDataVersion *cache = (MGCacheTypeByDataVersion *)self.cacheType;
        NSString *oldDataVersion = [cache oldDataVersion];
        BOOL cacheExsit = [cache isCacheUseable:cache.cacheKey];
        if (oldDataVersion && cacheExsit) params[@"dataVersion"] = oldDataVersion;
    }
}
- (void)willSendRequest:(NSString *)urlString method:(NSString *)method headers:(NSMutableDictionary *)headers params:(NSMutableDictionary *)params
{
    //header加timestamp
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    timestamp += MGNetworkDAOGetTimestampDiff();
    [headers setObject:[@(timestamp) stringValue] forKey:@"timestamp"];
    
    NSURL *requestURL = [NSURL URLWithString:urlString].standardizedURL;
    //构造签名条件
    //需要区分GET和POST两种情况
    
    
    //uri，除开host剩下的
    NSRange hostRange = [urlString rangeOfString:requestURL.host];
    NSAssert(hostRange.location != NSNotFound, @"请求域名错误");
    NSUInteger pathStart = hostRange.location + hostRange.length;
    NSString *uri = [urlString substringFromIndex:pathStart];
    //向后找第一个/
    NSRange gangRange = [uri rangeOfString:@"/"];
    if (gangRange.location != NSNotFound && gangRange.location < uri.length - 1) {
        uri = [uri substringFromIndex:gangRange.location];
    }
    else{
        uri = @"";
    }
    NSString *body = nil;
    
    //paramString
    NSMutableString *paramsString = [NSMutableString new];
    NSArray *keys = [params.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    for (NSString *key in keys) {
        if (paramsString.length > 0) [paramsString appendFormat:@"&"];
        [paramsString appendFormat:@"%@=%@", key, [[params[key] stringValue] encode]];
    }
    
    if ([self.method isEqualToString:@"GET"] || [self.method isEqualToString:@"get"])
    {
        if (params.count > 0)
        {
            uri = [uri stringByAppendingFormat:requestURL.query?@"&%@":@"?%@", paramsString];
        }
    }
    else
    {                        
        body = paramsString;
    }
    
    //此处需要签名
    const char *sign;
//    const char *sign = MGSignature([uri cStringUsingEncoding:NSUTF8StringEncoding], timestamp, [body cStringUsingEncoding:NSUTF8StringEncoding]);
    headers[@"sign"] = [NSString stringWithFormat:@"%s", sign];
    free((void *)sign);
    
    self.params = params;
}



- (id)getOutputEntiy:(id)responseObject
{
    if (!self.isMock)
    {
        //矫正时间
        NSNumber *serverTimestampNum = self.httpResponse.allHeaderFields[@"timestamp"];
        if (!serverTimestampNum) {
//            return [NSError errorWithDomain:@"Server" code:kDataFormatErrorCode description:@"服务器没在header返回时间戳"];
        }
        else
        {
            long long serverTimestamp = [serverTimestampNum longLongValue];
            long long localTimestamp = [[NSDate date] timeIntervalSince1970] * 1000; //差几十秒没关系
            MGNetworkDAOSetTimestampDiff(serverTimestamp - localTimestamp);
        }
    }
    NSDictionary* responseDict = (NSDictionary*)responseObject;
    //判断一下,只有statusCode 为200，才作为正确返
    NSString* statusCode = [responseDict objectForKey:@"code"];
    
    if (!statusCode || [statusCode isKindOfClass:[NSNull class]])
    {
        return [NSError errorWithDomain:@"Server" code:kInnerErrorCode description:@"响应的code为空"];
    }
    if (![statusCode isKindOfClass:[NSString class]])
    {
        return [NSError errorWithDomain:@"Server" code:kInnerErrorCode description:@"响应的code类型应该是字符串"];
    }
    
    //返回成功
    if([statusCode isEqualToString:MGNetworkRespCodeSuccess])
    {
        self.respDataVersion = responseDict[@"dataVersion"];
        if ([self.respDataVersion isKindOfClass:[NSString class]] && self.respDataVersion.length > 0)
        {
            //nextDataVersion赋值
            if ([self.cacheType isKindOfClass:[MGCacheTypeByDataVersion class]])
            {
                MGCacheTypeByDataVersion *cache = self.cacheType;
                if (!cache.onReading)
                {
                    cache.nextDataVersion = self.respDataVersion;
                }
            }
        }
        else
        {
            self.respDataVersion = nil;
        }
        return [super getOutputEntiy:responseObject];
    }
    //读本地cache
    else if ([statusCode isEqualToString:MGNetworkRespCodeUseCache])
    {
        //缓存读取
        if ([self.cacheType isKindOfClass:[MGCacheTypeByDataVersion class]])
        {
            MGCacheTypeByDataVersion *cache = (MGCacheTypeByDataVersion *)self.cacheType;
            if (cache.onReading)
            {
                NSString *msg = [NSString stringWithFormat:@"不能缓存code = '%@' 的数据", MGNetworkRespCodeUseCache];
                return herr(kInnerErrorCode, msg);
            }
            if (cache.type == MGNDCacheTypeReadBeforeRequest || cache.type == MGNDCacheTypeCallbackOnChange)
            {
                //清理了啥都不干了
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.sucessBlock = nil;
                    self.failedBlock = nil;
                    [self unHoldNetwork];
                });
                return HNDRedirectedResp; //返回重定向码，让后面流程不再处理
            }
            else
            {                
                NSData *cacheData = [cache getCacheData];
                if (!cacheData)
                {
                    return herr(kInnerErrorCode, @"缓存失效");
                }
                else
                {
                    cache.onReading = YES;
                    id resp = [self processData:cacheData];                    
                    cache.onReading = NO;
                    return resp;
                }
            }
        }
        else
        {
            NSString *msg = [NSString stringWithFormat:@"MGCacheTypeByDataVersion才支持'%@'返回码", MGNetworkRespCodeUseCache];
            return herr(kInnerErrorCode, msg);
        }
    }
    else if ([statusCode isEqualToString:MGNetworkRespCodeErrorTimestamp])
    {
        //重试
        if (self.isRetrying) { //重试中遇到时间又错了就不重试了
            return [NSError errorWithDomain:@"Server" code:kDataFormatErrorCode description:@"服务器时间校验错误"];
        }
        else
        {
            self.isRetrying = YES;
            [self startWithQueueName:self.queueName];
            return HNDRedirectedResp; //返回重定向码，让后面不要处理了
        }
    }
    else
    {
        NSString* message = [responseDict valueForKey:@"info"];
        if (!message) message = @"info字段缺失";
        //建立userInfo
        NSMutableDictionary* userInfo = [NSMutableDictionary new];
        if (message) [userInfo setValue:message forKey:NSLocalizedDescriptionKey];
        //创建error
        NSError* error = [[NSError alloc] initWithDomain:@"Server" code:statusCode.integerValue userInfo:userInfo];
        return error;
    }
}

- (void)requestFinishedFailureWithError:(NSError *)error
{
    [super requestFinishedFailureWithError:error];
    self.respDataVersion = nil;
    if ([error.domain isEqualToString:@"Server"] || error.code == kDataFormatErrorCode)
    {
        NSString *errStr = error.localizedDescription;
        errStr = [NSString stringWithFormat:@"错误:%@\n请求:%@%@\n参数:%@",errStr,self.baseURL,self.pathURL?:@"",[self.params jsonString]];
        NSError *newError = [NSError errorWithDomain:error.domain code:error.code description:errStr];
        [self.datasource reportError:newError];
    }
}
@end

#import <NSDate+ext.h>
#import <HFileCache.h>



/**
 逻辑描述
 
 读取本地数据及版本号
 将版本号拿去请求
 
 拿到数据后
 存储dataVersion和data
 本地数据在一开始返回还是在结束时返回有returnCacheFirst决定
 */

@implementation MGCacheTypeByDataVersion
+ (instancetype)createWithType:(MGNDCacheType)type
{
    MGCacheTypeByDataVersion *cacheType = [MGCacheTypeByDataVersion new];
    cacheType.type = type;
    return cacheType;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheDuration = secOfDay *365;
    }
    return self;
}
- (NSString *)oldDataVersion
{
    return [[NSString alloc] initWithData:[[HFileCache shareCache] dataForKey:[self cacheKeyOfDataVerison]] encoding:NSUTF8StringEncoding];
}
- (NSString *)cacheKeyOfDataVerison
{
    return [self.cacheKey stringByAppendingString:@".dataVersion"];
}
- (void)cacheLogic:(HNCustomCacheCallback)cacheCallback
{
    self.nextDataVersion = nil;
    if (self.type == MGNDCacheTypeReadBeforeRequest)
    {
        NSData *data = nil;
        
        NSString *cachePath = [[HFileCache shareCache] cachePathForKey:self.cacheKey];
        
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:cachePath error:nil];
        if (fileAttributes)
        {
            NSDate *createDate = fileAttributes[NSFileCreationDate];
            long interval = [[NSDate date] timeIntervalSinceDate:createDate];
            if (interval < self.cacheDuration)
            {
                data = [[HFileCache shareCache] dataForKey:self.cacheKey];
            }
        }
        cacheCallback(YES, data);
    }
    else
    {
        cacheCallback(YES, nil);
    }
}
- (NSData *)getCacheData
{
    NSData *data = nil;
    
    NSString *cachePath = [[HFileCache shareCache] cachePathForKey:self.cacheKey];
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:cachePath error:nil];
    if (fileAttributes)
    {
        NSDate *createDate = fileAttributes[NSFileCreationDate];
        long interval = [[NSDate date] timeIntervalSinceDate:createDate];
        if (interval < self.cacheDuration)
        {
            data = [[HFileCache shareCache] dataForKey:self.cacheKey];
        }
    }
    return data;
}
- (NSData *)handleRespInfo:(id)respInfo
{
    if (respInfo && self.nextDataVersion.length > 0)
    {
        NSDate *now = [NSDate date];
        [[HFileCache shareCache] setData:respInfo forKey:self.cacheKey
                                  expire:[NSDate dateWithTimeInterval:self.cacheDuration sinceDate:now]];
        
        NSData *versionData = [self.nextDataVersion dataUsingEncoding:NSUTF8StringEncoding];
        [[HFileCache shareCache] setData:versionData forKey:[self cacheKeyOfDataVerison]
                                  expire:[NSDate dateWithTimeInterval:self.cacheDuration sinceDate:now]];
    }
    return respInfo;
}


@end
