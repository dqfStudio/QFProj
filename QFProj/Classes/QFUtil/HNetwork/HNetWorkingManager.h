//
//  HNetWorkingManager.h
//  QFProj
//
//  Created by wind on 2020/1/21.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "HRequestDAOFactory.h"

@interface HNetWorkingManager : AFHTTPSessionManager

+ (instancetype)shareManager;

#pragma mark - 网络请求
/**
 *  @param url              请求url
 *  @param parameters       请求的参数
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 */

- (void)sendGetWithUrl:(NSString *)url
             paramters:(NSDictionary *)parameters
               success:(void(^)(NSDictionary *responseObject))success
               failure:(void(^)(NSError *error))failure;

- (void)sendPostWithUrl:(NSString *)url
              paramters:(NSDictionary *)parameters
                success:(void(^)(NSDictionary *responseObject))success
                failure:(void(^)(NSError *error))failure;

#pragma mark - 默认三次重试的网络请求
/**
 *  @param url              请求url
 *  @param parameters       请求的参数
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 */

- (void)retryGetWithUrl:(NSString *)url
              paramters:(NSDictionary *)parameters
                success:(void(^)(NSDictionary *responseObject))success
                failure:(void(^)(NSError *error))failure;

- (void)retryPostWithUrl:(NSString *)url
               paramters:(NSDictionary *)parameters
                 success:(void(^)(NSDictionary *responseObject))success
                 failure:(void(^)(NSError *error))failure;

#pragma mark - 查找可用URL

- (void)findUsableURL:(NSArray *)urlArr callback:(void (^)(NSString *))handler;

@end
