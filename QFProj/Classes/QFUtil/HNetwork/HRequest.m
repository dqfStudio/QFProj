//
//  HRequest.m
//  QFProj
//
//  Created by wind on 2019/7/11.
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
//重试方法，需要子类覆盖
- (void)retry {}
//执行HTTP请求
- (void)performHTTPRequest:(NSString *)url
             requestMethod:(YTKRequestMethod)method
            withParameters:(NSDictionary *)args
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
