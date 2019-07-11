//
//  HRequestDAO.m
//  HProjectModel1
//
//  Created by wind on 2019/1/25.
//  Copyright © 2019年 dqf. All rights reserved.
//

#import "HRequest.h"

#pragma mark- 扩展YTKRequest
#pragma mark-

@implementation HRequest
- (id)initWithUrl:(NSString *)url info:(NSDictionary *)info method:(YTKRequestMethod)method {
    self = [super init];
    if (self) {
        NSString *baseUrl = @"";
        baseUrl = baseUrl ?: @"";
        url = url ? :@"";
        baseUrl = [baseUrl stringByAppendingString:url];
        _url = baseUrl;
        _info = info;
        _requestMethod = method;
    }
    return self;
}
- (NSString *)requestUrl {
    return _url;
}
- (YTKRequestMethod)requestMethod {
    return _requestMethod;
}
- (NSDictionary *)requestHeaderFieldValueDictionary {
//    if (HEADH5BASEINURL.length > 0) {
//        // 存放新添加的cookie
//        NSString *cookieString = nil;
//        NSHTTPCookie *cookieToken = [HUserDefaults defaults].cookieToken;
//        if (cookieToken) {
//            cookieString = [NSString stringWithFormat:@"%@=%@;", cookieToken.name, cookieToken.value];
//        }
//        // 将cookie存到请求头中
//        if (cookieString.length > 0) {
//            return @{@"referer": HEADH5BASEINURL, @"Cookie": cookieString};
//        }else {
//            return @{@"referer": HEADH5BASEINURL};
//        }
//    }
    return nil;
}
- (id)requestArgument {
    return _info;
}
@end

#pragma mark- HTTPRequest类
#pragma mark-

@implementation HRequestDAO
- (HRequest *)request {
    if (!_request) {
        _request = HRequest.new;
    }
    return _request;
}
// 执行POST请求
- (void)performPostRequest:(NSString *)url
            withParameters:(NSDictionary *)args
               whenSeccsss:(YTKRequestCompletionBlock)sucBlock
                whenFailed:(YTKRequestCompletionBlock)failBlock {
    [self performHTTPRequest:url
               requestMethod:YTKRequestMethodPOST
              withParameters:args
                 whenSeccsss:sucBlock
                  whenFailed:failBlock];
}

// 执行HTTP请求
- (void)performHTTPRequest:(NSString *)url
             requestMethod:(YTKRequestMethod)method
            withParameters:(NSDictionary *)args
               whenSeccsss:(YTKRequestCompletionBlock)sucBlock
                whenFailed:(YTKRequestCompletionBlock)failBlock {
    NSString *baseUrl = @"";
    baseUrl = baseUrl ?: @"";
    url = url ?: @"";
    
    if ([url hasPrefix:baseUrl]) {
        self.request.url = url;
    }else {
        self.request.url = [baseUrl stringByAppendingString:url];
    }
    
    self.request.info = args;
    self.request.requestMethod = method;
    
    _successCompletionBlock = sucBlock;
    _failureCompletionBlock = failBlock;
    
    [self retry];
}
- (void)retry {
    [self.request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [self requestFinished:request];
    } failure:^(YTKBaseRequest *request) {
        [self requestFailed:request];
    }];
}
- (void)addStrategy:(id<HRequestStrategy>)strategy {
    if (strategy) {
        if (!self.requestStrategies) {
            self.requestStrategies = [NSMutableArray array];
        }
        [self.requestStrategies addObject:strategy];
    }
}
- (void)dealloc {
    if (self.requestStrategies.count > 0) {
        [self.requestStrategies removeAllObjects];
        _requestStrategies = nil;
    }
}
#pragma mark- YTKRequestDelegate
- (void)requestFinished:(__kindof YTKBaseRequest *)request {
    for (id<HRequestStrategy> strategy in self.requestStrategies) {
        if ([strategy respondsToSelector:@selector(beforePerformSuccessBlock:)]) {
            [strategy beforePerformSuccessBlock:self];
        }
    }
    if (self.successCompletionBlock) {
        self.successCompletionBlock(request);
    }
    for (id<HRequestStrategy> strategy in self.requestStrategies) {
        if ([strategy respondsToSelector:@selector(afterPerformSuccessBlock:)]) {
            [strategy afterPerformSuccessBlock:self];
        }
    }
}
- (void)requestFailed:(__kindof YTKBaseRequest *)request {
    for (id<HRequestStrategy> strategy in self.requestStrategies) {
        if ([strategy respondsToSelector:@selector(beforePerformFailedBlock:)]) {
            if (![strategy beforePerformFailedBlock:self]) {
                return;
            }
        }
    }
    if (self.failureCompletionBlock) {
        self.failureCompletionBlock(request);
    }
    for (id<HRequestStrategy> strategy in self.requestStrategies) {
        if ([strategy respondsToSelector:@selector(afterPerformFailedBlock:)]) {
            [strategy afterPerformFailedBlock:self];
        }
    }
}
@end

#pragma mark- 各种Strategy
#pragma mark-

@implementation HDebugStrategy
- (void)requestWillStart:(id)request {
    NSLog(@"%@ will start", [self requestName:request]);
}
- (void)requestWillStop:(id)request {
    NSLog(@"%@ will stop", [self requestName:request]);
}
- (void)requestDidStop:(id)request {
    NSLog(@"%@ did stop", [self requestName:request]);
}
- (void)beforePerformSuccessBlock:(HRequestDAO *)req {
    NSLog(@"%@ success block will callback", [self requestName:req.request]);
}
- (void)afterPerformSuccessBlock:(HRequestDAO *)req {
    NSLog(@"%@ success block did callback", [self requestName:req.request]);
}
- (BOOL)beforePerformFailedBlock:(HRequestDAO *)req {
    NSLog(@"%@ failed block will callback", [self requestName:req.request]);
    return YES;
}
- (void)afterPerformFailedBlock:(HRequestDAO *)req {
    NSLog(@"%@ failed block did callback", [self requestName:req.request]);
}
- (NSString *)requestName:(YTKBaseRequest *)req {
    if (req.userInfo && [req.userInfo.allKeys containsObject:@"name"]) {
        return [req.userInfo objectForKey:@"name"];
    }
    if (req.tag > 0) {
        return [NSString stringWithFormat:@"Request-%ld", req.tag];
    }
    NSString *url = [req requestUrl];
    if (url.length > 0) {
        return [url lastPathComponent];
    }
    return [req baseUrl];
}
@end


@implementation HLogErrorStrategy
// 请求出错后处理
- (void)afterPerformFailedBlock:(HRequestDAO *)req {
    // 使用Jerry的错误日志上传
    //[KYUploadFileDTO uploadErrorMessageBaseRequest:req.request];
}
@end


@implementation HRetryStrategy {
    NSInteger tryCount;
}
- (instancetype)init {
    if (self = [super init]) {
        _tryMax = 3;
        tryCount = 0;
    }
    return self;
}
- (void)requestWillStart:(id)request {
    tryCount ++;
}
- (void)afterPerformSuccessBlock:(HRequestDAO *)req {
    tryCount = 0;
}
- (BOOL)beforePerformFailedBlock:(HRequestDAO *)req {
    if (tryCount < self.tryMax) {
        //req.request.requestURL = @"backup_url"; //重试其他URL
        [req performSelector:@selector(retry) withObject:nil afterDelay:0.25];
        return NO;
    }
    return YES;
}
@end

#pragma mark- 工厂类
#pragma mark-

@implementation HRequestDAOFactory
+ (HRequestDAO *)createSimpleRequest {
    return HRequestDAO.new;
}
+ (HRequestDAO *)createPowerfullRequest {
    HRequestDAO *httpRequest = HRequestDAO.new;
    
//#if DEBUG
//    HDebugStrategy *debugStrgy = HDebugStrategy.new;
//    [httpRequest.request addAccessory:debugStrgy];
//    [httpRequest addStrategy:debugStrgy];
//#endif
    
    HLogErrorStrategy *logStrgy = HLogErrorStrategy.new;
    [httpRequest.request addAccessory:logStrgy];
    [httpRequest addStrategy:logStrgy];
    
    HRetryStrategy *retryStrgy = HRetryStrategy.new;
    [httpRequest.request addAccessory:retryStrgy];
    [httpRequest addStrategy:retryStrgy];
    
    return httpRequest;
}
@end
