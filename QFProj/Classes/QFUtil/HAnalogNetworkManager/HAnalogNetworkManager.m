//
//  HAnalogNetworkManager.m
//  QFProj
//
//  Created by dqf on 2018/8/17.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HAnalogNetworkManager.h"

@implementation HAnalogNetworkManager

+ (instancetype)shareInstance {
    static HAnalogNetworkManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)getDataWithClass:(Class)cls success:(HNetworkSuccessBlock)success failure:(HNetworkFailureBlock)failure {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (success) {
            success([cls autoFill]);
        }else if (failure) {
            failure(NSError.new);
        }
    });
}

@end
