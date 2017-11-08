//
//  MGRequestManager.m
//  MGMobileMusic
//
//  Created by MikeWang on 2016/7/11.
//  Copyright © 2016年 migu. All rights reserved.
//

#import "MGRequestManager.h"
//#import "MGDateUtil.h"
//#import "MGClient.h"
//#import "MGHostUrlManager.h"

#define KDefaultTimeoutInterval 30

@interface MGRequestManager ()

//@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation MGRequestManager

+ (MGRequestManager *)manager {
//    NSString *hostUrl = [MGHostUrlManager sharedInstance].contentServerBaseUrl(KMGVersion1);
    return [[MGRequestManager alloc] initWithHostUrl:nil];
}


+ (MGRequestManager *)managerWithoutUrl {
    return [[MGRequestManager alloc] initWithNoUrl];
}


+ (MGRequestManager *)managerWithDebugHost {
    return [[MGRequestManager alloc] initWithHostUrl:@"http://218.200.227.207:18089/MIGUM2.0/v1.0/"];
}


+ (MGRequestManager *)managerWithUserHost {
//    NSString *hostUrl = [MGHostUrlManager sharedInstance].userServerBaseUrl(KMGVersion1);
    return [[MGRequestManager alloc] initWithHostUrl:nil];
}


+ (MGRequestManager *)managerWithProductHost {
//    NSString *hostUrl = [MGHostUrlManager sharedInstance].productServerBaseUrl(KMGVersion1);
    return [[MGRequestManager alloc] initWithHostUrl:nil];
}


- (instancetype)initWithHostUrl:(NSString *)hostUrl {
    self = [super init];
    if (self) {
//        NSURL *baseUrl = [NSURL URLWithString:hostUrl];
//        NSURLSessionConfiguration *configuration = [self defaultSessionConfiguration];
//        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl sessionConfiguration:configuration];
//        [self addHeaderWithDefaultInfo];
        [self addHeaderWithUserInfo];
    }
    return self;
}


- (instancetype)initWithNoUrl {


    self = [super init];
    if (self) {
//        NSURLSessionConfiguration *configuration = [self defaultSessionConfiguration];
//        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""] sessionConfiguration:configuration];
//        [self addHeaderWithDefaultInfo];
//        [self addHeaderWithUserInfo];
    }
    return self;
}
//
//
//- (NSURLSessionConfiguration *)defaultSessionConfiguration {
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    configuration.timeoutIntervalForRequest = KDefaultTimeoutInterval;
//    return configuration;
//}
//
//
//- (void)addHeaderWithDefaultInfo {
//    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
//    _sessionManager.responseSerializer.acceptableContentTypes = [_sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    _sessionManager.responseSerializer.acceptableContentTypes = [_sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/xml"];
//    _sessionManager.responseSerializer.acceptableContentTypes = [_sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
//
//    //后续根据后台接口还需要添加其他参数
//    [_sessionManager.requestSerializer setValue:@"0140070" forHTTPHeaderField:@"channel"];
////    [_sessionManager.requestSerializer setValue:@"014002C" forHTTPHeaderField:@"channel"];
////    [_sessionManager.requestSerializer setValue:@"014000D" forHTTPHeaderField:@"subchannel"];
//    [_sessionManager.requestSerializer setValue:@"mgm-user-agent-test" forHTTPHeaderField:@"mgm-user-agent"];
//    [_sessionManager.requestSerializer setValue:@"865168022564842" forHTTPHeaderField:@"IMEI"];
//    [_sessionManager.requestSerializer setValue:@"57415865186125" forHTTPHeaderField:@"logId"];
//    [_sessionManager.requestSerializer setValue:@"5R7CS8FW72" forHTTPHeaderField:@"IMSI"];
//    [_sessionManager.requestSerializer setValue:@"01" forHTTPHeaderField:@"mgm-Network-type"];
//    [_sessionManager.requestSerializer setValue:@"01" forHTTPHeaderField:@"mgm-Network-standard"];
//
////    [_sessionManager.requestSerializer setValue:@"444e90db-2745-4cbd-9038-759ffadf3d93" forHTTPHeaderField:@"IMSI"];
//    [_sessionManager.requestSerializer setValue:@"01" forHTTPHeaderField:@"test"];
//    [_sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
////    [_sessionManager.requestSerializer setValue:@"15198056825" forHTTPHeaderField:@"msisdn"];
//    [_sessionManager.requestSerializer setValue:@"0712a9c2d6064cd0a77979b88e40a631" forHTTPHeaderField:@"randomsessionkey"];
//    [_sessionManager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"mode"];
//    NSString *timeStep = [MGDateUtil stringWithDate:[NSDate date] format:@"yyyyMMddHHmmss"];
//    [_sessionManager.requestSerializer setValue:timeStep forHTTPHeaderField:@"timestamp"];
//}


- (void)addHeaderWithUserInfo {
    //判断是否登录，若登录添加用户以及设备相关信息

//    if ([MGAccountManager sharedInstance].isLogin) {
//        MGUserInfoItemModel *user = [MGAccountManager sharedInstance].loginUser;
//
//        [_sessionManager.requestSerializer setValue:user.msisdn forHTTPHeaderField:@"msisdn"];
//        [_sessionManager.requestSerializer setValue:user.userId forHTTPHeaderField:@"uid"];
//    }
}


- (void)addHeaderWithLoginInfo {
//    [_sessionManager.requestSerializer setValue:UA forHTTPHeaderField:@"ua"];
//    [_sessionManager.requestSerializer setValue:[[MGClient sharedInstance] appVersion] forHTTPHeaderField:@"version"];
}


- (NSMutableDictionary *)defaultParameter {
    NSMutableDictionary *aDic = [NSMutableDictionary dictionaryWithCapacity:6];
    return aDic;
}


- (void)cancelAllRequest {
//    [_sessionManager.operationQueue cancelAllOperations];
}


+ (void)dealError:(id)errorObject {
//    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
//        [UIView showToastInAppWindow:@"网络连接似乎已断开"];
//        return;
//    }
//    // 统一的错误信息处理
//    if (errorObject) {
//        if ([errorObject isKindOfClass:[NSDictionary class]]) {
//            [UIView showToastInAppWindow:errorObject[@"info"]];
//        }
//        else if ([errorObject isKindOfClass:[NSError class]]) {
//            [UIView showToastInAppWindow:((NSError *)errorObject).localizedDescription];
//        }
//    }
//    else {
//        [UIView showToastInAppWindow:@"网络请求出错"];
//    }
}


+ (void)logSuccess:(NSURLSessionDataTask *)task
            params:(NSDictionary *)params
    responseObject:(id)responseObject {
    NSLog(@"url->%@", task.originalRequest.URL.absoluteString);
    NSLog(@"params->%@", params);
    NSLog(@"responseObject->%@", responseObject);
}


+ (void)logError:(NSURLSessionDataTask *)task
          params:(NSDictionary *)params
           error:(NSError *)error {
    NSLog(@"url->%@", task.originalRequest.URL.absoluteString);
    NSLog(@"params->%@", params);
    NSLog(@"error->%@", error.userInfo);
}

@end
