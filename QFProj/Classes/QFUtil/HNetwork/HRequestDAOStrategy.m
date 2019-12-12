//
//  HRequestDAOStrategy.m
//  QFProj
//
//  Created by dqf on 2019/7/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HRequestDAOStrategy.h"

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
- (void)beforePerformSuccessBlock:(HRequest *)req {
    NSLog(@"%@ success block will callback", [self requestName:req]);
}
- (void)afterPerformSuccessBlock:(HRequest *)req {
    NSLog(@"%@ success block did callback", [self requestName:req]);
}
- (BOOL)beforePerformFailedBlock:(HRequest *)req {
    NSLog(@"%@ failed block will callback", [self requestName:req]);
    return YES;
}
- (void)afterPerformFailedBlock:(HRequest *)req {
    NSLog(@"%@ failed block did callback", [self requestName:req]);
}
- (NSString *)requestName:(YTKBaseRequest *)req {
    if (req.userInfo && [req.userInfo.allKeys containsObject:@"name"]) {
        return [req.userInfo objectForKey:@"name"];
    }
    if (req.tag > 0) {
        return [NSString stringWithFormat:@"Request-%ld", (long)req.tag];
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
- (void)afterPerformFailedBlock:(HRequest *)req {
    // 使用Jerry的错误日志上传
    //[KYUploadFileDTO uploadErrorMessageBaseRequest:req];
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
- (void)afterPerformSuccessBlock:(HRequest *)req {
    tryCount = 0;
}
- (BOOL)beforePerformFailedBlock:(HRequest *)req {
    if (tryCount < self.tryMax) {
        [req performSelector:@selector(retry) withObject:nil afterDelay:0.25];
        return NO;
    }
    return YES;
}
@end


@implementation HPollingStrategy {
    NSInteger pollingCount;
}
- (instancetype)init {
    if (self = [super init]) {
        pollingCount = 0;
    }
    return self;
}
- (void)requestWillStart:(id)request {
    pollingCount ++;
}
- (void)afterPerformSuccessBlock:(HRequest *)req {
    pollingCount = 0;
}
- (BOOL)beforePerformFailedBlock:(HRequest *)req {
    if (pollingCount < _pollingArr.count) {
        NSString *url = [_pollingArr objectAtIndex:pollingCount];
        req.url = url;
        [req performSelector:@selector(retry) withObject:nil afterDelay:0.25];
        return NO;
    }
    return YES;
}
@end
