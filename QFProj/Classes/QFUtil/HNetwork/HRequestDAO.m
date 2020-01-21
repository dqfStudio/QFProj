//
//  HRequestDAO.m
//  HProjectModel1
//
//  Created by dqf on 2019/1/25.
//  Copyright © 2019年 dqf. All rights reserved.
//

#import "HRequestDAO.h"

@interface HRequestDAO ()
@property (nonatomic) NSMutableArray<id<HRequestStrategy>> *requestStrategies;
@end

@implementation HRequestDAO
- (void)addStrategy:(id<HRequestStrategy>)strategy {
    if (strategy) {
        if (!self.requestStrategies) {
            self.requestStrategies = [NSMutableArray array];
        }
        [self.requestStrategies addObject:strategy];
    }
}
//继承父类重试方法
- (void)retry {
    [super retry];
    [self startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [self requestFinished:request];
    } failure:^(YTKBaseRequest *request) {
        [self requestFailed:request];
    }];
}
- (void)dealloc {
    if (self.requestStrategies.count > 0) {
        [self.requestStrategies removeAllObjects];
        _requestStrategies = nil;
    }
}
// 执行GET请求
- (void)performGetRequest:(NSString *)url
               parameters:(NSDictionary *)args
              whenSeccsss:(YTKRequestCompletionBlock)sucBlock
               whenFailed:(YTKRequestCompletionBlock)failBlock {
    [self performHTTPRequest:url
               requestMethod:YTKRequestMethodGET
              parameters:args
                 whenSeccsss:sucBlock
                  whenFailed:failBlock];
}
// 执行POST请求
- (void)performPostRequest:(NSString *)url
                parameters:(NSDictionary *)args
               whenSeccsss:(YTKRequestCompletionBlock)sucBlock
                whenFailed:(YTKRequestCompletionBlock)failBlock {
    [self performHTTPRequest:url
               requestMethod:YTKRequestMethodPOST
              parameters:args
                 whenSeccsss:sucBlock
                  whenFailed:failBlock];
}
#pragma mark- YTKRequestDelegate
- (void)requestFinished:(__kindof YTKBaseRequest *)request {
    for (id<HRequestStrategy> strategy in self.requestStrategies) {
        if ([strategy respondsToSelector:@selector(beforePerformSuccessBlock:)]) {
            [strategy beforePerformSuccessBlock:self];
        }
    }
    if (self.successBlock) {
        self.successBlock(request);
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
    /*
    NSString *description = @"服务器离家出走中，请稍后再试!";
    NSString *domain = @"HURLErrorDomain";
    NSInteger code = -1000;
    NSError *error = [NSError errorWithDomain:domain code:code userInfo:@{NSLocalizedDescriptionKey : description}];
    failure(error);
    */
    if (self.failureBlock) {
        self.failureBlock(request);
    }
    for (id<HRequestStrategy> strategy in self.requestStrategies) {
        if ([strategy respondsToSelector:@selector(afterPerformFailedBlock:)]) {
            [strategy afterPerformFailedBlock:self];
        }
    }
}
@end
