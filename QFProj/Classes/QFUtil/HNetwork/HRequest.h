//
//  HRequest.h
//  QFProj
//
//  Created by dqf on 2019/7/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "YTKRequest.h"
#import "YTKNetworkPrivate.h"

@interface HRequest : YTKRequest <YTKRequestDelegate>
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSDictionary *argument;
@property (nonatomic, assign) YTKRequestMethod method;
@property (nonatomic, copy) YTKRequestCompletionBlock successBlock;
@property (nonatomic, copy) YTKRequestCompletionBlock failureBlock;
//重试方法，需要子类继承
- (void)retry;
// 执行HTTP请求
- (void)performHTTPRequest:(NSString *)url
             requestMethod:(YTKRequestMethod)method
                parameters:(NSDictionary *)args
               whenSeccsss:(YTKRequestCompletionBlock)sucBlock
                whenFailed:(YTKRequestCompletionBlock)failBlock;
@end
