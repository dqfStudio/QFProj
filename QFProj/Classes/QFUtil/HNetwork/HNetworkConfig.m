//
//  HNetworkConfig.m
//  QFProj
//
//  Created by wind on 2019/7/19.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HNetworkConfig.h"

@implementation HNetworkConfig
+ (HNetworkConfig *)sharedConfig {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        //https 允许无效证书访问
        AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [security setValidatesDomainName:NO];
        security.allowInvalidCertificates = YES;
        [YTKNetworkConfig sharedConfig].securityPolicy = security;
    }
    return self;
}
- (void)setBaseUrl:(NSString *)baseUrl {
    if (_baseUrl != baseUrl) {
        _baseUrl = nil;
        _baseUrl = baseUrl;
        //set base url
        [[YTKNetworkConfig sharedConfig] setBaseUrl:_baseUrl];
    }
}
@end
