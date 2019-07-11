//
//  HRequestDAOFactory.h
//  QFProj
//
//  Created by wind on 2019/7/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HRequestDAO.h"

// 基础HTTP请求类实例
#ifndef kSimpleHTTPReq
#define kSimpleHTTPReq  ([HRequestDAOFactory createSimpleRequest])
#endif

// 重试的HTTP请求类实例
#ifndef kRetryHTTPReq
#define kRetryHTTPReq   ([HRequestDAOFactory createRetryRequest])
#endif

// 轮询的HTTP请求类实例
#ifndef kPollingHTTPReq
#define kPollingHTTPReq ([HRequestDAOFactory createPollingRequest])
#endif

@interface HRequestDAOFactory : NSObject

// 简单的HTTPReques对象
+ (HRequestDAO *)createSimpleRequest;

// 包含打印、上传错误日志、失败重试等功能
+ (HRequestDAO *)createRetryRequest;

// 包含打印、上传错误日志、失败重试等功能
+ (HRequestDAO *)createPollingRequest;

@end
