//
//  HNetWorkingManager.h
//  QFProj
//
//  Created by wind on 2020/1/21.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface HNetWorkingManager : AFHTTPSessionManager

+ (instancetype)shareManager;

#pragma mark - 查找可用URL

- (void)findUsableURL:(NSArray *)urlArr callback:(void (^)(NSString *))handler;

@end
