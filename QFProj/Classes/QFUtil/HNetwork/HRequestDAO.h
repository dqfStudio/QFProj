//
//  HRequestDAO.h
//  HProjectModel1
//
//  Created by dqf on 2019/1/25.
//  Copyright © 2019年 dqf. All rights reserved.
//

#import "HRequestDAOStrategy.h"

@interface HRequestDAO : HRequest
// 添加策略
- (void)addStrategy:(id<HRequestStrategy>)strategy;
// 执行GET请求
- (void)performGetRequest:(NSString *)url
           withParameters:(NSDictionary *)args
              whenSeccsss:(YTKRequestCompletionBlock)sucBlock
               whenFailed:(YTKRequestCompletionBlock)failBlock;
// 执行POST请求
- (void)performPostRequest:(NSString *)url
            withParameters:(NSDictionary *)args
               whenSeccsss:(YTKRequestCompletionBlock)sucBlock
                whenFailed:(YTKRequestCompletionBlock)failBlock;
@end
