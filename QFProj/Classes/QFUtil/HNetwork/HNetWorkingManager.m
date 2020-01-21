//
//  HNetWorkingManager.m
//  QFProj
//
//  Created by wind on 2020/1/21.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HNetWorkingManager.h"
#import "YTKNetworkPrivate.h"
#import "HPingTester.h"

@interface HNetWorkingManager ()
@property (nonatomic, strong) NSArray *originUrls;
@property (nonatomic, copy)   void (^handler)(NSString *);
@end

@implementation HNetWorkingManager

+ (instancetype)shareManager {
    static HNetWorkingManager *share = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        share = [[self alloc] init];
    });
    return share;
}

#pragma mark - 网络请求

- (void)sendGetWithUrl:(NSString *)url
             paramters:(NSDictionary *)parameters
               success:(void(^)(NSDictionary *responseObject))success
               failure:(void(^)(NSError *error))failure {
    [self sendRequestWithUrl:url paramters:parameters requestWay:YTKRequestMethodGET success:success failure:failure];
}

- (void)sendPostWithUrl:(NSString *)url
              paramters:(NSDictionary *)parameters
                success:(void(^)(NSDictionary *responseObject))success
                failure:(void(^)(NSError *error))failure {
    [self sendRequestWithUrl:url paramters:parameters requestWay:YTKRequestMethodPOST success:success failure:failure];
}

- (void)sendRequestWithUrl:(NSString *)url
                 paramters:(NSDictionary *)parameters
                requestWay:(YTKRequestMethod)way
                   success:(void(^)(NSDictionary *responseObject))success
                   failure:(void(^)(NSError *error))failure {
    
    if (!url || url.length == 0) {
        failure(nil);
        return;
    }
    
    [kSimpleHTTPReq performHTTPRequest:url requestMethod:way parameters:parameters whenSeccsss:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self request:request success:success];
    } whenFailed:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self request:request failure:failure];
    }];
}

#pragma mark - 默认三次重试的网络请求

- (void)retryGetWithUrl:(NSString *)url
              paramters:(NSDictionary *)parameters
                success:(void(^)(NSDictionary *responseObject))success
                failure:(void(^)(NSError *error))failure {
    [self retryRequestWithUrl:url paramters:parameters requestWay:YTKRequestMethodGET success:success failure:failure];
}

- (void)retryPostWithUrl:(NSString *)url
               paramters:(NSDictionary *)parameters
                 success:(void(^)(NSDictionary *responseObject))success
                 failure:(void(^)(NSError *error))failure {
    [self retryRequestWithUrl:url paramters:parameters requestWay:YTKRequestMethodPOST success:success failure:failure];
}

- (void)retryRequestWithUrl:(NSString *)url
                 paramters:(NSDictionary *)parameters
                requestWay:(YTKRequestMethod)way
                   success:(void(^)(NSDictionary *responseObject))success
                   failure:(void(^)(NSError *error))failure {
    
    if (!url || url.length == 0) {
        failure(nil);
        return;
    }
    
    [kRetryDefaultHTTPReq performHTTPRequest:url requestMethod:way parameters:parameters whenSeccsss:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self request:request success:success];
    } whenFailed:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self request:request failure:failure];
    }];
}

- (void)request:(YTKBaseRequest *)request success:(void(^)(NSDictionary *responseObject))success {
    NSDictionary *responseDict = request.responseJSONObject;
    if ([[responseDict[@"status"] stringValue] isEqualToString:@"20004"]) {
        //在这里处理，登录失效，自动登录。
        // 需要先pop回root controller
        /*
        if ([HUserDefaults defaults].isLogin) {
            [[UIApplication naviTop].navigationController popToRootViewControllerAnimated:NO];
            [[UIApplication appDel] exitUserAction:^{
                NSString *msg = responseDict[@"msg"];
                msg = msg ? :@"你的登录信息已失效，请重新登录";
                [HProgressHUD showErrorWithStatus:msg delay:2];
            }];
        }
        */
        if (success) {
            success(nil);
        }
        return;
    }
    //唯一标识
    NSDictionary *fields = request.response.allHeaderFields;
    //NSString *urlStr = [NSString stringWithFormat:@"%@%@",HEADBASEINURL,kLogin];
    NSString *urlStr = request.requestUrl;
    NSURL *url = [NSURL URLWithString:urlStr];
    //获取cookie
    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:url];
    for (NSHTTPCookie *cookie in cookies) {
        if ([cookie.name isEqualToString:@"TOKEN"]) {
            //[HUserDefaults defaults].cookieToken = cookie;
        }else if ([cookie.name isEqualToString:@"SESSION"]) {
            //[HUserDefaults defaults].cookieSession = cookie;
        }else if ([cookie.name isEqualToString:@"JSESSIONID"]) {
            //新切换合并接口添加以下代码
            //[HUserDefaults defaults].jsessionSession = cookie;
        }
    }
    success(responseDict);
}

- (void)request:(YTKBaseRequest *)request failure:(void(^)(NSError *error))failure {
    NSString *description = @"服务器离家出走中，请稍后再试!";
    NSString *domain = @"HURLErrorDomain";
    NSInteger code = -1000;
    NSError *error = [NSError errorWithDomain:domain code:code userInfo:@{NSLocalizedDescriptionKey : description}];
    failure(error);
}

#pragma mark - 查找可用URL

- (void)findUsableURL:(NSArray *)urlArr callback:(void (^)(NSString *))handler {
    if (urlArr.count == 0) {
        if (handler) {
            handler(@"");
        }
    }else {
        self.handler = handler;
        self.originUrls = [urlArr copy];
        [self loopUrlAt:0 callback:handler];
    }
}

- (void)loopUrlAt:(NSInteger)index callback:(void (^)(NSString *))handler {
    if (index >= 0 && index < self.originUrls.count) {
        NSString *url = self.originUrls[index];
        __block NSInteger indexCount = index;
        [[HPingTester sharedInstance] startPingWith:url completion:^(NSString *hostName, NSTimeInterval time, NSError *error) {
            [[HPingTester sharedInstance] stopPing];
            if (error) {
                [self loopUrlAt:++indexCount callback:handler];
            }else {
                handler([hostName mutableCopy]);
            }
        }];
    }
}

@end
