//
//  HRequest.m
//  QFProj
//
//  Created by dqf on 2019/7/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HRequest.h"

@implementation HRequest
- (NSString *)requestUrl {
    return _url;
}
- (YTKRequestMethod)requestMethod {
    return _method;
}
- (NSDictionary *)requestHeaderFieldValueDictionary {
//    if (HEADH5BASEINURL.length > 0) {
//        return @{@"referer": HEADH5BASEINURL};
//    }
    return nil;
}
- (id)requestArgument {
    return _argument;
}
//重试方法，需要子类继承
- (void)retry {
    /*AFHTTPSessionManager *sessionManager = [[YTKNetworkAgent sharedAgent] manager];
    __block AFHTTPSessionManager *sessionManagerBlock = sessionManager;
    [sessionManager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
         //这里可以重新修改重新向后的请求方式和参数。
         if (request) {
             NSString *platCode = @"";
             NSString *baseLink = nil;
             NSString *h5Link = nil;
//             if (platCode) {
//                 platCode = [platCode stringByAppendingString:@"/"];
                 NSString *absoluteString = request.URL.absoluteString;
                 if (absoluteString) {
                     //set base link
                     NSRange range = [absoluteString rangeOfString:platCode];
                     if (range.location != NSNotFound) {
                         if (absoluteString.length >= range.location+range.length) {
                             baseLink = [absoluteString substringToIndex:range.location+range.length];
                             //[[HUserDefaults defaults] setBaseLink:baseLink];
                             [[YTKNetworkConfig sharedConfig] setBaseUrl:baseLink];
                         }
                         //set h5 link
                         if (absoluteString.length >= range.location) {
                             h5Link = [absoluteString substringToIndex:range.location];
                             //[[HUserDefaults defaults] setH5Link:h5Link];
                         }
                     }
                 }
//             }
             //set h5 link
             if (!h5Link) {
                 h5Link = [HUserDefaults defaults].h5Link;
             }
             
             NSString *method = @"GET";
             if (_method == YTKRequestMethodPOST) method = @"POST";
             
             NSMutableURLRequest *mutRequest = [sessionManagerBlock.requestSerializer requestWithMethod:method URLString:request.URL.absoluteString parameters:_argument error:nil];
             // 存放新添加的cookie
//             NSString *cookieString = nil;
//             NSHTTPCookie *cookieToken = [HUserDefaults defaults].cookieToken;
//             if (cookieToken) {
//                 cookieString = [NSString stringWithFormat:@"%@=%@;", cookieToken.name, cookieToken.value];
//             }
//             // 将cookie存到请求头中
//             if (cookieString.length > 0) {
//                 [mutRequest addValue:h5Link forHTTPHeaderField:@"referer"];
//                 [mutRequest addValue:cookieString forHTTPHeaderField:@"Cookie"];
//             }else {
//                 [mutRequest addValue:h5Link forHTTPHeaderField:@"referer"];
//             }
             return mutRequest;
         }
         return nil;
         
     }];*/
}
//执行HTTP请求
- (void)performHTTPRequest:(NSString *)url
             requestMethod:(YTKRequestMethod)method
                parameters:(NSDictionary *)args
               whenSeccsss:(YTKRequestCompletionBlock)sucBlock
                whenFailed:(YTKRequestCompletionBlock)failBlock {
    NSString *baseUrl = @"";//此处需要根据实际值修改
    baseUrl = baseUrl ?: @"";
    url = url ?: @"";
    
    if ([url hasPrefix:baseUrl]) {
        self.url = url;
    }else {
        self.url = [baseUrl stringByAppendingString:url];
    }
    
    self.argument = args;
    self.method = method;
    
    _successBlock = sucBlock;
    _failureBlock = failBlock;
    
    [self retry];
}
@end
