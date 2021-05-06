//
//  HNetworkManager.m
//  QFProj
//
//  Created by dqf on 2020/1/21.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HNetworkManager.h"
#import "HPingTester.h"

@interface HNetworkManager ()
@property (nonatomic, strong) NSArray *originUrls;
@property (nonatomic, copy)   void (^handler)(NSString *);
@end

@implementation HNetworkManager

+ (instancetype)shareManager {
    static HNetworkManager *share = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        share = [[self alloc] init];
    });
    return share;
}

#pragma mark - 网络请求

- (void)sendGetWithUrl:(NSString *)url
              argument:(NSDictionary *)argument
               success:(void(^)(id responseObject))success
               failure:(void(^)(NSError *error))failure {
    [HNetworkDAO sendGetWithUrl:url argument:argument success:success failure:failure];
}
- (void)sendPostWithUrl:(NSString *)url
               argument:(NSDictionary *)argument
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure {
    [HNetworkDAO sendPostWithUrl:url argument:argument success:success failure:failure];
}

#pragma mark - 默认三次重试的网络请求

- (void)retryGetWithUrl:(NSString *)url
               argument:(NSDictionary *)argument
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure {
    [HNetworkDAO retryGetWithUrl:url argument:argument success:success failure:failure];
}
- (void)retryPostWithUrl:(NSString *)url
                argument:(NSDictionary *)argument
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure {
    [HNetworkDAO retryPostWithUrl:url argument:argument success:success failure:failure];
}

#pragma mark - 上传下载图片

- (void)uploadImage:(UIImage *)image
           argument:(NSDictionary *)argument
            success:(void(^)(id responseObject))success
           progress:(void(^)(NSProgress *))progress
            failure:(void(^)(NSError *error))failure {
    HUploadImageDAO *uploadImageDAO = [[HUploadImageDAO alloc] initWithImage:image argument:argument];
    [uploadImageDAO setUploadProgressBlock:^(NSProgress * _Nonnull progressValue) {
        if (progress) progress(progressValue);
    }];
    [uploadImageDAO startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (success) success(request.responseObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (failure) failure(request.error);
    }];
}

- (void)downloadWithImageId:(NSString *)imageId
                   argument:(NSDictionary *)argument
                    success:(void(^)(id responseObject))success
                   progress:(void(^)(NSProgress *))progress
                    failure:(void(^)(NSError *error))failure {
    HDownloadImageDAO *downloadImageDAO = [[HDownloadImageDAO alloc] initWithImageId:imageId argument:argument];
    [downloadImageDAO setResumableDownloadProgressBlock:^(NSProgress * _Nonnull progressValue) {
        if (progress) progress(progressValue);
    }];
    [downloadImageDAO startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (success) success(request.responseObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (failure) failure(request.error);
    }];
}

#pragma mark - 查找可用URL

- (void)findUsableURL:(NSArray *)urlArr callback:(void (^)(NSString *))handler {
    if (urlArr.count == 0) {
        if (handler) {
            handler(@"");
        }
    }else {
        self.handler = handler;
        self.originUrls = [urlArr copy];
        [self loopUrlAt:0 callback:handler];
    }
}

- (void)loopUrlAt:(NSInteger)index callback:(void (^)(NSString *))handler {
    if (index >= 0 && index < self.originUrls.count) {
        NSString *url = self.originUrls[index];
        __block NSInteger indexCount = index;
        [[HPingTester sharedInstance] startPingWith:url completion:^(NSString *hostName, NSTimeInterval time, NSError *error) {
            [[HPingTester sharedInstance] stopPing];
            if (error) {
                [self loopUrlAt:++indexCount callback:handler];
            }else {
                handler([hostName mutableCopy]);
            }
        }];
    }
}

@end
