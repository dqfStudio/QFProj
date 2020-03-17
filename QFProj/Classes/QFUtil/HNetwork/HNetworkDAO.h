//
//  HNetworkDAO.h
//  QFProj
//
//  Created by dqf on 2019/1/25.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "YTKNetworkPrivate.h"
#import "YTKRequest.h"

extern const int KURLErrorCode; //网络原因引起的异常
extern const int KServerErrorCode; //服务端返回数据异常

@interface HNetworkDAO : YTKRequest

#pragma mark - 网络请求

+ (void)sendGetWithUrl:(NSString *)url
              argument:(NSDictionary *)argument
               success:(void(^)(id responseObject))success
               failure:(void(^)(NSError *error))failure;

+ (void)sendPostWithUrl:(NSString *)url
               argument:(NSDictionary *)argument
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure;

#pragma mark - 默认三次重试的网络请求

+ (void)retryGetWithUrl:(NSString *)url
               argument:(NSDictionary *)argument
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure;

+ (void)retryPostWithUrl:(NSString *)url
                argument:(NSDictionary *)argument
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure;

@end
