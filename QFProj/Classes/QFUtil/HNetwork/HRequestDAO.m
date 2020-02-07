//
//  HRequestDAO.m
//  HProjectModel1
//
//  Created by dqf on 2019/1/25.
//  Copyright © 2019年 dqf. All rights reserved.
//

#import "HRequestDAO.h"

@interface HRequestDAO () {
    NSInteger tryCount; //当前重试次数
    NSInteger tryMax; //最大重试次数
}
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSDictionary *argument;
@property (nonatomic, assign) YTKRequestMethod method;
//block回调
@property (nonatomic, copy) YTKRequestCompletionBlock successBlock;
@property (nonatomic, copy) YTKRequestCompletionBlock failureBlock;
@end

@implementation HRequestDAO
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //https 允许无效证书访问
        AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [security setValidatesDomainName:NO];
        security.allowInvalidCertificates = YES;
        [YTKNetworkConfig sharedConfig].securityPolicy = security;
    });
}
#pragma mark - 基本参数
#pragma mark -
- (NSString *)requestUrl {
    return _url;
}
- (YTKRequestMethod)requestMethod {
    return _method;
}
- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}
- (id)requestArgument {
    return _argument;
}
#pragma mark - 基础请求
#pragma mark -
- (void)performWithUrl:(NSString *)url
                method:(YTKRequestMethod)method
              argument:(NSDictionary *)argument
           whenSeccsss:(YTKRequestCompletionBlock)sucBlock
            whenFailed:(YTKRequestCompletionBlock)failBlock {
    
    self.url = url;
    self.method = method;
    self.argument = argument;
    
    _successBlock = sucBlock;
    _failureBlock = failBlock;
    
    [self retry];
}
- (void)retry {
    [self startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [self requestFinished:request];
    } failure:^(YTKBaseRequest *request) {
        [self requestFailed:request];
    }];
}
- (void)requestFinished:(__kindof YTKBaseRequest *)request {
    if (self.successBlock) {
        self.successBlock(request);
    }
}
- (void)requestFailed:(__kindof YTKBaseRequest *)request {
    ++tryCount;
    if (tryCount < tryMax) {
        [self performSelector:@selector(retry) withObject:nil afterDelay:0.25];
    }else if (self.failureBlock) {
        self.failureBlock(request);
    }
}
#pragma mark - 扩展请求
#pragma mark -
//执行HTTP请求
- (void)performWithUrl:(NSString *)url
                method:(YTKRequestMethod)method
              argument:(NSDictionary *)argument
               success:(void(^)(id responseObject))success
               failure:(void(^)(NSError *error))failure {
    //此处需要根据实际值修改
    NSString *baseUrl = @"";
    if (baseUrl.length > 0 && url.length > 0) {
        if (![url hasPrefix:baseUrl]) {
            url = [baseUrl stringByAppendingString:url];
        }
        if (![YTKNetworkConfig sharedConfig].baseUrl) {
            [YTKNetworkConfig sharedConfig].baseUrl = [baseUrl mutableCopy];
        }
        [self performWithUrl:url method:method argument:argument whenSeccsss:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self request:request success:success];
        } whenFailed:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self request:request failure:failure];
        }];
    }
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
#pragma mark - 网络请求
#pragma mark -
- (void)sendGetWithUrl:(NSString *)url
              argument:(NSDictionary *)argument
               success:(void(^)(id responseObject))success
               failure:(void(^)(NSError *error))failure {
    [self performWithUrl:url method:YTKRequestMethodGET argument:argument success:success failure:failure];
}
- (void)sendPostWithUrl:(NSString *)url
               argument:(NSDictionary *)argument
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure {
    [self performWithUrl:url method:YTKRequestMethodPOST argument:argument success:success failure:failure];
}
#pragma mark - 默认三次重试的网络请求
#pragma mark -
- (void)retryGetWithUrl:(NSString *)url
               argument:(NSDictionary *)argument
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure {
    tryMax = 3;
    [self performWithUrl:url method:YTKRequestMethodGET argument:argument success:success failure:failure];
}
- (void)retryPostWithUrl:(NSString *)url
                argument:(NSDictionary *)argument
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure {
    tryMax = 3;
    [self performWithUrl:url method:YTKRequestMethodPOST argument:argument success:success failure:failure];
}
@end
