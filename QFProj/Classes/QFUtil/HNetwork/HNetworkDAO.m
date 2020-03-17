//
//  HNetworkDAO.m
//  QFProj
//
//  Created by dqf on 2019/1/25.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import "HNetworkDAO.h"

const int KURLErrorCode = -10000; //网络原因引起的异常
const int KServerErrorCode = -10001; //服务端返回数据异常

@interface HNetworkDAO ()
@property (nonatomic, assign) NSInteger tryCount; //当前重试次数
@property (nonatomic, assign) NSInteger tryMax; //最大重试次数
//url参数
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSDictionary *argument;
@property (nonatomic, assign) YTKRequestMethod method;
//block回调
@property (nonatomic, copy) YTKRequestCompletionBlock successBlock;
@property (nonatomic, copy) YTKRequestCompletionBlock failureBlock;
@end

@implementation HNetworkDAO
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //https 允许无效证书访问
        AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        security.validatesDomainName = NO;
        security.allowInvalidCertificates = YES;
        [YTKNetworkConfig sharedConfig].securityPolicy = security;
        //此处需要根据实际值修改
        [YTKNetworkConfig sharedConfig].baseUrl = @"";
        //设置serializer相关属性
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        serializer.removesKeysWithNullValues = YES;
        serializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
        serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html",@"text/css", nil];
        [[YTKNetworkAgent sharedAgent] setValue:serializer forKey:@"_jsonResponseSerializer"];
        
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
    ++_tryCount;
    if (_tryCount < _tryMax) {
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
    NSString *baseUrl = [YTKNetworkConfig sharedConfig].baseUrl;
    if (baseUrl.length > 0) {
        if (!url || url.length == 0) {
            url = baseUrl;
        }else if (![url hasPrefix:baseUrl]) {
            url = [baseUrl stringByAppendingString:url];
        }
        [self performWithUrl:url method:method argument:argument whenSeccsss:^(__kindof YTKBaseRequest *_Nonnull request) {
            id responseObject = request.responseJSONObject;
            if ([responseObject isKindOfClass:NSDictionary.class]) {
                NSString *status = [responseObject[@"status"] stringValue];
                if ([status isEqualToString:@"10000"]) {
                    [self request:request success:success];
                }else {
                    [self request:request serverErrorFailure:failure];
                }
            }else if ([responseObject isKindOfClass:NSArray.class]) {
                NSArray *responseArray = responseObject;
                if (responseArray.count > 0) {
                    [self request:request success:success];
                }else {
                    [self request:request serverErrorFailure:failure];
                }
            }
        } whenFailed:^(__kindof YTKBaseRequest *_Nonnull request) {
            [self request:request urlErrorFailure:failure];
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
- (void)request:(YTKBaseRequest *)request urlErrorFailure:(void(^)(NSError *error))failure {
    NSString *description = @"服务器离家出走中，请稍后再试!";
    NSString *domain = @"HURLErrorDomain";
    NSInteger code = KURLErrorCode;
    NSError *error = [NSError errorWithDomain:domain code:code userInfo:@{NSLocalizedDescriptionKey : description}];
    failure(error);
}
- (void)request:(YTKBaseRequest *)request serverErrorFailure:(void(^)(NSError *error))failure {
    NSString *description = @"数据返回异常!";
    NSString *domain = @"HServerErrorDomain";
    NSInteger code = KServerErrorCode;
    NSError *error = [NSError errorWithDomain:domain code:code userInfo:@{NSLocalizedDescriptionKey : description}];
    failure(error);
}
#pragma mark - 网络请求
#pragma mark -
+ (void)sendGetWithUrl:(NSString *)url
              argument:(NSDictionary *)argument
               success:(void(^)(id responseObject))success
               failure:(void(^)(NSError *error))failure {
    [HNetworkDAO.new performWithUrl:url method:YTKRequestMethodGET argument:argument success:success failure:failure];
}
+ (void)sendPostWithUrl:(NSString *)url
               argument:(NSDictionary *)argument
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure {
    [HNetworkDAO.new performWithUrl:url method:YTKRequestMethodPOST argument:argument success:success failure:failure];
}
#pragma mark - 默认三次重试的网络请求
#pragma mark -
+ (void)retryGetWithUrl:(NSString *)url
               argument:(NSDictionary *)argument
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure {
    HNetworkDAO *networkDAO = HNetworkDAO.new;
    networkDAO.tryMax = 3;
    [networkDAO performWithUrl:url method:YTKRequestMethodGET argument:argument success:success failure:failure];
}
+ (void)retryPostWithUrl:(NSString *)url
                argument:(NSDictionary *)argument
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure {
    HNetworkDAO *networkDAO = HNetworkDAO.new;
    networkDAO.tryMax = 3;
    [networkDAO performWithUrl:url method:YTKRequestMethodPOST argument:argument success:success failure:failure];
}
@end
