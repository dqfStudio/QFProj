//
//  HNetworkDAO.h
//  QFProj
//
//  Created by dqf on 2019/1/25.
//  Copyright © 2019年 dqf. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "YTKNetworkPrivate.h"
#import "YTKRequest.h"

@interface HNetworkDAO : YTKRequest

#pragma mark - 网络请求

- (void)sendGetWithUrl:(NSString *)url
              argument:(NSDictionary *)argument
               success:(void(^)(id responseObject))success
               failure:(void(^)(NSError *error))failure;

- (void)sendPostWithUrl:(NSString *)url
               argument:(NSDictionary *)argument
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure;

#pragma mark - 默认三次重试的网络请求

- (void)retryGetWithUrl:(NSString *)url
               argument:(NSDictionary *)argument
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure;

- (void)retryPostWithUrl:(NSString *)url
                argument:(NSDictionary *)argument
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure;

@end