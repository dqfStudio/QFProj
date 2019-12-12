//
//  HRequestDAOFactory.h
//  QFProj
//
//  Created by dqf on 2019/7/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HRequestDAO.h"

// 基础HTTP请求类实例
#ifndef kSimpleHTTPReq
#define kSimpleHTTPReq  ([HRequestDAOFactory createSimpleRequest])
#endif

// 重试的HTTP请求类实例
#ifndef kRetryHTTPReq
#define kRetryHTTPReq(count)   ([HRequestDAOFactory createRetryRequest:count])
#define kRetryDefaultHTTPReq   ([HRequestDAOFactory createRetryRequest:2])
#endif

// 轮询的HTTP请求类实例
#ifndef kPollingHTTPReq
#define kPollingHTTPReq(array) ([HRequestDAOFactory createPollingRequest:array])
#define kPollingDefaultHTTPReq ([HRequestDAOFactory createPollingRequest:nil])
#endif

@interface HRequestDAOFactory : NSObject

// 简单的HTTPReques对象
+ (HRequestDAO *)createSimpleRequest;

// 包含打印、上传错误日志、失败重试等功能
+ (HRequestDAO *)createRetryRequest:(NSInteger)count;

// 包含打印、上传错误日志、失败重试等功能
+ (HRequestDAO *)createPollingRequest:(NSArray *)pollingArr;

@end
