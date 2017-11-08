//
//  MGRequestManager.h
//  MGMobileMusic
//
//  Created by MikeWang on 2016/7/11.
//  Copyright © 2016年 migu. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFNetworking.h"

@interface MGRequestManager : NSObject

//@property (nonatomic, readonly) AFHTTPSessionManager *sessionManager;
/**
 *  网络请求工具类，使用时不需要再传url地址，使用默认地址
 *  http://app.c.nf.migu.cn/MIGUM2.0/v1.0/
 *
 *  @return
 */
+ (MGRequestManager *)manager;

/**
 *  网络请求工具类，使用时需要自己传入url
 *
 *  @return
 */
+ (MGRequestManager *)managerWithoutUrl;


/**
*  网络请求工具类，使用debug host
* http://218.200.227.207:18089/MIGUM2.0/v1.0/;
*
 @return
 */
+ (MGRequestManager*)managerWithDebugHost;


/**
* 网络请求工具类, 使用Product host
* http://app.pd.nf.migu.cn/MIGUM2.0/v1.0/
*
 @return
 */
+ (MGRequestManager*)managerWithProductHost;


/**
* 网络请求工具类, 使用user host
*  http://app.u.nf.migu.cn/MIGUM2.0/v1.0/
*
 @return
 */
+ (MGRequestManager*)managerWithUserHost;



/**
 *
 *
 *  @return ua ,version parameter
 */

- (NSMutableDictionary *)defaultParameter;

/**
 *  某些用户请求需要添加更多地Header 头信息
 *
 *  @return
 */
- (void)addHeaderWithLoginInfo;

/**
 *  请求头部添加用户信息
 */
- (void)addHeaderWithUserInfo;

/**
 *  取消所有网络请求
 */
- (void)cancelAllRequest;



// 请求不合法时，处理错误信息，例如：弹出toast
+ (void)dealError:(id)errorObject;

// 打印请求成功的内容
+ (void)logSuccess:(NSURLSessionDataTask *)task
            params:(NSDictionary *)params
    responseObject:(id)responseObject;

// 打印请求失败的内容
+ (void)logError:(NSURLSessionDataTask *)task
          params:(NSDictionary *)params
           error:(NSError *)error;

@end
