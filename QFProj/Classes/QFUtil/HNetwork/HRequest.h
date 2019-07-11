//
//  HRequestDAO.h
//  HProjectModel1
//
//  Created by wind on 2019/1/25.
//  Copyright © 2019年 dqf. All rights reserved.
//

#import "YTKRequest.h"

// 加强的HTTP请求类实例
#ifndef kRetryHTTPReq
#define kRetryHTTPReq   ([HRequestDAOFactory createSimpleRequest])
#endif

// 基础HTTP请求类实例
#ifndef kBaseHTTPReq
#define kBaseHTTPReq    ([HRequestDAOFactory createPowerfullRequest])
#endif

@class HRequestDAO;

@protocol HRequestStrategy <YTKRequestAccessory>
@optional
// 请求成功，调用成功block之前调用此方法
- (void)beforePerformSuccessBlock:(HRequestDAO *)req;

// 请求成功，调用成功block之后调用此方法
- (void)afterPerformSuccessBlock:(HRequestDAO *)req;

/* 请求失败，调用成功block之前调用此方法；
 * 返回NO，则截断之后的调用（包括其他的beforePerformFailedBlock方法、
 * failureCompletionBlock、afterPerformFailedBlock方法）
 */
- (BOOL)beforePerformFailedBlock:(HRequestDAO *)req;

// 请求失败，调用失败block之后调用此方法
- (void)afterPerformFailedBlock:(HRequestDAO *)req;
@end


@interface HRequest : YTKRequest
@property (nonatomic, copy) NSDictionary *info;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) YTKRequestMethod requestMethod;

- (instancetype)initWithUrl:(NSString *)url
                       info:(NSDictionary *)info
                     method:(YTKRequestMethod)method;

@end


@interface HRequestDAO : NSObject <YTKRequestDelegate>
@property (nonatomic, strong) HRequest *request;
@property (nonatomic, strong) NSMutableArray<id<HRequestStrategy>> *requestStrategies;
@property (nonatomic, copy, readonly) YTKRequestCompletionBlock successCompletionBlock;
@property (nonatomic, copy, readonly) YTKRequestCompletionBlock failureCompletionBlock;

// 添加策略
- (void)addStrategy:(id<HRequestStrategy>)strategy;

// 执行HTTP请求
- (void)performHTTPRequest:(NSString *)url
             requestMethod:(YTKRequestMethod)method
            withParameters:(NSDictionary *)args
               whenSeccsss:(YTKRequestCompletionBlock)sucBlock
                whenFailed:(YTKRequestCompletionBlock)failBlock;

// 执行POST请求
- (void)performPostRequest:(NSString *)url
            withParameters:(NSDictionary *)args
               whenSeccsss:(YTKRequestCompletionBlock)sucBlock
                whenFailed:(YTKRequestCompletionBlock)failBlock;

- (void)retry;

@end


// 调试机制，目前只用于debug模式下的日志打印
@interface HDebugStrategy : NSObject <HRequestStrategy>

@end

// 错误机制，可用于上传错误日志
@interface HLogErrorStrategy  : NSObject <HRequestStrategy>

@end

// 重试机制，用于出错时重试
@interface HRetryStrategy : NSObject <HRequestStrategy>
@property (nonatomic) NSInteger tryMax;//请求次数，默认为3（出错时重试2次）
@end



@interface HRequestDAOFactory : NSObject

// 简单的HTTPReques对象
+ (HRequestDAO *)createSimpleRequest;

// 包含打印、上传错误日志、失败重试等功能
+ (HRequestDAO *)createPowerfullRequest;

@end
