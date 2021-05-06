//
//  YTKRequest+Initialize.m
//  QFProj
//
//  Created by dqf on 2021/5/6.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "YTKRequest+Initialize.h"

@implementation YTKRequest (Initialize)
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
@end
