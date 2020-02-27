//
//  HAnalogNetworkManager.m
//  QFProj
//
//  Created by dqf on 2018/8/17.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HAnalogNetworkManager.h"

@implementation HAnalogNetworkManager

+ (instancetype)shareManager {
    static HAnalogNetworkManager *share = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        share = [[self alloc] init];
    });
    return share;
}

#pragma mark - 根据类填充

- (void)sendGetWithClass:(Class)cls success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (success) {
            success([cls autoFill]);
        }else if (failure) {
            failure(NSError.new);
        }
    });
}
- (void)sendPostWithClass:(Class)cls success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (success) {
            success([cls autoFill]);
        }else if (failure) {
            failure(NSError.new);
        }
    });
}

#pragma mark - 根据字典填充

- (void)sendGetWithDict:(NSDictionary *)dict success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (success) {
            success(dict);
        }else if (failure) {
            failure(NSError.new);
        }
    });
}
- (void)sendPostWithDict:(NSDictionary *)dict success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (success) {
            success(dict);
        }else if (failure) {
            failure(NSError.new);
        }
    });
}

@end
