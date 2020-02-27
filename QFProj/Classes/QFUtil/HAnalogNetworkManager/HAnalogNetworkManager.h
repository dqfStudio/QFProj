//
//  HAnalogNetworkManager.h
//  QFProj
//
//  Created by dqf on 2018/8/17.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HAutoFill.h"

@interface HAnalogNetworkManager : NSObject

+ (instancetype)shareManager;

#pragma mark - 根据类填充

- (void)sendGetWithClass:(Class)cls
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure;

- (void)sendPostWithClass:(Class)cls
                  success:(void(^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure;

#pragma mark - 根据字典填充

- (void)sendGetWithDict:(NSDictionary *)dict
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure;

- (void)sendPostWithDict:(NSDictionary *)dict
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure;

@end
