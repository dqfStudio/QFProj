//
//  HRequestDAOStrategy.h
//  QFProj
//
//  Created by wind on 2019/7/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HRequest.h"

@protocol HRequestStrategy <YTKRequestAccessory>
@optional
// 请求成功，调用成功block之前调用此方法
- (void)beforePerformSuccessBlock:(HRequest *)req;

// 请求成功，调用成功block之后调用此方法
- (void)afterPerformSuccessBlock:(HRequest *)req;

/* 请求失败，调用成功block之前调用此方法；
 * 返回NO，则截断之后的调用（包括其他的beforePerformFailedBlock方法、
 * failureCompletionBlock、afterPerformFailedBlock方法）
 */
- (BOOL)beforePerformFailedBlock:(HRequest *)req;

// 请求失败，调用失败block之后调用此方法
- (void)afterPerformFailedBlock:(HRequest *)req;
@end

// 调试机制，目前只用于debug模式下的日志打印
@interface HDebugStrategy : NSObject <HRequestStrategy>

@end
// 错误机制，可用于上传错误日志
@interface HLogErrorStrategy : NSObject <HRequestStrategy>

@end
// 重试机制，用于出错时重试
@interface HRetryStrategy : NSObject <HRequestStrategy>
@property (nonatomic) NSInteger tryMax;//请求次数，默认为3（出错时重试2次）
@end
// 轮询机制，用于出错时轮询访问
@interface HPollingStrategy : NSObject <HRequestStrategy>
@property (nonatomic, copy) NSArray *pollingArr;//需要轮询的URL数组
@end
