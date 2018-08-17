//
//  HAnalogNetworkManager.h
//  QFProj
//
//  Created by dqf on 2018/8/17.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HAutoFill.h"

typedef void(^HNetworkSuccessBlock)(id result);
typedef void(^HNetworkFailureBlock)(NSError *error);

@interface HAnalogNetworkManager : NSObject

+ (instancetype)shareInstance;

- (void)getDataWithClass:(Class)cls success:(HNetworkSuccessBlock)success  failure:(HNetworkFailureBlock)failure;

@end
