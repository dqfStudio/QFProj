//
//  HNetworkConfig.h
//  QFProj
//
//  Created by wind on 2019/7/19.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFSecurityPolicy.h>
#import "YTKNetworkConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface HNetworkConfig : NSObject
///  Request base URL, such as "http://www.baidu.com". Default is empty string.
@property (nonatomic, strong) NSString *baseUrl;
+ (HNetworkConfig *)sharedConfig;
@end

NS_ASSUME_NONNULL_END
